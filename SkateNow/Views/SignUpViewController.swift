import UIKit

class SignUpViewController: SignBaseViewController {
    
    lazy var viewModel = {
       SignUpViewModel()
    }()
    
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
                self.successCreating()
                break
            default:
                break
            }
        }
        
        viewModel.errorRegisterHandler = {[weak self] errorText in
            guard let self = self else {return}
            self.hideSpinnerView()
            self.present(self.createInfoAlert(message: errorText, title: Resources.Titles.errorTitle),animated: true)
        }
    }
}

//MARK: - Configure VC
extension SignUpViewController {
    override func addViews() {
        super.addViews()
    }
    
    override func configure() {
        super.configure()
        title = Resources.Titles.signUp
        confirmButton.addTarget(self, action: #selector(createButtonTapped(_:)), for: .touchUpInside)
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func layoutViews() {
        super.layoutViews()
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
    @objc private func createButtonTapped(_ sender:UIButton) {
        self.viewModel.createUser()
    }
    
    private func successCreating() {
        self.hideSpinnerView()
        navigationController?.pushViewController(SignInViewController(), animated: true)
    }
}
