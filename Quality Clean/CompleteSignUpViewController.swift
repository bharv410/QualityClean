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

    var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var ref: DatabaseReference!
    var userRef : DatabaseReference!
    
    @IBOutlet var user = Auth.auth().currentUser
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
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
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
        
        
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        print("Imageview Clicked")
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePickerController.mediaTypes = [kUTTypeImage as NSString as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    //Action
    func tapDetected() {
        print("Imageview Clicked")
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePickerController.mediaTypes = [kUTTypeImage as NSString as String]
        present(imagePickerController, animated: true, completion: nil)

    }
    
    @IBAction func chooseVide(_ sender: Any) {
        openImgPicker()

    }
    
    @IBAction func registerClick(_ sender: Any) {
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
            if let mediaType = info[UIImagePickerControllerMediaType] as? String {

            
            
            if mediaType  == "public.image" {
                
                
                
                print("Image Selected")
                //let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                //imageView.image = tempImage
                
                if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                    imageView.image = image
                }
                else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    imageView.image = image
                } else{
                    print("Something went wrong")
                }
                
                let imageData = UIImagePNGRepresentation(imageView.image!) as NSData?


                do {
                    
                        let fileName = (self.user?.email)! + ".png"
                        let imageRef = Storage.storage().reference().child("images").child(fileName)
                    
                        
                        let uploadTask = imageRef.putData(imageData as! Data, metadata: nil) { metadata, error in
                            if let error = error {
                                print("image error")
                            } else {
                                for individualurl in (metadata?.downloadURLs)! {
                                    print("benmarkbenmark")
                                    print(individualurl.absoluteString)
                                    
                                    //save https value
                                    if individualurl.absoluteString.range(of:"https") != nil{
                                        self.userRef.child("image").setValue(individualurl.absoluteString){ (error, ref) -> Void in
                                            self.dismiss(animated: true) {
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
            
            if mediaType == "public.movie" {
                print("Video Selected")
                let videoURL = info[UIImagePickerControllerMediaURL] as? URL
                
                do {
                    if let url = videoURL {
                        let vidData = try Data(contentsOf:url)
                        
                        let fileName = (user?.email)! + ".mp4"
                        let vidRef = Storage.storage().reference().child("videos").child(fileName)
                        
                        
                        let uploadTask = vidRef.putFile(from: videoURL!, metadata: nil) { metadata, error in
                            if let error = error {
                                print("video error")
                            } else {
                                for individualurl in (metadata?.downloadURLs)! {
                                    
                                    //save https value
                                    if individualurl.absoluteString.range(of:"https") != nil{
                                        self.userRef.child("video").setValue(individualurl.absoluteString){ (error, ref) -> Void in
                                            self.dismiss(animated: true) {
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
        }
    }
}
