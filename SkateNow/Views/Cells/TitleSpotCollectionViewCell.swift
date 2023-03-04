import UIKit

class TitleSpotCollectionViewCell: UICollectionViewCell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        label.font = .systemFont(ofSize: 21)
        self.addView(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -10)
        ])
    }
    
    public func configureCell(text:String) {
        label.text = text
    }
}
