import UIKit

enum NewSpotFormState {
    case filled
    case notFilled
    case sending
    case succesSent
    case errorSent
}

final class NewSpotFormViewModel:NSObject {
    private var state:NewSpotFormState = .notFilled {
        didSet {
            stateHandler?(state)
        }
    }
    private var dataSpotForm = SpotForm()
    public var stateHandler: ((NewSpotFormState) -> Void)?
    
    
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
    
    
    private func checkDataStateFilled() {
        guard let _ = self.dataSpotForm.title,
        let _ = self.dataSpotForm.shortInfo,
        let _ = self.dataSpotForm.fullInfo,
        let _ = self.dataSpotForm.preferredType,
        let _ = self.dataSpotForm.imageURL
        else {
            self.state = .notFilled
            return
        }
        self.state = .filled
    }
}
