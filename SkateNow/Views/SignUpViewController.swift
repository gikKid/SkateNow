import UIKit

class SignUpViewController: BaseViewController {
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let createButton = UIButton()
    let errorLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    lazy var viewModel = {
       SignUpViewModel()
    }()

    private enum UIConstants {
        static let leftAndRightSpaceTextField:CGFloat = 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.handleState = {[weak self] state in
            guard let self = self else {return}
            switch state {
            case .valid:
                self.valid()
                break
            case .unvalidPassword:
                self.unvalidPassword()
                break
            case .unvalidEmail:
                self.unvalidEmail()
                break
            case .fetching:
                self.fetching()
                break
            case .success:
                self.successRegister()
                break
            default:
                break
            }
        }
        
        viewModel.errorRegisterHandler = {[weak self] errorText in
            guard let self = self else {return}
            self.present(self.createInfoAlert(message: errorText, title: Resources.Titles.errorTitle),animated: true)
        }
    }
}

//MARK: - Configure VC
extension SignUpViewController {
    override func addViews() {
        self.view.addView(emailTextField)
        self.view.addView(passwordTextField)
        self.view.addView(createButton)
        self.view.addView(errorLabel)
        self.view.addView(activityIndicator)
    }
    
    override func configure() {
        super.configure()
        title = Resources.Titles.signUp
        
        self.configureTextField(emailTextField, Resources.Placeholders.email)
        self.configureTextField(passwordTextField, Resources.Placeholders.password)
        self.configureConfirmButton(createButton, Resources.Titles.create)
        createButton.addTarget(self, action: #selector(createButtonTapped(_:)), for: .touchUpInside)
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        emailTextField.returnKeyType = .next
        emailTextField.delegate = self
        passwordTextField.returnKeyType = .done
        passwordTextField.textContentType = .password
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        
        errorLabel.textColor = .red
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.isHidden = true
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
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
            createButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            createButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -10),
            activityIndicator.centerYAnchor.constraint(equalTo: createButton.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: createButton.centerXAnchor)
        ])
    }
}


//MARK: - TextFieldDelegate
extension SignUpViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            self.viewModel.emailPassed(textField.text)
            break
        case passwordTextField:
            self.viewModel.passwordPassed(textField.text)
            break
        default:
            break
        }
    }
}


//MARK: - Private methods
extension SignUpViewController {
    private func unvalidPassword() {
        self.setErrorLabel(text: Resources.Titles.unvalidPassword)
        self.deactivateCreateButton()
    }
    
    private func unvalidEmail() {
        self.setErrorLabel(text: Resources.Titles.unvalidEmail)
        self.deactivateCreateButton()
    }
    
    private func fetching() {
        self.createButton.isEnabled = false
        self.activityIndicator.startAnimating()
    }
    
    private func valid() {
        self.errorLabel.isHidden = true
        self.createButton.isEnabled = true
        self.activateCreateButton()
    }
    
    private func setErrorLabel(text:String) {
        self.errorLabel.text = text
        self.errorLabel.isHidden = false
    }
    
    private func activateCreateButton() {
        self.createButton.backgroundColor = .systemBlue
        self.createButton.isEnabled = true
    }
    
    private func deactivateCreateButton() {
        self.createButton.backgroundColor = .gray
        self.createButton.isEnabled = false
    }
    
    @objc private func createButtonTapped(_ sender:UIButton) {
        self.viewModel.createUser()
    }
    
    private func successRegister() {
        self.activityIndicator.stopAnimating()
        self.present(self.createInfoAlert(message: Resources.Titles.successRegisteringUser, title: Resources.Titles.success),animated: true)
        //FIXME: - LOGIC TO SAVE USER DATA !!!
        navigationController?.setViewControllers([MenuViewController()], animated: true)
    }
}
