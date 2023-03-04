import MapKit
import Contacts

class Spot: NSObject, MKAnnotation {
    let title:String?
    let shortInfo:String?
    let fullInfo:String?
    let prefferedTransport:String?
    let coordinate: CLLocationCoordinate2D
    let imageURL:String?
    
    init(title:String?, shortInfo:String?, fullInfo:String?, prefferedTransport:String?, coordinate: CLLocationCoordinate2D, imageURL:String?) {
        self.title = title
        self.shortInfo = shortInfo
        self.fullInfo = fullInfo
        self.prefferedTransport = prefferedTransport
        self.coordinate = coordinate
        self.imageURL = imageURL
        super.init()
    }
    
    var subtitle: String? {
        return shortInfo
    }
    
    var mapItem:MKMapItem? {
        guard let locationName = title else {return nil}
        let addressDict = [CNPostalAddressStreetKey: locationName]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
