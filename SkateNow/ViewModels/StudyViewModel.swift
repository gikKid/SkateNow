import FirebaseFirestore
import UIKit

enum StudyState {
    case fetching
    case failureFetch
    case successFetch
}

enum TransportType {
    case skateboard
    case scooter
    case bmx
}

final class StudyViewModel:NSObject {
    var state:StudyState? {
        didSet{
            guard let state = state else {return}
            stateHandler?(state)
        }
    }
    var stateHandler:((StudyState) -> Void)?
    var errorServerHandler: ((String) -> Void)?
    private let db = Firestore.firestore()
    private var userTransport:TransportType?
    var cellsData = [StudyCellModel]()
    
    
    public func numberOfItemsInSection() -> Int {
        return cellsData.count
    }
    
    public func getCellModel(_ indexPath:IndexPath) -> StudyCellModel {
        cellsData[indexPath.row]
    }
    
    public func fetchData(_ user:UserFirebase?) {
        guard let user = user else {return}
        self.state = .fetching
        DispatchQueue.global(qos: .userInitiated).async {
            self.db.collection(PrivateResources.usersCollection).document(user.email.lowercased()).getDocument(completion: { [weak self] (document,error) in
                guard let self = self else {
                    self?.state = .failureFetch
                    return
                }
                
                if let error = error {
                    self.errorServerHandler?("Failed to load data: \(error.localizedDescription)")
                    self.state = .failureFetch
                    return
                }
                
                guard let document = document else {
                    self.state = .failureFetch
                    return
                }
                
                if let transport = document.get(PrivateResources.usersTransportKey) as? String {
                    switch transport.lowercased() {
                    case Resources.Titles.skateboard.lowercased():
                        self.userTransport = .skateboard
                        self.fetchTransportTricksData(PrivateResources.skateTricksColletion)
                    case Resources.Titles.scooter:
                        self.userTransport = .scooter
                        self.fetchTransportTricksData(PrivateResources.scooterTricksCollection)
                    case Resources.Titles.bmx:
                        self.userTransport = .bmx
                        self.fetchTransportTricksData(PrivateResources.bmxTricksCollection)
                    default:
                        break
                    }
                }
            })
        }
    }
    
    public func fetchTransportTricksData(_ transportCollectionPath:String) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.db.collection(transportCollectionPath).getDocuments(completion: { [weak self] (querySnapshot, error) in
                guard let self = self else {return}
                
                defer {
                    self.state = .successFetch
                }
                
                if let error = error {
                    self.errorServerHandler?("Fail to load data: \(error.localizedDescription)")
                    self.state = .failureFetch
                }
                
                for document in querySnapshot!.documents {
                    let cellModel = StudyCellModel()
                    
                    if let name = document.get(PrivateResources.trickNameKey) as? String {
                        cellModel.name = name
                    } else {
                        continue
                    }
                    
                    if let level = document.get(PrivateResources.trickLevelKey) as? Int {
                        cellModel.level = level
                    } else {
                        continue
                    }
                    self.cellsData.append(cellModel)
                }
            })
        }
    }
    
}
