//
//  ListViewController.swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 15/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutNow))
        
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (studentData?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dict = studentData?[indexPath.row]
        
        //wasn't able to use guard let statements...dunno why!!!🍋
        
        if let studentFirstName = dict?["firstName"] {
            if let studentLastName = dict?["lastName"] {
                cell.textLabel?.text = "\(studentFirstName) \(studentLastName)"
            }
        }
        
        
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = studentData?[indexPath.row]
        let studentURL = dict?["mediaURL"]
        if ((studentURL as! String) == "") {
            let alert = UIAlertController(title: "No URL Found", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion:nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            UIApplication.shared.open(URL(string: studentURL as! String)!, options: [:], completionHandler: nil)
        }
    }
    
    
    func logoutNow () {
        
        UdacityClient().logout { _ in
            self.completeLogout()
        }
        
    }
    
    func completeLogout() {
        // why isn't this working?
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(controller!, animated: true, completion: nil)
        
        print("we should log out now")
    }
    
   

}
