import UIKit

class TrickSlide: UIView {

    let imageView = UIImageView()
    let textView = UITextView()
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
        spinner.startAnimating()
        imageView.addView(spinner)
        
        textView.font = .systemFont(ofSize: 20)
        textView.isEditable = false
        self.addView(textView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            imageView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 10),
            textView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor,constant: -10),
            textView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor,constant: 10),
            textView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }
    
    public func hideSpinner() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        layoutIfNeeded()
    }
}
