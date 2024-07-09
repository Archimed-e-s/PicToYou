import UIKit

extension ImagesCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionCell.id, for: indexPath) as? PictureCollectionCell else { return UICollectionViewCell.init() }
        cell.configure(url: URL(string: model[indexPath.item].urls?.small ?? ""), likeCount: model[indexPath.item].likes)
        cell.setupIndex(indexPath)
        cell.likeTapped = { [weak self] isFavourite in
            guard let self else { return }
            let item = model[indexPath.item]
            saveFavourite(from: item)
        }
        return cell
    }
}

extension ImagesCollectionViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxItem = indexPaths.map({ $0.item }).max(),
        maxItem > model.count - 3,
        !isPrefetchingProcessing
        else { return }
        isPrefetchingProcessing = true
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self else { return }
                ConfigAlamofire().getRandomPhotosAlamofire(count: 10) { result in
                switch result {
                case .success(let newModel):
                    guard let model = newModel else { return }
                    DispatchQueue.main.async{
                        self.model.append(contentsOf: model)
                        self.collectionVertical.reloadCollection()
                    }
                case .failure(let error):
                    print(error)
                }
                self.isPrefetchingProcessing = false
            }
        }
    }
}
