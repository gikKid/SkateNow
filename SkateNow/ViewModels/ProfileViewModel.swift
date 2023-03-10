import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


enum ProfileState {
    case fetching
    case successLogOut
    case confirmChange
    case successConfirmChange
}

final class ProfileViewModel:NSObject {
    private let defaults = UserDefaults.standard
    private var state:ProfileState? {
        didSet {
            guard let state = state else {return}
            stateChanged?(state)
        }
    }
    var errorHandlerLogOut: ((String) -> Void)?
    var errorServerHandler: ((String) -> Void)?
    var stateChanged: ((ProfileState) -> Void)?
    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    private var newnName:String?
    private var newTransport:String?
    private var newAvatarImage:UIImage?
    private var newBackgroundImage:UIImage?
    
    public func switchTheme(_ isOn:Bool) {
        if isOn {
            UIApplication.shared.windows.forEach({ window in
                window.overrideUserInterfaceStyle = .dark
            })
            defaults.set(true, forKey: Resources.Keys.isDarkTheme)
        } else {
            UIApplication.shared.windows.forEach({ window in
                window.overrideUserInterfaceStyle = .light
            })
            defaults.set(false, forKey: Resources.Keys.isDarkTheme)
        }
    }
    
    public func checkDarkTheme(_ switcher:UISwitch) {
        let isDarkTheme = defaults.bool(forKey: Resources.Keys.isDarkTheme)
        switcher.isOn = isDarkTheme ? true : false
    }
    
    public func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            self.state = .fetching
            try firebaseAuth.signOut()
            self.state = .successLogOut
            self.dropDefaultsData()
        } catch let signOutError as NSError {
            errorHandlerLogOut?("Error signing out: \(signOutError)")
        }
    }
    
    private func dropDefaultsData() {
        defaults.set(false, forKey: Resources.Keys.isChoosenTransport)
        defaults.set(false, forKey: Resources.Keys.isSignIn)
    }
    
    public func createPickerAlert(_ picker:UIImagePickerController,_ profileVC:ProfileViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Resources.Titles.takePhoto, style: .default, handler: { _ in
            picker.sourceType = .camera
            profileVC.present(picker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: Resources.Titles.chooseFromPhotoGallery, style: .default, handler: { _ in
            profileVC.present(picker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: Resources.Titles.cancel, style: .cancel))
        profileVC.present(alert, animated: true)
    }
    
    public func updateFields(_ user:UserFirebase?, _ nameTextField:UITextField,_ transportButton:UIButton, _ backgroundImageView:UIImageView,_ avatarImageView:UIImageView) {
        guard let user = user else {return}
        DispatchQueue.global(qos: .userInteractive).async {
            self.db.collection(PrivateResources.usersCollection).document(user.email.lowercased()).getDocument(completion: { [weak self] (document, error) in
                guard let self = self else {return}
                if let error = error {
                    self.errorServerHandler?("Fail to get your data \(error)")
                    return
                }
                guard let document = document else {return}
                if let name = document.get(PrivateResources.usersNameKey) as? String {
                    nameTextField.text = name
                }
                
                if let transport = document.get(PrivateResources.usersTransportKey) as? String {
                    transportButton.setTitle(transport, for: .normal)
                }
                
                if let backgroundImagePath = document.get(PrivateResources.usersBackgorundImageURLKey) as? String {
                    self.getImageData(path: backgroundImagePath, imageView: backgroundImageView)
                }
                
                if let avatarImagePath = document.get(PrivateResources.usersAvatarImageURLKey) as? String {
                    self.getImageData(path: avatarImagePath, imageView: avatarImageView)
                }
                
            })
        }
    }
    
    private func getImageData(path:String, imageView:UIImageView) {
        let islandPath = storageRef.child(path)
        DispatchQueue.global(qos: .userInitiated).async {
            islandPath.getData(maxSize: 1 * 1024 * 1024, completion: { [weak self] data, error in
                guard let self = self else {return}
                if let error = error {
                    self.errorServerHandler?("Fail to load image: \(error)")
                    return
                }
                
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    imageView.image = image
                }
            })
        }
    }
    
    public func changeName(_ newName:String?) {
        self.newnName = newName
        self.state = .confirmChange
    }
    
    public func changeTransport(_ newTransport:String) {
        self.newTransport = newTransport
        self.state = .confirmChange
    }
    
    public func changeAvatarImage(_ newAvatarImage:UIImage) {
        self.newAvatarImage = newAvatarImage
        self.state = .confirmChange
    }
    
    public func changeBackgroundImage(_ newBackgroundImage:UIImage) {
        self.newBackgroundImage = newBackgroundImage
        self.state = .confirmChange
    }
    
    public func sendChange(_ user:UserFirebase?) {
        guard let user = user else {return}
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            if let name = self.newnName {
                self.db.collection(PrivateResources.usersCollection).document(user.email).updateData([
                    PrivateResources.usersNameKey: name
                ]) { err in
                    if let err = err {
                        self.errorServerHandler?("Error update name: \(err)")
                        return
                    }
                }
            }
            
            if let newTransport = self.newTransport {
                self.db.collection(PrivateResources.usersCollection).document(user.email).updateData([
                    PrivateResources.usersTransportKey: newTransport
                ]) { err in
                    if let err = err {
                        self.errorServerHandler?("Error update: \(err)")
                        return
                    }
                }
            }
            
            if let newBackgroundImage = self.newBackgroundImage {
                self.uploadImage(image: newBackgroundImage, user: user, folderName: PrivateResources.backgroundStorageFolder, userFieldKey: PrivateResources.usersBackgorundImageURLKey)
            }
            
            if let newAvatarImage = self.newAvatarImage {
                self.uploadImage(image: newAvatarImage, user: user, folderName: PrivateResources.avatarsStorageFolder, userFieldKey: PrivateResources.usersAvatarImageURLKey)
            }
        }
        
        self.state = .successConfirmChange
    }
    
    public func showTransportPopOver(_ transportButton:UIButton,_ profileVC: ProfileViewController,_ presentedVC:UIViewController?) {
        if let image = transportButton.imageView?.image {
            
            if image == UIImage(systemName: Resources.Images.notEdit,withConfiguration: UIImage.SymbolConfiguration(scale: .large)) {
                transportButton.setImage(UIImage(systemName: Resources.Images.edit,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
                presentedVC?.dismiss(animated: true, completion: nil)
                return
            }
            
            let transportPopOverVC = TransportsPopOverViewController()
            transportPopOverVC.delegate = profileVC
            transportPopOverVC.modalPresentationStyle = .popover
            transportPopOverVC.preferredContentSize = CGSize(width:150, height: 110)
            
            guard let presentationVC = transportPopOverVC.popoverPresentationController else {return}
            presentationVC.delegate = profileVC
            presentationVC.sourceView = transportButton
            presentationVC.permittedArrowDirections = .down
            presentationVC.sourceRect = CGRect(x: transportButton.bounds.midX, y: transportButton.bounds.minY - 5, width: 0, height: 0)
            presentationVC.passthroughViews = [transportButton,profileVC.view]
            
            transportButton.setImage(UIImage(systemName: Resources.Images.notEdit,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            profileVC.present(transportPopOverVC,animated: true)
        }
    }
    
    private func uploadImage(image: UIImage,user:UserFirebase?,folderName:String, userFieldKey:String) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {return}
        guard let user = user else {return}
        let path = "\(folderName)/\(user.email).jpg"
        let fileRef = storageRef.child(path)
        
        let _ = fileRef.putData(imageData, metadata: nil, completion: { [weak self] (metadata, error) in
            guard let self = self else {return}
            if let error = error {
                self.errorServerHandler?("Fail to upload image: \(error)")
                return
            }
            
            self.db.collection(PrivateResources.usersCollection).document(user.email).updateData([
                userFieldKey: path
            ]) { err in
                if let err = err {
                    self.errorServerHandler?("Error update: \(err)")
                    return
                }
            }
        })
    }
}
