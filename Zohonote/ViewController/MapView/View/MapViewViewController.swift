//
//  MapViewViewController.swift
//  Zohonote
//
//  Created by Rajesh on 24/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import UIKit
import MapKit

class MapViewViewController: UIBaseViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    private var addedSuccessCallBack: ((_ lat: Double,_ longt:Double) -> Void)? = nil;

    var currentLocation : CLLocation?
    var pinAnnotationView:MKPinAnnotationView?
    var lat:Double?
    
    var longt:Double?
    var annotationTitle:String?

    @IBOutlet weak var mapView: MKMapView?
    
    lazy var locationManager: CLLocationManager = {

        let sharedLocationManager = CLLocationManager()
        sharedLocationManager.delegate = self
        sharedLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        sharedLocationManager.requestAlwaysAuthorization()
        return sharedLocationManager
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView?.delegate = self
        mapView?.showsUserLocation = false;
        mapView?.isZoomEnabled = true
        determineCurrentLocation()
        
    }
    func setParaMeter(_ lat:Double?,_ longt : Double? , _ titleStr:String?)
    {
        self.lat = lat
        self.longt = longt
        annotationTitle = titleStr
    }
        func determineCurrentLocation()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            currentLocation = CLLocation()
            currentLocation = locationManager.location
        let curentLat  = Utility.unwrap(lat, 0) == 0 ? currentLocation?.coordinate.latitude : lat
            let curentLongt  = Utility.unwrap(longt, 0) == 0 ? currentLocation?.coordinate.longitude : longt

            if let nonNilLat = curentLat,
                let nonNilLongt = curentLongt
            {
                // zooming after get lat and longt
                let span = MKCoordinateSpanMake(0.075, 0.075)
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: nonNilLat, longitude: nonNilLongt), span: span)
                mapView?.setRegion(region, animated: true)
                
                
            loadMapView(CLLocationCoordinate2D(latitude: nonNilLat, longitude: nonNilLongt))
            }
        }
        
        
       

    }
    func loadMapView(_ coordinate:CLLocationCoordinate2D)
    {
        
        let annotation = ColorPinAnnotation(pinColor: UIColor(red: 59.0/255.0, green: 181.0/255.0, blue: 58.0/255.0, alpha: 1))
        annotation.coordinate = coordinate
        annotation.title = annotationTitle
        mapView?.addAnnotation(annotation)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - bar button clicked

    @IBAction func closeBtnClicked(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)

    }
    //MARK : - calling callback method after add newnotebook
    func callBackOnSuccess(callBack: @escaping (_ lat: Double,_ longt:Double) -> Void) {
        self.addedSuccessCallBack = callBack;
    }
    // MARK: - map view delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            let colorPointAnnotation = annotation as! ColorPinAnnotation
            pinView?.pinTintColor = colorPointAnnotation.pinColor
            pinView?.animatesDrop = true
            pinView?.canShowCallout = true
            pinView?.isDraggable = true

        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == MKAnnotationViewDragState.ending {
                let droppedAt = view.annotation?.coordinate
                print(droppedAt!)
            
            self.addedSuccessCallBack!((droppedAt?.latitude)!,(droppedAt?.longitude)!)

            }
        }
   /* func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
     
     mapView.removeAnnotations(mapView.annotations)

        loadMapView(mapView.centerCoordinate)
    }*/

}

class ColorPinAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
}
