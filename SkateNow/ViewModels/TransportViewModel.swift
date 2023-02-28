import Foundation
import FirebaseFirestore

enum Transport {
    case skate
    case scooter
    case bmx
    
    var title:String {
        switch self {
        case .skate:
            return "skate"
        case .scooter:
            return "scooter"
        case .bmx:
            return "bmx"
        }
    }
}

enum TransportViewState {
    case notChoosen
    case choosen
    case beforeChoosen
    case fetching
    case success
}

final class TransportViewModel:NSObject {
    
    private var state = TransportViewState.notChoosen {
        didSet {
            stateChanged?(state)
        }
    }
    var stateChanged: ((TransportViewState) -> Void)?
    var errorHandler: ((String) -> Void)?
    private var transport:Transport?
    private let db = Firestore.firestore()
    
    public func saveUserDef() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Resources.Keys.isChoosenTransport)
    }
    
    public func viewDidLoad(userEmail:String?) {
        guard let userEmail = userEmail else {
            return
        }
        db.collection(PrivateResources.usersCollection).document(userEmail).getDocument(completion: { [weak self] (document,error) in
            guard let self = self else {return}
            if let document = document, document.exists {
                if let userTransport = document.data()![PrivateResources.usersTransportKey] as? String {
                    if userTransport != "" {
                        self.state = .beforeChoosen
                    }
                }
            }
        })
    }
    
    public func setTransport(transport: Transport) {
        self.transport = transport
        self.state = .choosen
    }
    
    public func userTapGetStartedButton(userEmail:String?) {
        guard let userEmail = userEmail else {return}

        guard let transport = transport else {
            self.state = .notChoosen
            return
        }
        
        self.state = .fetching
        self.db.collection(PrivateResources.usersCollection).document(userEmail).updateData([
            PrivateResources.usersTransportKey: transport.title
        ]) { err in
            if let err = err {
                self.errorHandler?("Error update: \(err)")
            } else {
                self.state = .success
            }
        }
    }
}
