import UIKit

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
    
}
