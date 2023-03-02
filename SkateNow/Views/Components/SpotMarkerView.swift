import MapKit

class SpotMarkerView:MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let spot = newValue as? Spot else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let titleChar = spot.title?.first {
                glyphText = String(titleChar)
            }
        }
    }
}
