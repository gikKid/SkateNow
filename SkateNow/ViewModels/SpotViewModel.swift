import UIKit
import FirebaseStorage

final class SpotViewModel:NSObject {
    private let storageRef = Storage.storage().reference()
    var errorServerHandler:((String) -> Void)?
    var image:UIImage?
    
    public func loadImage(imageURL:String?,cell:ImageSpotCollectionViewCell) {
        guard let imageURL = imageURL else {return}
        let islandPath = storageRef.child(imageURL)
        islandPath.getData(maxSize: 1 * 1024 * 1024, completion: { [weak self] data, error in
            guard let self = self else {return}
            if let _ = error {
                self.errorServerHandler?("Fail to load image")
                return
            }
            cell.hideSpinner()
            let image = UIImage(data: data!)
            self.image = image
            cell.imageView.image = image
        })
    }
}
