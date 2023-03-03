import UIKit

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
    var delegate:NewSpotFormViewControllerProtocol?
    lazy var viewModel = {
       NewSpotViewModel()
    }()
    
    private enum UIConstants {
        static let textViewHeight = 250.0
        static let confirmRightAnch = 20.0
        static let imageHeight = 80.0
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
        
        confirmButton.setTitle(Resources.Titles.confirm, for: .normal)
        self.disableConfirmButton()
        
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
        
        addedImageView.contentMode = .scaleAspectFit
        
        preferredTypeButton.setTitleColor(.lightGray, for: .normal)
        preferredTypeButton.setTitle(Resources.Titles.generic, for: .normal)
        preferredTypeButton.semanticContentAttribute = .forceRightToLeft
        preferredTypeButton.setImage(UIImage(systemName: Resources.Images.edit,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        preferredTypeButton.tintColor = .lightGray
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
            addedImageView.centerYAnchor.constraint(equalTo: pinPhotoButton.centerYAnchor),
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
}


//MARK: - TextFieldDelegate
extension NewSpotFormViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case titleTextField:
            break
        case shortInfoTextField:
            break
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
        }
    }
}


//MARK: - Private methods
extension NewSpotFormViewController {
    private func disableConfirmButton() {
        confirmButton.setTitleColor(.gray, for: .normal)
        confirmButton.isEnabled = false
    }
    
    private func enableConfirmButton() {
        confirmButton.setTitleColor(UIColor(named: Resources.Colors.mainColor), for: .normal)
        confirmButton.isEnabled = true
    }
}
