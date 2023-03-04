import CoreLocation
import MapKit
import FirebaseFirestore

enum MapState {
    case addingSpot
    case cancelAddingSpot
    case fillSpotForm
    case sendingSpot
    case succesSendSpot
    case errorSendSpot
}

final class MapViewModel:NSObject {
    
    let db = Firestore.firestore()
    var errorHandler: ((String) -> Void)?
    var stateHandler: ((MapState) -> Void)?
    var spots = [Spot]()
    public var state:MapState? {
        didSet {
            guard let state = state else {return}
            stateHandler?(state)
        }
    }
    
    
    public func didUpdateLocations(_ locations: [CLLocation],_ mapView:MKMapView) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let location = CLLocation(latitude: latitude, longitude: longitude)
            mapView.centerToLocation(location)
        }
    }
    
    public func getSpots(mapView:MKMapView) {
        db.collection(PrivateResources.spotsCollection).getDocuments(completion: {[weak self] (querySnapshot,err) in
            guard let self = self else {return}
            if let err = err {
                self.errorHandler?("Error getting spots: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    var coordinate = CLLocationCoordinate2D()
                    var title:String?
                    var shortInfo:String?
                    var fullInfo:String?
                    var prefferedTransport:String?
                    
                    if let currentCoordinate = document.get(PrivateResources.spotCoordinateKey) {
                        let point = currentCoordinate as! GeoPoint
                        let latitude = point.latitude
                        let longitude = point.longitude
                        coordinate.latitude = latitude
                        coordinate.longitude = longitude
                    } else {
                        continue
                    }
                    
                    if let name = document.get(PrivateResources.spotNameKey) as? String {
                        title = name
                    }
                    if let currentShortInfo = document.get(PrivateResources.spotShortInfoKey) as? String {
                        shortInfo = currentShortInfo
                    }
                    if let currentFullInfo = document.get(PrivateResources.spotFullInfoKey) as? String {
                        fullInfo = currentFullInfo
                    }
                    if let currentPrefferedTransport = document.get(PrivateResources.spotPrefferedTransportKey) as? String {
                        prefferedTransport = currentPrefferedTransport
                    }
                    
                    let spot = Spot(title: title, shortInfo: shortInfo, fullInfo: fullInfo, prefferedTransport: prefferedTransport, coordinate: coordinate)
                    mapView.addAnnotation(spot)
                }
            }
        })
    }
    
    public func viewFor(_ annotation: MKAnnotation,_ mapView: MKMapView) -> MKAnnotationView? {
        guard let annotaion = annotation as? Spot else {return nil}
        let identefier = Resources.Identefiers.spotMap
        let view:MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identefier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identefier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    public func handleDismissSpotForm() {
        self.state = nil
    }
    
    public func userTapAddSpotButton() {
        switch self.state {
        case .addingSpot:
            state = .cancelAddingSpot
        default:
            state = .addingSpot
        }
    }
    
    public func createFormSpotView(_ gesture: UITapGestureRecognizer,_ mapVC:MapViewController) {
        if let mapView = gesture.view as? MKMapView {
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            
            //FIXME: - pin temporary annotation, store it locale if confirmed, remove it if cancel
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            mapView.addAnnotation(annotation)
            
            let newSpotFormVC = NewSpotFormViewController(coordinate)
            newSpotFormVC.modalPresentationStyle = .overCurrentContext
            newSpotFormVC.delegate = mapVC
            mapVC.present(newSpotFormVC,animated: false)
        }
    }
    
}
