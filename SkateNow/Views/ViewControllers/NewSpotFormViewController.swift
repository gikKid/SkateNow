import UIKit
import CoreLocation

protocol NewSpotFormViewControllerProtocol {
    func handleDismiss()
}

class NewSpotFormViewController: BottomSheetViewController {
    let confirmButton = UIButton()
    let cancelButton = UIButton()
    let titleTextField = UITextField()
    let shortInfoTextField = UITextField()
    let fullInfoTextView = UITextView()
    let preferredTypeLabel = UILabel()
    let preferredTypeButton = UIButton()
    let pinPhotoButton = UIButton()
    let addedImageView = UIImageView()
    let imagePicker = UIImagePickerController()
    var delegate:NewSpotFormViewControllerProtocol?
    lazy var viewModel = {
        NewSpotFormViewModel(coordinate)
    }()
    let coordinate:CLLocationCoordinate2D
    
    private enum UIConstants {
        static let textViewHeight = 250.0
        static let confirmRightAnch = 20.0
        static let imageHeight = 120.0
    }
    
    init(_ coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.stateHandler = { [weak self] state in
            guard let self = self else {return}
            switch state {
            case .notFilled:
                self.disableButton(self.confirmButton, .title)
            case .filled:
                self.enableButton(self.confirmButton, UIColor(named: Resources.Colors.mainColor) ?? .systemOrange, .title)
            case .sending:
                self.disableButton(self.confirmButton, .title)
                self.createSpinnerView()
            case .succesSent:
                self.hideSpinnerView()
                self.successfulySendRequestCompletion()
            case .errorSent(let errorMessage):
                self.enableButton(self.confirmButton, UIColor(named: Resources.Colors.mainColor) ?? .systemOrange, .title)
                self.hideSpinnerView()
                self.present(self.createInfoAlert(message: errorMessage, title: Resources.Titles.errorTitle),animated: true)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.configureBottomLineTextField(titleTextField, "Title")
        self.configureBottomLineTextField(shortInfoTextField, "Short info")
    }
}


//MARK: - Configure VC
extension NewSpotFormViewController {
    override func addViews() {
        super.addViews()
        containerView.addView(confirmButton)
        containerView.addView(cancelButton)
        containerView.addView(titleTextField)
        containerView.addView(shortInfoTextField)
        containerView.addView(fullInfoTextView)
        containerView.addView(preferredTypeLabel)
        containerView.addView(preferredTypeButton)
        containerView.addView(pinPhotoButton)
        containerView.addView(addedImageView)
    }
    
    override func configure() {
        super.configure()
        
        let VCViewGestureRecogn = UITapGestureRecognizer(target: self, action: #selector(userTapPresentedVC(_:)))
        self.view.addGestureRecognizer(VCViewGestureRecogn)
        
        confirmButton.setTitle(Resources.Titles.confirm, for: .normal)
        self.disableButton(confirmButton, .title)
        confirmButton.addTarget(self, action: #selector(userTapConfirmButton), for: .touchUpInside)
        
        cancelButton.setTitle(Resources.Titles.cancel, for: .normal)
        cancelButton.setTitleColor(UIColor(named: Resources.Colors.mainColor), for: .normal)
        cancelButton.addTarget(self, action: #selector(userTapCancelButton), for: .touchUpInside)
        
        titleTextField.delegate = self
        titleTextField.font = .systemFont(ofSize: 19)
        
        shortInfoTextField.delegate = self
        shortInfoTextField.font = .systemFont(ofSize: 17)
        shortInfoTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        
        fullInfoTextView.delegate = self
        fullInfoTextView.backgroundColor = .secondarySystemBackground
        fullInfoTextView.font = .systemFont(ofSize: 15)
        fullInfoTextView.text = Resources.Titles.fullInfo
        fullInfoTextView.textColor = .placeholderText
        
        preferredTypeLabel.text = "Preferred type:"
        preferredTypeLabel.font = .systemFont(ofSize: 20)
        
        pinPhotoButton.setTitleColor(.link, for: .normal)
        pinPhotoButton.setTitle("Pin photo", for: .normal)
        pinPhotoButton.addTarget(self, action: #selector(pinButtonTapped), for: .touchUpInside)
        
        addedImageView.contentMode = .scaleAspectFit
        
        preferredTypeButton.setTitleColor(.lightGray, for: .normal)
        preferredTypeButton.setTitle(Resources.Titles.generic, for: .normal)
        preferredTypeButton.semanticContentAttribute = .forceRightToLeft
        preferredTypeButton.setImage(UIImage(systemName: Resources.Images.edit,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        preferredTypeButton.tintColor = .lightGray
        preferredTypeButton.addTarget(self, action: #selector(userTapPreferredTypeButton), for: .touchUpInside)
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    override func layoutViews() {
        super.layoutViews()
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: UIConstants.confirmRightAnch),
            confirmButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -UIConstants.confirmRightAnch),
            cancelButton.centerYAnchor.constraint(equalTo: self.confirmButton.centerYAnchor),
            cancelButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: UIConstants.confirmRightAnch),
            titleTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleTextField.topAnchor.constraint(equalTo: self.cancelButton.bottomAnchor, constant: 20),
            titleTextField.widthAnchor.constraint(equalToConstant: self.view.frame.width / 3),
            shortInfoTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            shortInfoTextField.topAnchor.constraint(equalTo: self.titleTextField.bottomAnchor,constant: 15),
            shortInfoTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: UIConstants.confirmRightAnch),
            shortInfoTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -UIConstants.confirmRightAnch),
            fullInfoTextView.topAnchor.constraint(equalTo: self.shortInfoTextField.bottomAnchor, constant: 15),
            fullInfoTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            fullInfoTextView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            fullInfoTextView.heightAnchor.constraint(equalToConstant: UIConstants.textViewHeight),
            preferredTypeLabel.leftAnchor.constraint(equalTo: fullInfoTextView.leftAnchor),
            preferredTypeLabel.topAnchor.constraint(equalTo: fullInfoTextView.bottomAnchor, constant: 20),
            preferredTypeButton.rightAnchor.constraint(equalTo: fullInfoTextView.rightAnchor),
            preferredTypeButton.centerYAnchor.constraint(equalTo: preferredTypeLabel.centerYAnchor),
            pinPhotoButton.leftAnchor.constraint(equalTo: preferredTypeLabel.leftAnchor),
            pinPhotoButton.topAnchor.constraint(equalTo: preferredTypeLabel.bottomAnchor, constant: 20),
            addedImageView.topAnchor.constraint(equalTo: preferredTypeButton.bottomAnchor,constant: 10),
            addedImageView.rightAnchor.constraint(equalTo: fullInfoTextView.rightAnchor),
            addedImageView.heightAnchor.constraint(equalToConstant: UIConstants.imageHeight),
            addedImageView.widthAnchor.constraint(equalTo: addedImageView.heightAnchor)
        ])
    }
    
    override func animateDismissView() {
        super.animateDismissView()
        delegate?.handleDismiss()
    }
}


//MARK: - Buttons methods {
extension NewSpotFormViewController {
    @objc private func userTapCancelButton(_ sender:UIButton) {
        self.delegate?.handleDismiss()
        self.animateDismissView()
    }
    
    @objc private func userTapConfirmButton(_ sender:UIButton) {
        self.viewModel.sendRequest()
    }
    
    @objc private func userTapPreferredTypeButton(_ sender: UIButton) {
        self.viewModel.showTransportPopOver(preferredTypeButton, self, presentedViewController)
    }
    
    @objc private func pinButtonTapped(_ sender:UIButton) {
        self.viewModel.showImagePickerAlert(imagePicker, self)
    }
}


//MARK: - Private methods
extension NewSpotFormViewController {
    @objc private func userTapPresentedVC(_ sender:UITapGestureRecognizer) {
        presentedViewController?.dismiss(animated: true, completion: nil)
        self.preferredTypeButton.setImage(UIImage(systemName: Resources.Images.edit,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
    }
    
    private func successfulySendRequestCompletion() {
        let alert = UIAlertController(title: Resources.Titles.success, message: "New spot was successfuly sent!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Resources.Titles.confirmAlertActionTitle, style: .default) {_ in
            self.dismiss(animated: true)
        })
        self.present(alert,animated: true)
    }
}


//MARK: - TextFieldDelegate
extension NewSpotFormViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case titleTextField:
            self.viewModel.setDataTitle(textField)
        case shortInfoTextField:
            self.viewModel.setDataShortInfo(textField)
        default:
            break
        }
    }
}

//MARK: - TextViewDelegate
extension NewSpotFormViewController:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Resources.Titles.fullInfo {
            textView.text = nil
            textView.textColor = .darkText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Resources.Titles.fullInfo
            textView.textColor = .placeholderText
        } else {
            self.viewModel.setDataFullInfo(textView)
        }
    }
}



//MARK: - TransportPopOverVCDelegate
extension NewSpotFormViewController:TransportsPopOverViewControllerProtocol {
    func passSelectedTransport(_ newTransport: String) {
        self.viewModel.setDataPreferredType(newTransport)
        self.preferredTypeButton.setTitle(newTransport, for: .normal)
        self.preferredTypeButton.setImage(UIImage(systemName: Resources.Images.edit,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
    }
}


//MARK: - PopOverPresentationDelegate
extension NewSpotFormViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        false
    }
}


//MARK: - ImagePickerDelegate
extension NewSpotFormViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        self.addedImageView.image = image
        self.pinPhotoButton.setTitle("Edit photo", for: .normal)
        self.viewModel.setImage(image)
        picker.dismiss(animated: true, completion: nil)
    }
}
