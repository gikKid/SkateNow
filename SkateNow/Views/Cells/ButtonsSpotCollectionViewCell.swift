import UIKit

protocol ButtonsSpotCollectionViewCellProtocol {
    func showRoute()
    func createActivityVC()
}

class ButtonsSpotCollectionViewCell: UICollectionViewCell {
    let createRouteButton = UIButton()
    let shareButton = UIButton()
    var delegate:ButtonsSpotCollectionViewCellProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        createRouteButton.setTitle("Create route", for: .normal)
        createRouteButton.setTitleColor(.link, for: .normal)
        createRouteButton.addTarget(self, action: #selector(createRouteButtonTapped), for: .touchUpInside)
        
        shareButton.setImage(UIImage(systemName: Resources.Images.share,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        shareButton.setTitle(Resources.Titles.share, for: .normal)
        shareButton.setTitleColor(.link, for: .normal)
        shareButton.semanticContentAttribute = .forceRightToLeft
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        self.addView(createRouteButton)
        self.addView(shareButton)
        
        NSLayoutConstraint.activate([
            createRouteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            createRouteButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            shareButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            shareButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        ])
    }
    
    @objc private func createRouteButtonTapped(_ sender:UIButton) {
        delegate?.showRoute()
    }
    
    @objc private func shareButtonTapped(_ sender:UIButton) {
        delegate?.createActivityVC()
    }
}
