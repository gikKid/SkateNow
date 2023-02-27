import UIKit

class LoginViewController: BaseViewController {
    
    let signInButton = UIButton()
    let signUpButton = UIButton()
    
    lazy var viewModel = {
       LoginViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Configure VC
extension LoginViewController {
    override func addViews() {
        self.view.addView(signInButton)
        self.view.addView(signUpButton)
    }
    
    override func configure() {
        super.configure()
        self.navigationController?.navigationBar.isHidden = true
        
        self.configureConfirmButton(signInButton, Resources.Titles.signIn)
        self.configureConfirmButton(signUpButton, Resources.Titles.signUp)
        signUpButton.backgroundColor = .systemBlue
        signInButton.backgroundColor = .systemBlue
        signInButton.isEnabled = true
        signUpButton.isEnabled = true
        
        signInButton.addTarget(self, action: #selector(signInButtonTapped(_:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            signInButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -10),
            signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 180),
            signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalTo: signInButton.widthAnchor)
        ])
    }
}

//MARK: - Buttons methods
extension LoginViewController {
    @objc private func signInButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(SignInViewController(), animated: true)
    }
    
    @objc private func signUpButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}
