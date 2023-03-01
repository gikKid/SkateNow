import UIKit

class SignInViewController: SignBaseViewController {
    
    lazy var viewModel = {
       SignInViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.errorSignInHandler = {[weak self] errorText in
            guard let self = self else {return}
            self.hideSpinnerView()
            self.present(self.createInfoAlert(message: errorText, title: Resources.Titles.errorTitle),animated: true)
            self.activateConfirmButton()
        }
        
        self.viewModel.handleState = {[weak self] state in
            guard let self = self else {return}
            switch state {
            case .emptyEmail:
                self.unvalidEmail()
                break
            case .emptyPassword:
                self.unvalidPassword()
                break
            case .fetching:
                self.fetching()
                break
            case .valid:
                self.valid()
                break
            case .successSignInNewUser:
                self.successSignInNewUser()
                break
            case .successSignIn:
                self.navigationController?.setViewControllers([MenuViewController()], animated: true)
                break
            default:
                break
            }
        }
    }
}

//MARK: - Configure VC
extension SignInViewController {
    override func addViews() {
        super.addViews()
    }
    
    override func configure() {
        super.configure()
        title = Resources.Titles.signIn
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
        confirmButton.setTitle(Resources.Titles.confirm, for: .normal)
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func layoutViews() {
        super.layoutViews()
    }
}

//MARK: - TextField Delegate
extension SignInViewController:UITextFieldDelegate {
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
extension SignInViewController {
    @objc private func confirmButtonTapped(_ sender:UIButton) {
        self.viewModel.sendSignInRequest()
    }
    
    private func successSignInNewUser() {
        self.hideSpinnerView()
        self.navigationController?.setViewControllers([TransportViewController()], animated: true)
    }
}
