import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

enum ProfileState {
    case fetching
    case successLogOut
}

final class ProfileViewModel:NSObject {
    let defaults = UserDefaults.standard
    var state:ProfileState? {
        didSet {
            guard let state = state else {return}
            stateChanged?(state)
        }
    }
    var errorHandle: ((String) -> Void)?
    var stateChanged: ((ProfileState) -> Void)?
    let db = Firestore.firestore()
    
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
            errorHandle?("Error signing out: \(signOutError)")
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
    
    public func updateNameTextField(_ user:UserFirebase?, _ nameTextField:UITextField) {
        guard let user = user else {return}
        db.collection(PrivateResources.usersCollection).document(user.email.lowercased()).getDocument(completion: { [weak self] (document, error) in
            guard let self = self else {return}
            if let error = error {
                self.errorHandle?("Fail to get your data \(error)")
                return
            }
            guard let document = document else {return}
            if let name = document.get(PrivateResources.usersNameKey) as? String {
                nameTextField.text = name
            }
        })
        
    }
}
