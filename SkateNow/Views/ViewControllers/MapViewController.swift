import UIKit
import MapKit
import CoreLocation

class MapViewController: BaseAccountViewController {
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    lazy var viewModel = {
       MapViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getSpots(mapView: mapView)
        
        self.viewModel.errorHandler = { [weak self] errorMessage in
            guard let self = self else {return}
            self.present(self.createInfoAlert(message: errorMessage, title: Resources.Titles.errorTitle),animated: true)
        }
    }
}


//MARK: - Configure VC
extension MapViewController {
    override func addViews() {
        super.addViews()
        self.view.addView(mapView)
    }
    
    override func configure() {
        super.configure()
        title = Resources.Titles.spots
        
        let addSpotButton = UIBarButtonItem(title: "Add spot", style: .plain, target: self, action: #selector(userTapAddSpotButton(_:)))
        navigationItem.rightBarButtonItems = [addSpotButton]
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        mapView.register(SpotMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    override func layoutViews() {
        super.layoutViews()
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mapView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            mapView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}



//MARK: - Private methods
extension MapViewController{
    @objc private func userTapAddSpotButton(_ sender: UIButton) {
        
    }
}


//MARK: MKMapView methods
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        self.viewModel.viewFor(annotation, mapView)
    }
}


//MARK: - CLLocationManager methods
extension MapViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.viewModel.didUpdateLocations(locations, mapView)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.present(self.createInfoAlert(message: "Failure to get your location", title: Resources.Titles.errorTitle), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //
//        guard let spot = view.annotation as? Spot else {return}
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
//        spot.mapItem?.openInMaps(launchOptions: launchOptions)
    }
}
