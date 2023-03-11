import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

enum TrickViewState {
    case successFetchData
}

final class TrickViewModel:NSObject {
 
    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    var serverErrorHandler: ((String) -> Void)?
    var trick:Trick
    var state:TrickViewState? {
        didSet {
            guard let state = state else {return}
            stateHandler?(state)
        }
    }
    var stateHandler:((TrickViewState) -> Void)?
    
    init(trickName:String) {
        self.trick = Trick(name: trickName)
    }
    
    public func loadTrickData(trickName:String,transportType:TransportType) {
        var trickCollection:String
        switch transportType {
        case .skateboard:
            trickCollection = PrivateResources.skateTricksColletion
        case .scooter:
            trickCollection = PrivateResources.scooterTricksCollection
        case .bmx:
            trickCollection = PrivateResources.bmxTricksCollection
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.db.collection(trickCollection).document(trickName).getDocument(completion: { [weak self] (document, error) in
                guard let self = self else {return}
                
                defer {
                    self.state = .successFetchData
                }
                
                if let error = error {
                    self.serverErrorHandler?("Fail to load data: \(error.localizedDescription)")
                }
                
                guard let document = document, document.exists else {return}
                
                if let description = document.get(PrivateResources.trickDescriptionKey) as? String {
                    self.trick.description = description
                }
                
                if let imagesURL = document.get(PrivateResources.trickImageURLKey) as? [String] {
                    self.trick.imagesURL = imagesURL
                }
            })
        }
    }
    
    public func configureViewFields(slides:[TrickSlide]) {
        guard let description = self.trick.description else {return}
        guard let imagesURL = self.trick.imagesURL else {return}
        let splitedText = description.components(separatedBy: "\n")
        
        for (index,slide) in slides.enumerated() {
            guard index < splitedText.count else {return}
            slide.textView.text = String(splitedText[index])
            self.loadImage(imageURL: imagesURL[index], slide: slide)
        }
    }
    
    public func updateUserButtonState(user:UserFirebase?,key:String,isEmpty:Bool) {
        guard let user = user else {return}
        
        if isEmpty {
            DispatchQueue.global(qos: .userInitiated).async {
                self.db.collection(PrivateResources.usersCollection).document(user.email.lowercased()).updateData([
                    key: FieldValue.arrayUnion([self.trick.name])
                ])
            }
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                self.db.collection(PrivateResources.usersCollection).document(user.email.lowercased()).updateData([
                    key: FieldValue.arrayRemove([self.trick.name])
                ])
            }
        }
    }
    
    public func configureUserFields(user:UserFirebase?,doneButton:UIButton,starButton:UIButton) {
        guard let user = user else {return}
        DispatchQueue.global(qos: .userInitiated).async {
            self.db.collection(PrivateResources.usersCollection).document(user.email.lowercased()).getDocument(completion: { [weak self] (document,error) in
                guard let self = self else {return}
                if let _ = error {
                    self.serverErrorHandler?("Fail to load user data")
                }
                
                guard let document = document else {return}
                
                if let doneTricks = document.get(PrivateResources.usersDoneTricksKey) as? [String] {
                    doneTricks.forEach({
                        if self.trick.name == $0 {
                            DispatchQueue.main.async {
                                doneButton.setImage(UIImage(systemName: Resources.Images.checkedSquare,withConfiguration:UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)), for: .normal)
                            }
                            return
                        }
                    })
                }
                
                if let favoriteTricks = document.get(PrivateResources.usersFavoriteTricksKey) as? [String] {
                    favoriteTricks.forEach({
                        if self.trick.name == $0 {
                            DispatchQueue.main.async {
                                starButton.setImage(UIImage(systemName: Resources.Images.starFill,withConfiguration:UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)), for: .normal)
                            }
                            return
                        }
                    })
                }
            })
        }
    }

    private func loadImage(imageURL:String,slide:TrickSlide) {
        let islandPath = storageRef.child(imageURL)
        DispatchQueue.global(qos: .userInitiated).async {
            islandPath.getData(maxSize: 1 * 1024 * 1024, completion: { [weak self] data, error in
                guard let self = self else {return}
                if let _ = error {
                    self.serverErrorHandler?("Fail to load image")
                    return
                }
                DispatchQueue.main.async {
                    slide.hideSpinner()
                    let image = UIImage(data: data!)
                    slide.imageView.image = image
                }
            })
        }
    }
    
}
