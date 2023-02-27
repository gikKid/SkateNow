import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    private let nameLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(with model:MenuCellOption) {
        self.nameLabel.text = model.title
        self.iconImageView.image = model.image
    }
}


extension MenuCollectionViewCell {
    private func configure() {
        self.backgroundColor = UIColor(named: Resources.Colors.mainColor)
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textColor = .white
        self.addView(nameLabel)
        self.addView(iconImageView)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 20),
            nameLabel.rightAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: self.rightAnchor, multiplier: -10),
            iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -10)
        ])
    }
}
