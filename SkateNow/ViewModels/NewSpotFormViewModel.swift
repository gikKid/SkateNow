import UIKit
import CoreLocation
import FirebaseFirestore
import FirebaseStorage

enum NewSpotFormState {
    case filled
    case notFilled
    case sending
    case succesSent
    case errorSent(String)
}

final class NewSpotFormViewModel:NSObject {
    private var state:NewSpotFormState = .notFilled {
        didSet {
            stateHandler?(state)
        }
    }
    private var dataSpotForm = SpotForm()
    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    public var stateHandler: ((NewSpotFormState) -> Void)?
    let coordinate:CLLocationCoordinate2D
    
    init(_ coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    
    public func setDataTitle(_ textField:UITextField) {
        guard let title = textField.text else {return}
        self.dataSpotForm.title = title
        self.checkDataStateFilled()
    }
    
    public func setDataShortInfo(_ textField:UITextField) {
        guard let shortInfo = textField.text else {return}
        self.dataSpotForm.shortInfo = shortInfo
        self.checkDataStateFilled()
    }
    
    public func setDataFullInfo(_ textView:UITextView) {
        guard textView.text != nil else {return}
        self.dataSpotForm.fullInfo = textView.text
        self.checkDataStateFilled()
    }
    
    public func setDataPreferredType(_ transport:String) {
        self.dataSpotForm.preferredType = transport
        self.checkDataStateFilled()
    }
    
    public func showTransportPopOver(_ transportButton:UIButton,_ newSpotFormVC: NewSpotFormViewController,_ presentedVC:UIViewController?) {
        if let image = transportButton.imageView?.image {
            
            if image == UIImage(systemName: Resources.Images.notEdit,withConfiguration: UIImage.SymbolConfiguration(scale: .large)) {
                transportButton.setImage(UIImage(systemName: Resources.Images.edit,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
                presentedVC?.dismiss(animated: true, completion: nil)
                return
            }
            
            let transportPopOverVC = TransportsPopOverViewController()
            transportPopOverVC.content.append(Resources.Titles.generic)
            transportPopOverVC.delegate = newSpotFormVC
            transportPopOverVC.modalPresentationStyle = .popover
            transportPopOverVC.preferredContentSize = CGSize(width:150, height: 170)
            
            guard let presentationVC = transportPopOverVC.popoverPresentationController else {return}
            presentationVC.delegate = newSpotFormVC
            presentationVC.sourceView = transportButton
            presentationVC.permittedArrowDirections = .down
            presentationVC.sourceRect = CGRect(x: transportButton.bounds.midX, y: transportButton.bounds.minY - 5, width: 0, height: 0)
            presentationVC.passthroughViews = [transportButton,newSpotFormVC.view]
            
            transportButton.setImage(UIImage(systemName: Resources.Images.notEdit,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            newSpotFormVC.present(transportPopOverVC,animated: true)
        }
    }
    
    public func setPreferredType(_ preferredTransportType:String) {
        self.dataSpotForm.preferredType = preferredTransportType
        self.checkDataStateFilled()
    }
    
    public func showImagePickerAlert(_ picker:UIImagePickerController,_ newSpotFormVC:NewSpotFormViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Resources.Titles.takePhoto, style: .default, handler: { _ in
            picker.sourceType = .camera
            newSpotFormVC.present(picker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: Resources.Titles.chooseFromPhotoGallery, style: .default, handler: { _ in
            newSpotFormVC.present(picker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: Resources.Titles.cancel, style: .cancel))
        newSpotFormVC.present(alert, animated: true)
    }
    
    public func setImage(_ image:UIImage) {
        guard let title = self.dataSpotForm.title else {return}
        self.dataSpotForm.image = image
        let path = "\(PrivateResources.usersSpotsStorageFolder)/\(title).jpg"
        self.dataSpotForm.imageURL = path
        self.checkDataStateFilled()
    }
    
    private func checkDataStateFilled() {
        guard let _ = self.dataSpotForm.title,
        let _ = self.dataSpotForm.shortInfo,
        let _ = self.dataSpotForm.fullInfo,
        let _ = self.dataSpotForm.preferredType,
        let _ = self.dataSpotForm.imageURL,
        let _ = self.dataSpotForm.image
        else {
            self.state = .notFilled
            return
        }
        
        self.state = .filled
    }
    
    public func sendRequest() {
        guard let title = self.dataSpotForm.title,
        let shortInfo = self.dataSpotForm.shortInfo,
        let fullInfo = self.dataSpotForm.fullInfo,
        let preferredType = self.dataSpotForm.preferredType,
        let imageURL = self.dataSpotForm.imageURL,
        let image = self.dataSpotForm.image
        else {return}
        
        self.state = .sending
        self.sendNewSpotRequest(title: title, shortInfo: shortInfo, fullInfo: fullInfo, preferredType: preferredType, imageURL: imageURL, image: image)
    }

    private func sendNewSpotRequest(title:String,shortInfo:String,fullInfo:String,preferredType:String,imageURL:String,image:UIImage) {
        
        let geoPoint = GeoPoint.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        db.collection(PrivateResources.usersSpotsCollection).document(title.lowercased()).setData([
            PrivateResources.usersSpotsNameKey : title,
            PrivateResources.usersSpotsShortInfoKey: shortInfo,
            PrivateResources.usersSpotsFullInfoKey : fullInfo,
            PrivateResources.usersSpotsPrefferedTransportKey : preferredType,
            PrivateResources.usersSpotsCoordinateKey: geoPoint,
            PrivateResources.usersSpotsImageURLKey : ""
        ]) { err in
            if let err = err {
                self.state = .errorSent("Fail to sent request: \(err.localizedDescription)")
                return
            }
        }
        self.uploadImage(image: image,path: imageURL, title: title)
        self.state = .succesSent
    }
    
    private func uploadImage(image:UIImage,path:String,title:String) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {return}
        let fileRef = storageRef.child(path)
        
        let _ = fileRef.putData(imageData, metadata: nil, completion: { [weak self] (metadata, error) in
            guard let self = self else {return}
            if let error = error {
                self.state = .errorSent("Fail to upload image: \(error)")
                return
            }
            
            self.db.collection(PrivateResources.usersSpotsCollection).document(title.lowercased()).updateData([
                PrivateResources.usersSpotsImageURLKey: path
            ]) { err in
                if let _ = err {
                    self.state = .errorSent("Error update image url")
                    return
                }
            }
        })
    }
}
