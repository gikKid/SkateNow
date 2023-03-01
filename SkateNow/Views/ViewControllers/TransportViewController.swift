import UIKit

class TransportViewController: BaseAccountViewController {
    let scooterImageView = UIImageView()
    let skateboardImageView = UIImageView()
    let bmxImageView = UIImageView()
    let skateboardStackView = UIStackView()
    let scooterStackView = UIStackView()
    let bmxStackView = UIStackView()
    let confirmButton = UIButton()
    let skateBoardDownTriangleImageView = UIImageView()
    let scooterDownTriangleImageView = UIImageView()
    let bmxDownTriangleImageView = UIImageView()
    let topTextLabel = UILabel()
    
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
                self.viewModel.saveUserDef()
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
        view.addView(skateboardStackView)
        view.addView(scooterStackView)
        view.addView(bmxStackView)
        view.addView(confirmButton)
        view.addView(skateBoardDownTriangleImageView)
        view.addView(scooterDownTriangleImageView)
        view.addView(bmxDownTriangleImageView)
        view.addView(topTextLabel)
    }
    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = true
        
        self.configureVertStackView(skateboardStackView)
        self.configureVertStackView(bmxStackView)
        self.configureVertStackView(scooterStackView)
        self.configureDownTriangleImageView(skateBoardDownTriangleImageView)
        self.configureDownTriangleImageView(scooterDownTriangleImageView)
        self.configureDownTriangleImageView(bmxDownTriangleImageView)
        
        let skateboardLabel = UILabel()
        skateboardLabel.text = Resources.Titles.skateboard.uppercased()
        skateboardLabel.font = .boldSystemFont(ofSize: 16)
        
        skateboardImageView.image = UIImage(named: Resources.Images.skateboard)
        skateboardImageView.contentMode = .scaleAspectFit
        skateboardImageView.layer.masksToBounds = true
        skateboardStackView.addArrangedSubview(skateboardImageView)
        skateboardStackView.addArrangedSubview(skateboardLabel)
        
        let skateboardGestureRecogn = UITapGestureRecognizer(target: self, action: #selector(skateboardTapped(_:)))
        skateboardStackView.addGestureRecognizer(skateboardGestureRecogn)
        
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
        
        topTextLabel.text = "What are you choose?"
        topTextLabel.font = .boldSystemFont(ofSize: 25)
    }
    
    override func layoutViews() {
        super.layoutViews()
        NSLayoutConstraint.activate([
            skateboardStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            skateboardStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scooterImageView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 5),
            scooterImageView.heightAnchor.constraint(equalTo: scooterImageView.widthAnchor),
            skateboardImageView.widthAnchor.constraint(equalTo: scooterImageView.widthAnchor),
            skateboardImageView.heightAnchor.constraint(equalTo: scooterImageView.heightAnchor),
            scooterStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            scooterStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            bmxImageView.widthAnchor.constraint(equalTo: scooterImageView.widthAnchor),
            bmxImageView.heightAnchor.constraint(equalTo: scooterImageView.heightAnchor),
            bmxStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            bmxStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            confirmButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            skateBoardDownTriangleImageView.centerXAnchor.constraint(equalTo: skateboardStackView.centerXAnchor),
            skateBoardDownTriangleImageView.bottomAnchor.constraint(equalTo: skateboardStackView.topAnchor, constant: -15),
            scooterDownTriangleImageView.centerXAnchor.constraint(equalTo: scooterStackView.centerXAnchor),
            scooterDownTriangleImageView.bottomAnchor.constraint(equalTo: skateBoardDownTriangleImageView.bottomAnchor),
            bmxDownTriangleImageView.centerXAnchor.constraint(equalTo: bmxStackView.centerXAnchor),
            bmxDownTriangleImageView.bottomAnchor.constraint(equalTo: skateBoardDownTriangleImageView.bottomAnchor),
            topTextLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topTextLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    override func userDataUpdate() {
        viewModel.viewDidLoad(userEmail: super.currentUser?.email)
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
        skateBoardDownTriangleImageView.isHidden = true
        bmxDownTriangleImageView.isHidden = true
        scooterDownTriangleImageView.isHidden = false
        self.viewModel.setTransport(transport: Transport.scooter)
    }
    
    @objc private func skateboardTapped(_ sender:UITapGestureRecognizer) {
        bmxDownTriangleImageView.isHidden = true
        scooterDownTriangleImageView.isHidden = true
        skateBoardDownTriangleImageView.isHidden = false
        self.viewModel.setTransport(transport: Transport.skate)
    }
    
    @objc private func bmxTapped(_ sender:UITapGestureRecognizer) {
        scooterDownTriangleImageView.isHidden = true
        skateBoardDownTriangleImageView.isHidden = true
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
