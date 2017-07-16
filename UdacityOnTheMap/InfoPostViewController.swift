//
//  InfoPostViewController.swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 15/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import UIKit

class InfoPostViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        enterLocationTextField.delegate = self
    }

    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBAction func findOnTheMapButtonPressed(_ sender: Any) {
        
        guard let location = enterLocationTextField.text else {
            print("Please enter location")
            return
        }
        myLocation = location
        
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "SubmitURLViewController") as! SubmitURLViewController
        present(controller, animated: true, completion: nil)
        
    }
  
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    

}
