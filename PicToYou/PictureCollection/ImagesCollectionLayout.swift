import UIKit

final class ImagesCollectionLayout: UICollectionViewLayout {
    enum Constant {
        static let columnCount = 2
        static let cellHigh: CGFloat = 200
    }
    
    private var cacheAtributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var totalCellsHeight: CGFloat = 0
    
    func doubleCells(_ num: Int) -> Bool {
        return (num % 4) < 2
    }
    override func prepare() {
        cacheAtributes = [:]
        
        guard let collectionView = collectionView else { return }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        guard itemsCount > 0 else { return }
        
        let bigCellWidth = collectionView.frame.width
        let smallCellWidth = collectionView.frame.width / CGFloat(Constant.columnCount)
        
        var lastX: CGFloat = 0
        var lastY: CGFloat = 0
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item:  index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isBigCell = doubleCells(index)
            
            if isBigCell {
                attributes.frame = CGRect(
                    x: 0,
                    y: lastY,
                    width: bigCellWidth,
                    height: Constant.cellHigh
                )
                
                lastY += Constant.cellHigh
                
            } else {
                attributes.frame = CGRect(
                    x: lastX,
                    y: lastY,
                    width: smallCellWidth,
                    height: Constant.cellHigh
                )
                
                let isLastColumn = doubleCells(index + 1) || index == itemsCount - 1
                
                if isLastColumn {
                    lastX = 0
                    lastY += Constant.cellHigh
                } else {
                    lastX += smallCellWidth
                }
            }
            cacheAtributes[indexPath] = attributes
        }
        totalCellsHeight = lastY
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAtributes.values.filter{ attributes in
            return rect.intersects(attributes.frame )}
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cacheAtributes[indexPath]
    }
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.frame.width ?? 0, height: totalCellsHeight)
    }
}
