import Foundation
import FirebaseAuth

enum SignInState {
    case emptyEmail
    case emptyPassword
    case valid
    case unvalid
    case fetching
    case success
}

final class SignInViewModel:NSObject {
    var user = User(email: "", password: "")
    var state = SignInState.unvalid {
        didSet {
            handleState?(state)
        }
    }
    var handleState: ((SignInState) -> Void)?
    var errorSignInHandler: ((String) -> Void)?
    
    
    public func emailPassed(_ email:String?) {
        guard let email = email else {return}
        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.state = .emptyEmail
        } else {
            self.user.email = email
        }
    }
    
    public func passwordPassed(_ password:String?) {
        guard let password = password else {return}
        if password.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.state = .emptyPassword
        } else {
            self.user.password = password
            self.state = .valid
        }

    }
    
    public func sendSignInRequest() {
        guard user.email != "" && user.password != "" else {return}
        
        self.state = .fetching
        
        Auth.auth().signIn(withEmail: user.email, password: user.password, completion: { [weak self] _, error in
            if let error = error {
                self?.errorSignInHandler?(error.localizedDescription)
                return
            }
            self?.saveUserData()
            self?.state = .success
        })
    }
    
    private func saveUserData() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Resources.Keys.isSignIn)
        do {
            try KeychainManager.save(service: Resources.Keys.service, email: user.email, password: user.password.data(using: .utf8) ?? Data())
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
