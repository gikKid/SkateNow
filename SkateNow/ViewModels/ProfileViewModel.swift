import Foundation
import UIKit
import FirebaseAuth

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
}
