import UIKit

enum ColorButtonType {
    case background
    case tint
    case title
}

class BaseViewController: UIViewController {
    
    let childSpinner = SpinnerViewController()
    
    private enum UIConstants {
        static let confirmButtonCornerRadius = 13.0
        static let textFieldFont = 15.0
        static let textFieldCornerRadius = 6.0
    }

    override func viewDidLoad() {
        self.addViews()
        self.configure()
        self.layoutViews()
    }
}

@objc extension BaseViewController {
    public func addViews() {}
    public func configure() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        self.view.backgroundColor = .systemBackground
    }
    public func layoutViews() {}
    
    public func createInfoAlert(message:String, title:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Resources.Titles.confirmAlertActionTitle, style: .default, handler: nil))
        return alert
    }
}

extension BaseViewController {
    public func configureConfirmButton(_ button: UIButton,_ title: String) {
        button.setTitle(title, for: .normal)
        button.layer.masksToBounds = true
        button.isEnabled = false
        button.layer.cornerRadius = UIConstants.confirmButtonCornerRadius
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    public func configureTextField(_ textField: UITextField,_ placeholderText:String) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.placeholderText ])
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = UIConstants.textFieldCornerRadius
        textField.font = UIFont.systemFont(ofSize: UIConstants.textFieldFont)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.backgroundColor = .secondarySystemBackground
    }
    
    public func configureBottomLineTextField(_ textField:UITextField,_ placeholder:String) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [.paragraphStyle:centeredParagraphStyle])
    }
    
    public func createSpinnerView() {
        addChild(childSpinner)
        childSpinner.view.frame = view.frame
        view.addSubview(childSpinner.view)
        childSpinner.didMove(toParent: self)
    }
    
    public func hideSpinnerView() {
        childSpinner.willMove(toParent: nil)
        childSpinner.view.removeFromSuperview()
        childSpinner.removeFromParent()
    }
    
    public func disableButton(_ button:UIButton,_ colorType:ColorButtonType) {
        button.isEnabled = false
        
        switch colorType {
        case .background:
            button.backgroundColor = .lightGray
        case .title:
            button.setTitleColor(.gray, for: .normal)
        case .tint:
            button.tintColor = .gray
        }
    }
    
    public func enableButton(_ button:UIButton,_ color:UIColor,_ colorType:ColorButtonType) {
        button.isEnabled = true
        
        switch colorType {
        case .background:
            button.backgroundColor = color
        case .title:
            button.setTitleColor(color, for: .normal)
        case .tint:
            button.tintColor = color
        }
    }
}
