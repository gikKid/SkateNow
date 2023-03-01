import UIKit

class ProfileViewController: BaseAccountViewController {
    
    let backgroundImageView = UIImageView()
    let userAvatarImageView = UIImageView()
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    // transport choosing
    let darkThemeLabel = UILabel()
    let darkThemeSwitcher = UISwitch()
    let logOutButton = UIButton()
    var confirmChangesButton = UIBarButtonItem()
    let contentVertStackView = UIStackView()
    let scrollView = UIScrollView()
    let backgroundPhotoPicker = UIImagePickerController()
    let avatarPhotoPicker = UIImagePickerController()
    lazy var viewModel = {
       ProfileViewModel()
    }()
    
    private enum UIConstants {
        static let profileWidth:CGFloat = 80.0
        static let labelFont:CGFloat = 20.0
        static let textFieldWidth:CGFloat = 150.0
        static let rightStackViewAnchor:CGFloat = 20.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.checkDarkTheme(self.darkThemeSwitcher)
        self.viewModel.errorHandle = { [weak self] errorMessage in
            guard let self = self else {return}
            self.hideSpinnerView()
            self.logOutButton.isEnabled = true
            self.present(self.createInfoAlert(message: errorMessage, title: Resources.Titles.errorTitle),animated: true)
        }
        self.viewModel.stateChanged = {[weak self] state in
            guard let self = self else {return}
            switch state {
            case .successLogOut:
                self.navigationController?.setViewControllers([LoginViewController()], animated: true)
                break
            case .fetching:
                self.fetching()
            }
        }
    }
}


//MARK: - Configure VC
extension ProfileViewController {
    override func addViews() {
        super.addViews()
        view.addView(scrollView)
        scrollView.addView(backgroundImageView)
        scrollView.addView(userAvatarImageView)
        scrollView.addView(contentVertStackView)
    }
    
    override func configure() {
        super.configure()
        title = Resources.Titles.profile
        
        self.confirmChangesButton = UIBarButtonItem(title: Resources.Titles.confirm, style: .done, target: self, action: #selector(confirmChangesButtonTapped(_:)))
        self.disableConfirmChangesButton()
        navigationItem.rightBarButtonItems = [confirmChangesButton]
        
        backgroundImageView.backgroundColor = .systemGray5
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.isUserInteractionEnabled = true
        
        let backgroundImageViewGestureRecogn = UITapGestureRecognizer(target: self, action: #selector(backgroundImageViewTapped(_:)))
        backgroundImageView.addGestureRecognizer(backgroundImageViewGestureRecogn)

        userAvatarImageView.image = UIImage(named: Resources.Images.profileDefault)
        userAvatarImageView.layer.masksToBounds = false
        userAvatarImageView.layer.borderWidth = 2.5
        userAvatarImageView.layer.borderColor = UIColor.black.cgColor
        userAvatarImageView.layer.cornerRadius = UIConstants.profileWidth / 2
        userAvatarImageView.clipsToBounds = true
        userAvatarImageView.contentMode = .scaleAspectFill
        userAvatarImageView.backgroundColor = .white
        userAvatarImageView.isUserInteractionEnabled = true
        
        let userAvatarImageViewGestureRecogn = UITapGestureRecognizer(target: self, action: #selector(backgroundImageViewTapped(_:)))
        
        userAvatarImageView.addGestureRecognizer(userAvatarImageViewGestureRecogn)
        
        contentVertStackView.alignment = .fill
        contentVertStackView.spacing = 30
        contentVertStackView.axis = .vertical
        
        nameLabel.text = "Name:"
        nameLabel.font = .systemFont(ofSize: UIConstants.labelFont)
       
        self.configureTextField(nameTextField, "Write name")
        
        let nameHorizontStackView = UIStackView()
        nameHorizontStackView.alignment = .leading
        nameHorizontStackView.axis = .horizontal
        nameHorizontStackView.distribution = .equalSpacing
        nameHorizontStackView.addArrangedSubview(nameLabel)
        nameHorizontStackView.addArrangedSubview(nameTextField)
        
        darkThemeLabel.text = "Dark theme"
        darkThemeLabel.font = .systemFont(ofSize: UIConstants.labelFont)
        
        darkThemeSwitcher.addTarget(self, action: #selector(themeSwitcherTapped), for: .valueChanged)
        
        let themeHorizontStackView = UIStackView()
        themeHorizontStackView.alignment = .leading
        themeHorizontStackView.axis = .horizontal
        themeHorizontStackView.distribution = .equalSpacing
        themeHorizontStackView.addArrangedSubview(darkThemeLabel)
        themeHorizontStackView.addArrangedSubview(darkThemeSwitcher)
        
        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.setTitleColor(.red, for: .normal)
        logOutButton.titleLabel?.font = .boldSystemFont(ofSize: 21)
        logOutButton.addTarget(self, action: #selector(userTapLogOutButton(_:)), for: .touchUpInside)
        
        contentVertStackView.addArrangedSubview(nameHorizontStackView)
        contentVertStackView.addArrangedSubview(themeHorizontStackView)
        contentVertStackView.addArrangedSubview(logOutButton)
        
        self.configurePhotoPicker(backgroundPhotoPicker)
        self.configurePhotoPicker(avatarPhotoPicker)
    }
    
    override func layoutViews() {
        super.layoutViews()
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: UIConstants.textFieldWidth),
            backgroundImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 5.5),
            userAvatarImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            userAvatarImageView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -20),
            userAvatarImageView.widthAnchor.constraint(equalToConstant: UIConstants.profileWidth),
            userAvatarImageView.heightAnchor.constraint(equalTo: userAvatarImageView.widthAnchor),
            contentVertStackView.topAnchor.constraint(equalTo: userAvatarImageView.bottomAnchor,constant: 30),
            contentVertStackView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor,constant: -UIConstants.rightStackViewAnchor),
            contentVertStackView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor,constant: UIConstants.rightStackViewAnchor),
            contentVertStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentVertStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
}



//MARK: - Buttons methods
extension ProfileViewController {
    @objc private func confirmChangesButtonTapped(_ sender:UIButton) {
        
    }
    
    @objc private func userTapLogOutButton(_ sender: UIButton) {
        self.viewModel.signOut()
    }
}


//MARK: - Private methods
extension ProfileViewController {
    
    @objc private func themeSwitcherTapped(_ sender:UISwitch) {
        self.viewModel.switchTheme(sender.isOn)
    }
    
    private func disableConfirmChangesButton() {
        self.confirmChangesButton.tintColor = .gray
        self.confirmChangesButton.isEnabled = false
    }
    
    private func enableConfirmChangesButton() {
        self.confirmChangesButton.tintColor = .link
        self.confirmChangesButton.isEnabled = true
    }
    
    private func fetching() {
        self.logOutButton.isEnabled = false
        self.createSpinnerView()
    }
    
    private func configurePhotoPicker(_ picker:UIImagePickerController) {
        picker.allowsEditing = true
        picker.delegate = self
    }
    
    override func userDataUpdate() {
        self.viewModel.updateNameTextField(super.currentUser, nameTextField)
    }
    
    @objc private func backgroundImageViewTapped(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Change background", style: .default, handler: { [weak self] _ in
            guard let self = self else {return}
            self.viewModel.createPickerAlert(self.backgroundPhotoPicker, self)
        }))
        alert.addAction(UIAlertAction(title: "Change avatar", style: .default, handler: { [weak self] _ in
            guard let self = self else {return}
            self.viewModel.createPickerAlert(self.avatarPhotoPicker, self)
        }))
        alert.addAction(UIAlertAction(title: Resources.Titles.cancel, style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}


//MARK: - UIImagePickerDelegate
extension ProfileViewController:UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        switch picker {
        case backgroundPhotoPicker:
            self.backgroundImageView.image = image
        default:
            self.userAvatarImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


//MARK: - UITextFieldDelegate
extension ProfileViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
