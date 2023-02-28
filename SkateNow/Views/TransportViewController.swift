import UIKit

class TransportViewController: BaseAccountViewController {
    let scooterImageView = UIImageView()
    let scateboardImageView = UIImageView()
    let bmxImageView = UIImageView()
    let scateboardStackView = UIStackView()
    let scooterStackView = UIStackView()
    let bmxStackView = UIStackView()
    let confirmButton = UIButton()
    let scateBoardDownTriangleImageView = UIImageView()
    let scooterDownTriangleImageView = UIImageView()
    let bmxDownTriangleImageView = UIImageView()
    
    lazy var viewModel = {
       TransportViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad(userEmail: super.currentUser?.email)
        viewModel.stateChanged = {[weak self] state in
            guard let self = self else {return}
            switch state {
            case .choosen:
                self.activateConfirmButton()
                break
            case .notChoosen:
                self.present(self.createInfoAlert(message: "Nothing was chosen", title: Resources.Titles.errorTitle),animated: true)
                break
            case .beforeChoosen:
                self.navigationController?.setViewControllers([MenuViewController()], animated: true)
                break
            case .fetching:
                self.fetching()
            case .success:
                self.successSetTransport()
            }
        }
        viewModel.errorHandler = {[weak self] errorMessage in
            guard let self = self else {return}
            self.present(self.createInfoAlert(message: errorMessage, title: Resources.Titles.errorTitle), animated: true)
        }
    }
}


//MARK: - Configure VC
extension TransportViewController {
    override func addViews() {
        super.addViews()
        view.addView(scateboardStackView)
        view.addView(scooterStackView)
        view.addView(bmxStackView)
        view.addView(confirmButton)
        view.addView(scateBoardDownTriangleImageView)
        view.addView(scooterDownTriangleImageView)
        view.addView(bmxDownTriangleImageView)
    }
    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = true
        
        self.configureVertStackView(scateboardStackView)
        self.configureVertStackView(bmxStackView)
        self.configureVertStackView(scooterStackView)
        self.configureDownTriangleImageView(scateBoardDownTriangleImageView)
        self.configureDownTriangleImageView(scooterDownTriangleImageView)
        self.configureDownTriangleImageView(bmxDownTriangleImageView)
        
        let scateboardLabel = UILabel()
        scateboardLabel.text = Resources.Titles.scateboard.uppercased()
        scateboardLabel.font = .boldSystemFont(ofSize: 16)
        
        scateboardImageView.image = UIImage(named: Resources.Images.scateboard)
        scateboardImageView.contentMode = .scaleAspectFit
        scateboardImageView.layer.masksToBounds = true
        scateboardStackView.addArrangedSubview(scateboardImageView)
        scateboardStackView.addArrangedSubview(scateboardLabel)
        
        let scateboardGestureRecogn = UITapGestureRecognizer(target: self, action: #selector(scateboardTapped(_:)))
        scateboardStackView.addGestureRecognizer(scateboardGestureRecogn)
        
        let scooterLabel = UILabel()
        scooterLabel.text = Resources.Titles.scooter.uppercased()
        scooterLabel.font = .boldSystemFont(ofSize: 16)
        
        scooterImageView.image = UIImage(named: Resources.Images.scooter)
        scooterImageView.layer.masksToBounds = true
        scooterStackView.addArrangedSubview(scooterImageView)
        scooterStackView.addArrangedSubview(scooterLabel)
        
        let scooterGestureRecogn = UITapGestureRecognizer(target: self, action: #selector(scooterTapped(_:)))
        scooterStackView.addGestureRecognizer(scooterGestureRecogn)
        
        let bmxLabel = UILabel()
        bmxLabel.text = Resources.Titles.bmx.uppercased()
        bmxLabel.font = .boldSystemFont(ofSize: 16)
        
        bmxImageView.image = UIImage(named: Resources.Images.bmx)
        bmxImageView.layer.masksToBounds = true
        bmxStackView.addArrangedSubview(bmxImageView)
        bmxStackView.addArrangedSubview(bmxLabel)
        
        let bmxGestureRecogn = UITapGestureRecognizer(target: self, action: #selector(bmxTapped(_:)))
        bmxStackView.addGestureRecognizer(bmxGestureRecogn)
        
        self.configureConfirmButton(confirmButton, Resources.Titles.getStarted)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func layoutViews() {
        super.layoutViews()
        NSLayoutConstraint.activate([
            scateboardStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            scateboardStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scooterImageView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 5),
            scooterImageView.heightAnchor.constraint(equalTo: scooterImageView.widthAnchor),
            scateboardImageView.widthAnchor.constraint(equalTo: scooterImageView.widthAnchor),
            scateboardImageView.heightAnchor.constraint(equalTo: scooterImageView.heightAnchor),
            scooterStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            scooterStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            bmxImageView.widthAnchor.constraint(equalTo: scooterImageView.widthAnchor),
            bmxImageView.heightAnchor.constraint(equalTo: scooterImageView.heightAnchor),
            bmxStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            bmxStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            confirmButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            scateBoardDownTriangleImageView.centerXAnchor.constraint(equalTo: scateboardStackView.centerXAnchor),
            scateBoardDownTriangleImageView.bottomAnchor.constraint(equalTo: scateboardStackView.topAnchor, constant: -15),
            scooterDownTriangleImageView.centerXAnchor.constraint(equalTo: scooterStackView.centerXAnchor),
            scooterDownTriangleImageView.bottomAnchor.constraint(equalTo: scateBoardDownTriangleImageView.bottomAnchor),
            bmxDownTriangleImageView.centerXAnchor.constraint(equalTo: bmxStackView.centerXAnchor),
            bmxDownTriangleImageView.bottomAnchor.constraint(equalTo: scateBoardDownTriangleImageView.bottomAnchor)
        ])
    }
}


//MARK: - Private methods
extension TransportViewController {
    private func configureVertStackView(_ stackView:UIStackView) {
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.axis = .vertical
    }
    
    private func configureDownTriangleImageView(_ downTriangle:UIImageView) {
        downTriangle.image = UIImage(systemName: Resources.Images.downTriangle, withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        downTriangle.tintColor = UIColor(named: Resources.Colors.mainColor)
        downTriangle.isHidden = true
    }
    
    private func activateConfirmButton() {
        self.confirmButton.isEnabled = true
        self.confirmButton.backgroundColor = UIColor(named: Resources.Colors.mainColor)
    }
    
    private func fetching() {
        self.confirmButton.isEnabled = false
        self.createSpinnerView()
    }
    
    private func successSetTransport() {
        self.viewModel.saveUserDef()
        navigationController?.setViewControllers([MenuViewController()], animated: true)
    }
    
    @objc private func scooterTapped(_ sender:UITapGestureRecognizer) {
        scateBoardDownTriangleImageView.isHidden = true
        bmxDownTriangleImageView.isHidden = true
        scooterDownTriangleImageView.isHidden = false
        self.viewModel.setTransport(transport: Transport.scooter)
    }
    
    @objc private func scateboardTapped(_ sender:UITapGestureRecognizer) {
        bmxDownTriangleImageView.isHidden = true
        scooterDownTriangleImageView.isHidden = true
        scateBoardDownTriangleImageView.isHidden = false
        self.viewModel.setTransport(transport: Transport.skate)
    }
    
    @objc private func bmxTapped(_ sender:UITapGestureRecognizer) {
        scooterDownTriangleImageView.isHidden = true
        scateBoardDownTriangleImageView.isHidden = true
        bmxDownTriangleImageView.isHidden = false
        self.viewModel.setTransport(transport: Transport.bmx)
    }
}


//MARK: - Button method
extension TransportViewController {
    @objc private func confirmButtonTapped(_ sender:UIButton) {
        self.viewModel.userTapGetStartedButton(userEmail: super.currentUser?.email)
    }
}
