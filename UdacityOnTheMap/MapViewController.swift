//
//  MapViewController.swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 13/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //trying to add acitivity indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UdacityClient().getStudentLocations { _ in
            self.drawPins(arrayOfDictionaries: studentData!)
            self.activityIndicator.stopAnimating()
        }
        
        UdacityClient().attemptLogin { _ in
            UdacityClient().getMyDetails(userID: userID!)
        }

        
    }
    
    @IBAction func LogoutButtonWasPressed(_ sender: Any) {
        
     //I don't think its working correctly 
        
       
            UdacityClient().logout { _ in
                self.completeLogout()
            }
       
        
    }
    
    
    
    
    
    // adding student pins to the Map
    func drawPins (arrayOfDictionaries: [[String:AnyObject]]) {
        
        for dictionary in arrayOfDictionaries {
            
            if let latitude = dictionary["latitude"]  {
                if let longitude = dictionary["longitude"]  {
                    let location = CLLocationCoordinate2DMake(latitude as! CLLocationDegrees, longitude as! CLLocationDegrees)
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = location
                    // annotation.title = "\(dictionary["firstName"]!) \(dictionary["lastName"]!)"
                    if let studentfirstName = dictionary["firstName"]  {
                        if let studentlastName = dictionary["lastName"] {
                            annotation.title = "\(studentfirstName) \(studentlastName)"
                        }
                    }
                    
                    annotation.subtitle = dictionary["mediaURL"]! as? String
                    
                    map.addAnnotation(annotation)
                }
            }
            
        }
        
    }
    
    
    
    //Creating Detail Closure Button
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "pin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
            view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else {
            view?.annotation = annotation
        }
        
        return view
        
    }
    
    //Opening a link, by clicking on the detail closure button
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            if let toOpen = view.annotation?.subtitle! {
                
                if toOpen.isEmpty {
                    let alert = UIAlertController(title: "No URL Found", message: "", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion:nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    
    
    func completeLogout() {
        // why isn't this working?
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(controller!, animated: true, completion: nil)
        
        print("we should log out now")
    }


 

}
