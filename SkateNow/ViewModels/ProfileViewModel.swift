import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

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
    private var newnName:String?
    private var newTransport:String?
    
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
        alert.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { _ in
            picker.sourceType = .camera
            profileVC.present(picker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Choose from photo gallery", style: .default, handler: { _ in
            profileVC.present(picker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: Resources.Titles.cancel, style: .cancel))
        profileVC.present(alert, animated: true)
    }
    
    public func updateFields(_ user:UserFirebase?, _ nameTextField:UITextField,_ transportButton:UIButton) {
        guard let user = user else {return}
        db.collection(PrivateResources.usersCollection).document(user.email.lowercased()).getDocument(completion: { [weak self] (document, error) in
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
            
            //FIXME: - get images
        })
    }
    
    
    public func changeName(_ newName:String?) {
        self.newnName = newName
        self.state = .confirmChange
    }
    
    public func changeTransport(_ newTransport:String) {
        self.newTransport = newTransport
    }
    
    public func sendChange(_ user:UserFirebase?) {
        guard let user = user else {return}
        if let name = newnName {
            db.collection(PrivateResources.usersCollection).document(user.email).updateData([
                PrivateResources.usersNameKey: name
            ]) { err in
                if let err = err {
                    self.errorServerHandler?("Error update name: \(err)")
                    return
                }
            }
        }
        
        if let newTransport = newTransport {
            db.collection(PrivateResources.usersCollection).document(user.email).updateData([
                PrivateResources.usersTransportKey: newTransport
            ]) { err in
                if let err = err {
                    self.errorServerHandler?("Error update: \(err)")
                    return
                }
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
}
