import UIKit

class StudyCollectionViewCell: UICollectionViewCell {
    let label = UILabel()
    var stars = [UIImageView]()
    let gradient = CAGradientLayer()
    let starsHorizontStackView = UIStackView()
    
    private enum UIConstants {
        static let countOfStars = 3
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(named: Resources.Colors.mainColor)
        
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        self.addView(label)
        
        starsHorizontStackView.alignment = .center
        starsHorizontStackView.axis = .horizontal
        starsHorizontStackView.distribution = .equalCentering
        
        self.addView(starsHorizontStackView)
        
        NSLayoutConstraint.activate([
            starsHorizontStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2),
            starsHorizontStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2),
            starsHorizontStackView.topAnchor.constraint(lessThanOrEqualTo: self.topAnchor, constant: 2),
            starsHorizontStackView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -5),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -5),
            label.leftAnchor.constraint(lessThanOrEqualTo: self.leftAnchor, constant: 5),
            label.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -2)
        ])
    }
    
    public func configureCell(_ cellModel:StudyCellModel) {
        label.text = cellModel.name
        
        if let level = cellModel.level {
            self.setStars(level: level)
            self.setBackgroundColor(level: level)
        }
        
        self.removeShimmer()
    }
    
    public func setShimmer() {
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.addSublayer(gradient)
        
        let animationGroup = self.makeAnimationGroup()
        animationGroup.beginTime = 0.0
        gradient.add(animationGroup, forKey: "backgroundColor")
        gradient.frame = self.bounds
    }
    
    private func removeShimmer() {
        self.gradient.removeFromSuperlayer()
    }
    
    private func setStars(level: Int) {
        for number in 0..<UIConstants.countOfStars{
            let starImageView = UIImageView(image: UIImage(systemName: number < level ? Resources.Images.starFill : Resources.Images.emptyStar))
            starImageView.tintColor = .systemYellow
            stars.append(starImageView)
            starsHorizontStackView.addArrangedSubview(starImageView)
        }
    }
    
    private func setBackgroundColor(level:Int) {
        switch level {
        case 1:
            self.backgroundColor = UIColor(named: Resources.Colors.firstLevelTrick)
        case 2:
            self.backgroundColor = UIColor(named: Resources.Colors.secondLevelTrick)
        case 3:
            self.backgroundColor = UIColor(named: Resources.Colors.thirdLevelTrick)
        default:
            break
        }
    }
}


extension StudyCollectionViewCell: SkeletonLoadable {}
