import Foundation
import FirebaseAuth

enum RegisterState {
    case valid
    case unvalidEmail
    case unvalidPassword
    case unvalid
    case fetching
    case success
}

final class SignUpViewModel:NSObject {
    var user = User(email: "", password: "")
    var state = RegisterState.unvalid {
        didSet {
            handleState?(state)
        }
    }
    var handleState: ((RegisterState) -> Void)?
    var errorRegisterHandler: ((String) -> Void)?
    
    public func passwordPassed(_ password:String?) {
        guard let password = password else {
            self.state = .unvalidPassword
            return}

        if password.trimmingCharacters(in: .whitespacesAndNewlines).count < 6 {
            self.state = .unvalidPassword
        } else {
            user.password = password
            self.state = .valid
        }
    }
    
    public func emailPassed(_ email: String?) {
        guard let email = email else {
            self.state = .unvalidEmail
            return}

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        if !isValidRegEx(regexStr: emailRegEx, object: email) {
            self.state = .unvalidEmail
        } else {
            user.email = email
        }
    }
    
    private func isValidRegEx(regexStr:String,object:String) -> Bool{
        let predicate = NSPredicate(format: "SELF MATCHES %@",regexStr)
        return predicate.evaluate(with: object)
    }
    
    public func createUser() {
        guard user.email != "" && user.password != "" else {return}
        
        self.state = .fetching
        
        Auth.auth().createUser(withEmail: user.email, password: user.password, completion: {[weak self] _, error in
            if let error = error {
                self?.errorRegisterHandler?(error.localizedDescription)
                return
            }
            self?.state = .success
        })
    }
}
