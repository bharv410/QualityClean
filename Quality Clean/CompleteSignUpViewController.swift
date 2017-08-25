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
import FirebaseStorage

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
            emailTextView.text = user?.email
            emailTextView.allowsEditingTextAttributes = false
        }
    }
    
    
    override func viewDidLayoutSubviews() {
    
        //self.scrollView.contentSize = self.contentView.bounds.size*2
    }
    
    @IBAction func chooseVide(_ sender: Any) {
        openImgPicker()

    }
    
    @IBAction func registerClick(_ sender: Any) {
        register()
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
            
            do {
                if let url = videoURL {
                    let vidData = try Data(contentsOf:url)

                    
                    let videosRef = Storage.storage().reference().child("videos")
                    
                    let fileName = (user?.email)! + ".mp4"
                    let vidRef = videosRef.child(fileName)
                    

                    print("uploading")
                    let uploadTask = vidRef.putFile(from: videoURL!, metadata: nil) { metadata, error in
                        if let error = error {
                            // Uh-oh, an error occurred!
                            print("video error")
                        } else {
                            for individualurl in (metadata?.downloadURLs)! {
                                print("benmark")
                                print(individualurl.path)
print("absolut")
                                print(individualurl.absoluteURL)

                                if individualurl.absoluteString.range(of:"https") != nil{
                                self.userRef.child("video").setValue(individualurl.absoluteString){ (error, ref) -> Void in
                                    self.dismiss(animated: true) {
                                        
                                        print(individualurl.path)
                                    }
                                    }
                                }
                            }
                        }
                    }
                }
            } catch let error {
                debugPrint("ERRor ::\(error)")
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
