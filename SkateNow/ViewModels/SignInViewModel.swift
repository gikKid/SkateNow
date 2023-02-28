import FirebaseFirestore
import FirebaseAuth

enum SignInState {
    case emptyEmail
    case emptyPassword
    case valid
    case unvalid
    case fetching
    case successSignInNewUser
    case successSignIn
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
            guard let self = self else {return}
            if let error = error {
                self.errorSignInHandler?(error.localizedDescription)
                return
            }
            
            let db = Firestore.firestore()
            
            let docData:[String:Any] = [
                PrivateResources.usersNameKey: self.user.email.prefix(5),
                PrivateResources.usersVisitedSpotsKey: [""],
                PrivateResources.usersTransportKey: "",
                PrivateResources.usersDoneTricksKey: [""]
            ]
            
            let usersDocumentsRef = db.collection(PrivateResources.usersCollection)
            usersDocumentsRef.document(self.user.email.lowercased()).getDocument(completion: { (document, error) in
                if let document = document, !document.exists {
                    usersDocumentsRef.document(self.user.email.lowercased()).setData(docData) { err in
                        if let err = err {
                            self.errorSignInHandler?("Error create user: \(err.localizedDescription)")
                            return
                        }
                        self.saveUserData()
                        self.state = .successSignInNewUser
                    }
                } else {
                    
                }
            })
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
