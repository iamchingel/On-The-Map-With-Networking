//
//  SubmitURLViewController.swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 15/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import UIKit
import MapKit

class SubmitURLViewController: UIViewController, UITextFieldDelegate {

    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var annotation:MKAnnotation!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    //adding activity Indicator
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
         
        // Do any additional setup after loading the view.
        
        enterURLTextField.delegate = self
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = myLocation!
        
        //starting activity indicator before GEOCODING begins.
        
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
           
            
            
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (action) in
                    self.switchBack()
                }))
                
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = myLocation!
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            
            
            
            locationLatitude = localSearchResponse?.boundingRegion.center.latitude
            locationLongitude = localSearchResponse?.boundingRegion.center.longitude
            
            self.activityIndicator.stopAnimating()
            
        }
        
        
    }

   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var enterURLTextField: UITextField!
    
  
    //Submit My Pin and move back to MapViewController
    @IBAction func submitButtonPressed(_ sender: Any) {
         myURL = enterURLTextField.text
       
        //🍇🍇🍇🍇🍇🍇🍇🍇🍇🍇🍇🍇
        
        UdacityClient().addMyOwnPin { (error) in
            if error != nil {
                DispatchQueue.main.async{
                self.alertView(title: "Error", message: "Error while posting data")
                }
            }
            DispatchQueue.main.async{
            self.goBackToMapView()
            }
        }
        
        
   
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func switchBack() {
        // let controller = storyboard?.instantiateViewController(withIdentifier: "InfoPostViewController") as! InfoPostViewController
        
        // present(controller, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func goBackToMapView () {
        //uncomment lines below
        
      //  let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
       // self.present(controller!, animated: true, completion: nil)
        
        
        //Now my pin won't till i relaunch the app. Maybe I need the refresh button.
         self.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: nil)
        
        
    }
    
    func alertView(title:String,message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion:nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
  
}
