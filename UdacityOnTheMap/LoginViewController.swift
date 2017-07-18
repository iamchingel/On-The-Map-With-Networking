//
//  LoginViewController.swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 13/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
 
    }
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        loginEmail = emailTextField.text
        loginPassword = passwordTextField.text
        
       
        
       
        UdacityClient().attemptLogin { (userID, err, status) in
            if err != nil {
                DispatchQueue.main.async{
                self.alertView(title: "Network Error", message: "Please check your network connection")
                }
            }
            if status != nil{
                DispatchQueue.main.async {
                    self.alertView(title: "Incorrect Credentials", message: "Please enter correct email id and password")
                }
            }
           
            self.completeLogin()
           
        }
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")!)
    }
    
    func completeLogin() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        self.present(controller!, animated: true, completion: nil)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func alertView(title:String,message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion:nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
  
}

//Need to take care of Alert View Controller.
