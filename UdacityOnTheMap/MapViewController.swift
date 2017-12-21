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
        
       UdacityClient.getStudentLocations { (stuInfo, status) in
        if stuInfo != nil {
            DispatchQueue.main.async {
                UdacityClient.drawPins(arrayOfDictionaries: Data.studentData!){ (annotation) in
                        self.map.addAnnotation(annotation!)
                    }
                }
            }
        if status != nil {
            DispatchQueue.main.async {
                self.alertView(title: "Error Fetching Data", message: "Please try again later!")
                }
            }
        }
        UdacityClient.attemptLogin { (UserID, nil, response) in
            UdacityClient.getMyDetails(userID: UserID!)
        }
        
    }

    
    @IBAction func LogoutButtonWasPressed(_ sender: Any) {
       
        UdacityClient.logout { _ in
            self.completeLogout()
        }
    }
    
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        map.removeAnnotations(map.annotations)
        UdacityClient.getStudentLocations { (stuInfo, status) in
            if stuInfo != nil {
                DispatchQueue.main.async {
                    UdacityClient.drawPins(arrayOfDictionaries: Data.studentData!) { (annotation) in
                        self.map.addAnnotation(annotation!)
                    }
                }
            }
            if status != nil {
                DispatchQueue.main.async {
                    self.alertView(title: "Error Fetching Data", message: "Please try again later!")
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
