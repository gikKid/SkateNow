import UIKit
import FirebaseAuth

class BaseAccountViewController: BaseViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    var currentUser:UserFirebase?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener({[weak self]  _, user in
            guard let self = self else {return}
            guard let user = user else {
                print("no user")
                self.navigationController?.setViewControllers([LoginViewController()], animated: true)
                return
            }
            self.currentUser = UserFirebase(authData: user)
            print(user.uid)
            print(user.email)
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
}