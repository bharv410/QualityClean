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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        if (user != nil) {

            print(user?.email)
            
            print(user?.uid)
        }
        
        sleep(4)

        updateUser()
    }
    
    
    override func viewDidLayoutSubviews() {
        
        let screenSize: CGRect = UIScreen.main.bounds

        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: screenSize.height)

    }
    
    func updateUser(){
        
        let userRef = self.ref.child("users").childByAutoId()
        userRef.child("email").setValue(user?.email)
        userRef.child("display_name").setValue("Ben")
        userRef.child("number").setValue(1234)

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
