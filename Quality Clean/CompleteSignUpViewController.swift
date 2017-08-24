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

class CompleteSignUpViewController : UIViewController {
    
    @IBOutlet var user = Auth.auth().currentUser

    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if (user != nil) {

            print(user?.email)
            
            print(user?.uid)
            
            // The user's ID, unique to the Firebase project. Do NOT use
            // this value to authenticate with your backend server, if
            // you have one. Use User.getToken() instead.
        }
        
        sleep(4)

        updateUser()
    }
    
    
    func updateUser(){
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "John Doe"
        changeRequest?.photoURL = URL(string: "https://www.smashingmagazine.com/wp-content/uploads/2015/06/10-dithering-opt.jpg")
        changeRequest?.commitChanges { (error) in
            // ...
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: (changeRequest?.photoURL!)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data!)
                }
            }
        }
        
    }
    
}
