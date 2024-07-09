import UIKit
import Kingfisher

class FavouriteTableViewCell: UITableViewCell {
   
    //MARK: - Private Properties
    
    private lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.boldSystemFont(ofSize: 20)
        authorLabel.textColor = .black
        return authorLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        return descriptionLabel
    }()
    
    private lazy var favouriteImage: UIImageView = {
        let favouriteImage = UIImageView()
        favouriteImage.translatesAutoresizingMaskIntoConstraints = false
        return favouriteImage
    }()

    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favouriteImage.image = nil
    }

    //MARK: - Setup Constraints
    
    private func setupLayout() {
        guard favouriteImage.superview == nil else { return }
        let textStackView = UIStackView(arrangedSubviews: [authorLabel, descriptionLabel])
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 20)
        textStackView.isLayoutMarginsRelativeArrangement = true
        textStackView.axis = .vertical
        contentView.addSubview(textStackView)
        contentView.addSubview(favouriteImage)
        
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            favouriteImage.widthAnchor.constraint(equalToConstant: 78),
            favouriteImage.heightAnchor.constraint(equalToConstant: 70),
            favouriteImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            favouriteImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }
    
    //MARK: - Configure Cells
        
    func configureCell(from model: FavouriteImageModel) {
        authorLabel.text = model.username
        descriptionLabel.text = model.name
        favouriteImage.kf.setImage(
            with: URL(string: model.photo_thumbnail),
            placeholder: nil,
            options: [.transition(ImageTransition.fade(1))]
        )
    }
}
