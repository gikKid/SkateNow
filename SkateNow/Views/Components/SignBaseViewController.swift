import UIKit

class SignBaseViewController: BaseViewController {
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let confirmButton = UIButton()
    let errorLabel = UILabel()
    
    private enum UIConstants {
        static let leftAndRightSpaceTextField:CGFloat = 50
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


//MARK: - Configure VC
extension SignBaseViewController {
    override func addViews() {
        self.view.addView(emailTextField)
        self.view.addView(passwordTextField)
        self.view.addView(confirmButton)
        self.view.addView(errorLabel)
    }
    
    override func configure() {
        super.configure()
        
        self.configureTextField(emailTextField, Resources.Placeholders.email)
        self.configureTextField(passwordTextField, Resources.Placeholders.password)
        self.configureConfirmButton(confirmButton, Resources.Titles.create)
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        
        errorLabel.textColor = .red
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.isHidden = true
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            emailTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: -35),
            emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 30),
            emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: UIConstants.leftAndRightSpaceTextField),
            emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -UIConstants.leftAndRightSpaceTextField),
            passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            passwordTextField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor),
            passwordTextField.rightAnchor.constraint(equalTo: emailTextField.rightAnchor),
            confirmButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -10),
        ])
    }
}


//MARK: - Methods
extension SignBaseViewController {
    
    public func unvalidPassword() {
        self.setErrorLabel(text: Resources.Titles.unvalidPassword)
        self.deactivateConfirmButton()
    }
    
    public func unvalidEmail() {
        self.setErrorLabel(text: Resources.Titles.unvalidEmail)
        self.deactivateConfirmButton()
    }
    
    public func fetching() {
        self.confirmButton.isEnabled = false
        self.createSpinnerView()
    }
    
    public func valid() {
        self.errorLabel.isHidden = true
        self.confirmButton.isEnabled = true
        self.activateConfirmButton()
    }
    
    public func setErrorLabel(text:String) {
        self.errorLabel.text = text
        self.errorLabel.isHidden = false
    }
    
    public func activateConfirmButton() {
        self.confirmButton.backgroundColor = UIColor(named: Resources.Colors.mainColor)
        self.confirmButton.isEnabled = true
    }
    
    public func deactivateConfirmButton() {
        self.confirmButton.backgroundColor = .gray
        self.confirmButton.isEnabled = false
    }
    
    public func successFetching(messageText:String) {
        self.hideSpinnerView()
        self.present(self.createInfoAlert(message: messageText, title: Resources.Titles.success),animated: true)
    }
}
