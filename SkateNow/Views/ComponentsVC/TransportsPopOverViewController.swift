import UIKit

protocol TransportsPopOverViewControllerProtocol {
    func passSelectedTransport(_ newTransport:String)
}

class TransportsPopOverViewController: PopOverViewController {
    var delegate:TransportsPopOverViewControllerProtocol?
    public var content:[String] = [Resources.Titles.skateboard,Resources.Titles.scooter,Resources.Titles.bmx]
}

extension TransportsPopOverViewController {
    override func configure() {
        super.configure()
        contentTableView.delegate = self
        contentTableView.dataSource = self
    }
}


extension TransportsPopOverViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Identefiers.popOverCell, for: indexPath)
        cell.textLabel?.text = self.content[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.passSelectedTransport(self.content[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
