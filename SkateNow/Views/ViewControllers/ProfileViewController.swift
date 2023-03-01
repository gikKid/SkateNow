import UIKit

class ProfileViewController: BaseAccountViewController {
    
    let backgroundImageView = UIImageView()
    let userAvatarImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


//MARK: - Configure VC
extension ProfileViewController {
    override func addViews() {
        super.addViews()
        
    }
    
    override func configure() {
        super.configure()
        title = Resources.Titles.profile
        
    }
    
    override func layoutViews() {
        super.layoutViews()
        
    }
}
