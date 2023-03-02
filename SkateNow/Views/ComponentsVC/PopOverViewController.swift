import UIKit

class PopOverViewController: BaseViewController {

    let contentTableView = UITableView()
    var contentTableHeightConstraint:NSLayoutConstraint?
    
    private enum UIConstants {
        static let contentTableHeight:CGFloat = 100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.contentTableHeightConstraint?.constant = self.contentTableView.contentSize.height
    }
}

extension PopOverViewController {
    override func addViews() {
        self.view.addView(contentTableView)
    }
    
    override func configure() {
        contentTableView.backgroundColor = .clear
        contentTableView.tableFooterView = UIView()
        contentTableView.separatorStyle = .none
        contentTableView.register(UITableViewCell.self, forCellReuseIdentifier: Resources.Identefiers.popOverCell)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            contentTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            contentTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
        ])
        contentTableHeightConstraint = contentTableView.heightAnchor.constraint(equalToConstant: UIConstants.contentTableHeight)
        contentTableHeightConstraint?.isActive = true
    }
}
