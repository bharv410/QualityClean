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
import AVKit
import AVFoundation

class FirstViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var ref: DatabaseReference!
    @IBOutlet var user = Auth.auth().currentUser
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    @IBOutlet weak var jobsLabel: UILabel!
    @IBOutlet weak var vidViewHolder: UIView!
    
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
                            self.jobsLabel.text = text as! String
                        }
                    }
                    
                    if keyTitle == "video"{
                    
                        print(actualProperties.value)
                        let url = URL(string:actualProperties.value as! String)
//                        let url = NSURL(actualProperties.vaslue as! String)
                        self.player = AVPlayer(url: url!)
                        self.avpController = AVPlayerViewController()
                        self.avpController.player = self.player
                        self.avpController.view.frame = self.vidViewHolder.frame
                        self.addChildViewController(self.avpController)
                        self.view.addSubview(self.avpController.view)
                    
                    }
                }
            }
        }else{
            self.logoutUser()
        }
        
    })
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addItemToDB(_ sender: Any) {
        
        self.ref.child("items").childByAutoId().setValue(["text": textField.text])
        
    }

    @IBAction func logoutUser(_ sender: Any) {
        logoutUser()
        
    }
    
    func logoutUser() {
        // unauth() is the logout method for the current user.
        
        UserDefaults.standard.setValue(nil, forKey: "uid")
        
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
}

