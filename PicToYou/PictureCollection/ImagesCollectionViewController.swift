import UIKit
import Alamofire
import RealmSwift

class ImagesCollectionViewController: UIViewController {
    
    var model: [NetworkImageModel] = []
    private var configAlamofire: ConfigAlamofire = ConfigAlamofire()
    var isPrefetchingProcessing: Bool = false
    private let realmService = RealmServices()
    private let realm = try! Realm()
    lazy var collectionVertical: PictureCollectionView = {
        let collection = PictureCollectionView(delegate: self)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        view.backgroundColor = .gray
        configAlamofire.getRandomPhotosAlamofire(count: 20) { [weak self] result in
            switch result {
            case .success(let model):
                guard let models = model else { return }
                self?.model = models
                self?.collectionVertical.reloadCollection()
            case .failure(let error):
                switch error {
                case .invalidItemsCount:
                    print("Неверное количество загружаемых объектов")
                case .invalidParametersCount:
                    print("Неверное количество параметров запроса")
                case .AFError(let AFError):
                    print("Сервис работы завершил работу с ошибкой - \(AFError)")
                case .invalidURL:
                    print("Неправильный URL")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func layout() {
        view.addSubview(collectionVertical)
        
        NSLayoutConstraint.activate([
            collectionVertical.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionVertical.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionVertical.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionVertical.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    // MARK: - Public Methods

    func saveFavourite(from item: NetworkImageModel) {
        let model = FavouriteImageModel()
        model.id = UUID()
        model.username = item.user?.username ?? "username"
        model.name = item.user?.name ?? "name"
        model.photo_small = item.urls?.small ?? ""
        model.photo_thumbnail = item.urls?.thumb ?? ""
        model.views = item.views ?? 0
        model.downloads = item.downloads ?? 0
        model.likes = item.likes ?? 0
        do {
            try realmService.saveData(data: [model])
        } catch {
            print("error - \(error)")
        }
    }

}

//MARK: - Pull To Refresh

extension ImagesCollectionViewController {
    
    @objc func refreshImages() {
        collectionVertical.beginRefreshing()
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self else { return }
            self.configAlamofire.getRandomPhotosAlamofire(count: 3) { result in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        self.model.insert(contentsOf: model!, at: 0)
                        self.collectionVertical.reloadCollection()
                        self.collectionVertical.endRefreshing()
                    }
                case .failure(let error):
                    switch error {
                    case .invalidItemsCount:
                        print("Incorrect count load objects")
                    case .invalidParametersCount:
                        print("Incorrect count of request parameters")
                    case .AFError(let AFError):
                        print("The Load servise was finished self work with issue - \(AFError)")
                    case .invalidURL:
                        print("Неправильный URL")
                    }
                    self.collectionVertical.endRefreshing()
                }
            }
        }
    }
    

}

extension ImagesCollectionViewController: LikeViewDelegate {
    
    func likeViewDidTap(isFavourite: Bool, indexPath: IndexPath) {
        switch isFavourite {
        case true:
            realm.delete(model[indexPath.item].toRealmObject())
        case false:
            realm.add(model[indexPath.item].toRealmObject())
        }
    }
    
    
}
