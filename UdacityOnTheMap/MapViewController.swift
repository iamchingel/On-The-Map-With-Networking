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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        
        
        
       UdacityClient().getStudentLocations { (stuInfo, status) in
        if stuInfo != nil {
            DispatchQueue.main.async {
                self.drawPins(arrayOfDictionaries: studentData!)
                }
            }
        if status != nil {
            DispatchQueue.main.async {
                self.alertView(title: "Error Fetching Data", message: "Please try again later!")
                }
            }
        }
        
       //       UdacityClient().getStudentLocations { _ in
        //          self.drawPins(arrayOfDictionaries: studentData!)
        //      }
 
        UdacityClient().attemptLogin { (UserID, nil, response) in
            UdacityClient().getMyDetails(userID: UserID!)
        }
        
    }
 
    
    @IBAction func LogoutButtonWasPressed(_ sender: Any) {
        
     //I don't think its working correctly 
        
       
            UdacityClient().logout { _ in
                self.completeLogout()
            }
       
       
        
    }
    
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
      // below code doesn't work
        
        DispatchQueue.main.async {
            self.map.reloadInputViews()
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
                            if let studentURL = dictionary["mediaURL"] {
                                
                            
                            annotation.title = "\(studentfirstName) \(studentlastName)"
                            annotation.subtitle = studentURL as? String
                            }
                        }
                    }
                  
                    
                    
                   // annotation.subtitle = url as? String
                    
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
        
       /* let controller = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(controller!, animated: true, completion: nil)
        
        print("we should log out now")
         */
            DispatchQueue.main.async{
        self.dismiss(animated: true, completion: nil)
        }
    }

    func alertView(title:String,message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion:nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
 

}
