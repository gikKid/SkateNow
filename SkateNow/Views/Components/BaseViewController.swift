import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViews()
        self.configure()
        self.layoutViews()
    }
}

@objc extension BaseViewController {
    public func addViews() {}
    public func configure() {
        self.view.backgroundColor = .systemBackground
    }
    public func layoutViews() {}
    
    public func createErrorAlert(errorMessage:String) -> UIAlertController {
        let alert = UIAlertController(title: Resources.Titles.errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Resources.Titles.confirmAlertActionTitle, style: .default, handler: nil))
        return alert
    }
}
