import UIKit

class PictureCollectionView: UIView {
    
    weak var delegate: ImagesCollectionViewController?
    
    private lazy var collectionVertical: UICollectionView = {
        let collectionVertical =  UICollectionView(frame: bounds, collectionViewLayout: ImagesCollectionLayout())
        addSubview(collectionVertical)
        collectionVertical.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionVertical.backgroundColor = .white
        collectionVertical.translatesAutoresizingMaskIntoConstraints = false
        collectionVertical.dataSource = delegate
        collectionVertical.prefetchDataSource = delegate
        collectionVertical.register(PictureCollectionCell.self, forCellWithReuseIdentifier: PictureCollectionCell.id)
        return collectionVertical
    }()
    
    init(delegate: ImagesCollectionViewController) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupRefreshControl()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginRefreshing() {
        collectionVertical.refreshControl?.beginRefreshing()
    }
    
    func endRefreshing() {
        collectionVertical.refreshControl?.endRefreshing()
    }
        
    func reloadCollection() {
        collectionVertical.reloadData()
    }
    
    private func setupRefreshControl() {
        collectionVertical.refreshControl = UIRefreshControl()
        collectionVertical.refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
        collectionVertical.refreshControl?.tintColor = .link
        collectionVertical.refreshControl?.addTarget(self, action: #selector(refreshImages), for: .valueChanged)
    }
    
    @objc func refreshImages() {
        delegate?.refreshImages()
    }
    
    func layout() {
        addSubview(collectionVertical)
        NSLayoutConstraint.activate([
            collectionVertical.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionVertical.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionVertical.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionVertical.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
