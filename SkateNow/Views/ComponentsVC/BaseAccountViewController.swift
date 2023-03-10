import UIKit
import FirebaseAuth

class BaseAccountViewController: BaseViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    var currentUser:UserFirebase? {
        didSet {
            userDataUpdate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async {
            self.handle = Auth.auth().addStateDidChangeListener({[weak self]  _, user in
                guard let self = self else {return}
                guard let user = user else {
                    let alert = UIAlertController(title: Resources.Titles.errorTitle, message: "Coudnt sign in", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Reconnect", style: .default, handler: {_ in
                        self.navigationController?.setViewControllers([LoginViewController()], animated: true)
                    }))
                    self.hideSpinnerView()
                    self.present(alert,animated: true)
                    return
                }
                self.currentUser = UserFirebase(authData: user)
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let handle = handle else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

@objc extension BaseAccountViewController {
    public func userDataUpdate() {}
}
