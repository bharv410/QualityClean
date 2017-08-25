//
//  FirstViewController.swift
//  Quality Clean
//
//  Created by Ben Harvey on 8/24/17.
//  Copyright © 2017 Quality Clean Nation LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FirstViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var ref: DatabaseReference!
    @IBOutlet var user = Auth.auth().currentUser

    @IBOutlet weak var jobsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        let currentUserRef = ref.child("users").queryOrdered(byChild: "email")
                                        .queryEqual(toValue: user?.email).observeSingleEvent(of: .value, with: { (snapshot) in
            
        if let value = snapshot.value as? NSDictionary{
            
            let thisUserObject = value.allValues.first as! NSDictionary
            
            for actualProperties in thisUserObject as NSDictionary{
                if let keyTitle = actualProperties.key as? String {
                    if keyTitle == "display_name"{
                        if let text = actualProperties.value as? String {
                            // obj is a string array. Do something with stringArray
                            self.jobsLabel.text = text as! String
                            
                        }
                    }
                    
                }else {
                    // obj is not a string array
                }
                print(actualProperties.key)
                print("    is     ")
                print(actualProperties.value)
            }
        }else{
            self.logoutUser()
        }
        
    })
        
            
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addItemToDB(_ sender: Any) {
        
        self.ref.child("items").childByAutoId().setValue(["text": textField.text])
        
        
        
//        // Get a reference to the storage service using the default Firebase App
//        let storage = Storage.storage()
//        
//        // Create a storage reference from our storage service
//        let storageRef = storage.reference()
//        
//        let newItemRef = storageRef.child("items")
//        
//        let firebaseNewItem = newItemRef.childByAutoId()
//
//        firebaseNewItem.setValue(textField.text)
        
    }

    @IBAction func logoutUser(_ sender: Any) {
        logoutUser()
        
    }
    
    func logoutUser() {
        // unauth() is the logout method for the current user.
        
        //NetService.dataService.CURRENT_USER_REF.unauth()
        
        // Remove the user's uid from storage.
        
        UserDefaults.standard.setValue(nil, forKey: "uid")
        
        // Head back to Login!
        
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
}

