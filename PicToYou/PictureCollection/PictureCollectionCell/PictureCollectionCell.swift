import UIKit
import Kingfisher

class PictureCollectionCell: UICollectionViewCell {

    static let id = UUID().uuidString
    var likeTapped: ((Bool) -> Void)?
    
    private var index: IndexPath?
    private lazy var collectionImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var likeView: LikeView = {
        let view = LikeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configSubview()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Private Methods
    
    private func configSubview() {
        contentView.addSubview(collectionImageView)
        contentView.addSubview(likeView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        
            likeView.topAnchor.constraint(equalTo: collectionImageView.topAnchor, constant: 6),
            likeView.trailingAnchor.constraint(equalTo: collectionImageView.trailingAnchor, constant: -6),
            likeView.widthAnchor.constraint(equalToConstant: 70),
            likeView.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    //MARK: - Public Methods
    
    func configure(url: URL?, likeCount: Int?) {
        likeView.configure(isLike: false, likeCount: likeCount ?? 0 )
        collectionImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))])
        likeView.delegate = self
    }
    
    func setupIndex(_ index: IndexPath) {
        self.index = index
    }
}

    //MARK: - LikeViewDelegate

extension PictureCollectionCell: LikeViewDelegate {
    func likeViewDidTap(isFavourite: Bool, indexPath: IndexPath) {
        likeTapped?(isFavourite)
    }
}
