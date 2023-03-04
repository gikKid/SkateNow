import UIKit

class FullInfoCollectionViewCell: UICollectionViewCell {
    let textView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        textView.backgroundColor = .secondarySystemBackground
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .placeholderText
        textView.isEditable = false
        self.addView(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10),
            textView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    public func configureCell(text:String) {
        textView.text = text
    }
}
