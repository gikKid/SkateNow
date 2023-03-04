import UIKit

class ImageSpotCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    let spinner = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.imageView.contentMode = .scaleAspectFit
        self.addView(imageView)
        
        spinner.color = .gray
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    public func configureCell(image:UIImage) {
        self.imageView.image = image
    }
    
    public func showSpinner() {
        spinner.startAnimating()
        contentView.addView(spinner)
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        layoutIfNeeded()
    }
    
    public func hideSpinner() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        layoutIfNeeded()
    }
}
