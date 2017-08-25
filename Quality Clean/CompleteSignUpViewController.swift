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
import MobileCoreServices


class CompleteSignUpViewController : UIViewController {
    
    @IBOutlet var user = Auth.auth().currentUser

    var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var ref: DatabaseReference!
    var userRef : DatabaseReference!

    
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
        userRef = self.ref.child("users").childByAutoId()

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
        openImgPicker()

        
    }
    
    
    func register(){
                registerButton.isEnabled = false
        
                userRef.child("email").setValue(user?.email)
                userRef.child("display_name").setValue(fullnameTextView.text)
                userRef.child("number").setValue(1234)
                userRef.child("bio").setValue(bioTextView.text)
        
                userRef.child("birthdate").setValue(monthDayTExtView.text){ (error, ref) -> Void in
                    print("check")
        
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                }
        
    }
    
    
    
    private func openImgPicker() {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        present(imagePickerController, animated: true, completion: nil)
    }
}

    extension CompleteSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            let videoURL = info[UIImagePickerControllerMediaURL] as? URL
            print("videoURL:\(String(describing: videoURL))")
            

            self.dismiss(animated: true) {
                self.register()
            }
//        do {
//                if let videoURL = videoURL {
//                    let vidData = try Data(contentsOf:videoURL)
//                    userRef.child("videoData").setValue(vidData)
//                    
//                    self.dismiss(animated: true, completion: nil)
//
//            }
//            } catch let error {
//                debugPrint("ERRor ::\(error)")
//            }
            
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
