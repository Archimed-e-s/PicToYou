

import UIKit

protocol LikeViewDelegate: AnyObject {
    func likeViewDidTap(isFavourite: Bool, indexPath: IndexPath)
}
class LikeView: UIView {

    private var likeImageView = UIImageView()
    private var likeCounterLabel = UILabel()
    
    private var likeCount: Int = 0
    private var index: IndexPath?
    private var isSelected: Bool = false
    weak var delegate: LikeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(isLike: Bool, likeCount: Int) {
        self.likeCount = likeCount
        isSelected = isLike
        
        likeCounterLabel.text = isSelected ? String(likeCount + 1) : String(likeCount)
        likeImageView.alpha = isSelected ? 0.9 : 0.7
        
    }
    
    func setupIndex(index: IndexPath) {
        self.index = index
    }
    
    private func setupUI() {
        backgroundColor = .clear
        addSubviews()
        setupLikeImageView()
        setupLikeCounterLabel()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))
    }
    
    private func addSubviews() {
        addSubview(likeImageView)
        addSubview(likeCounterLabel)
    }
    
    @objc private func tapView() {
        animateTap()
        if let index = index {
            delegate?.likeViewDidTap(isFavourite: isSelected, indexPath: index)
            print(index)
        }
    }
    
    private func setupLikeImageView() {
        likeImageView.tintColor = .red.withAlphaComponent(0.8)
        likeImageView.image = UIImage(systemName: "heart.fill")
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        likeImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        likeImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        likeImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeImageView.widthAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    private func setupLikeCounterLabel() {
        likeCounterLabel.textColor = .white
        likeCounterLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        likeCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        likeCounterLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        likeCounterLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func animateTap() {
        isSelected.toggle()
        UIView.transition(
            with: self,
            duration: 0.3,
            animations: { [self] in
                likeCounterLabel.text = isSelected ? String(likeCount + 1) : String(likeCount)
                likeImageView.alpha = isSelected ? 0.9 : 0.7
                likeImageView.transform = isSelected ? CGAffineTransform(scaleX: 1.2, y: 1.2) : CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        )
    }
}
