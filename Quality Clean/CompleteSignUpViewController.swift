//
//  CompleteSignUpViewController.swift
//  Quality Clean
//
//  Created by Ben Harvey on 8/24/17.
//  Copyright © 2017 Quality Clean Nation LLC. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class CompleteSignUpViewController : UIViewController {
    
    @IBOutlet var user = Auth.auth().currentUser

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var cityStateTextView: UITextField!
    
    @IBOutlet weak var emailTextView: UITextField!
    
    @IBOutlet weak var monthDayTExtView: UITextField!
    @IBOutlet weak var bioTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    
    @IBOutlet weak var retypePasswordTextView: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var usernameTextView: UITextField!
    
    @IBOutlet weak var fullnameTextView: UITextField!
    
    @IBOutlet weak var scrollViewContentSize: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        if (user != nil) {

            print(user?.email)
            
            print(user?.uid)
            
            emailTextView.text = user?.email
            emailTextView.allowsEditingTextAttributes = false
        }
        
        sleep(4)

    }
    
    
    override func viewDidLayoutSubviews() {
    
        
        
        //self.scrollView.contentSize = self.contentView.bounds.size*2
        
    }
    
    
    @IBAction func registerClick(_ sender: Any) {
        registerButton.isEnabled = false
        
        let userRef = self.ref.child("users").childByAutoId()
        userRef.child("email").setValue(user?.email)
        userRef.child("display_name").setValue(fullnameTextView.text)
        userRef.child("number").setValue(1234)
        userRef.child("bio").setValue(bioTextView.text)

        userRef.child("birthdate").setValue(monthDayTExtView.text){ (error, ref) -> Void in
            print("check")
        }
        
    }
    
    func uploadPic(){
        
        //        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        //        changeRequest?.displayName = "John Doe"
        //        changeRequest?.photoURL = URL(string: "https://www.smashingmagazine.com/wp-content/uploads/2015/06/10-dithering-opt.jpg")
        //        changeRequest?.commitChanges { (error) in
        //            // ...
        //            DispatchQueue.global().async {
        //                let data = try? Data(contentsOf: (changeRequest?.photoURL!)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        //                DispatchQueue.main.async {
        //                    self.imageView.image = UIImage(data: data!)
        //                }
        //            }
        //        }
        //        
        //
    }
}
