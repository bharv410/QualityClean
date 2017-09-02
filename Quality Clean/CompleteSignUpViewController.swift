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
    @IBOutlet weak var signupSegmentedControl: UISegmentedControl!
    
    @IBOutlet var user = Auth.auth().currentUser
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var bedBathTextField: UITextField!
    @IBOutlet weak var homeTypeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    
    @IBOutlet weak var cityStateTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var scrollViewContentSize: UIView!
    
    
    @IBOutlet weak var maleFemaleControl: UISegmentedControl!
    @IBOutlet weak var chooseVideoButton: UIButton!
    
    
    var customer = true
    var regButtonUp = false
    
    var videoChosen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            if(self.customer){
            self.setupCustomer()
            }
        })
    }
    
    
    func setupCustomer(){
        chooseVideoButton.isHidden = true
        maleFemaleControl.isHidden = true
        bioTextField.isHidden = true
        birthdateTextField.isHidden = true
        cityStateTextField.isHidden = true
        
        
        let yAxisMovement = chooseVideoButton.frame.height * 9
        
        let duration: TimeInterval = 1.0
        UIView.animate(withDuration: duration, animations: { () -> Void in
            if(!self.regButtonUp){
            self.registerButton.frame = CGRect(
                self.registerButton.frame.origin.x,
                self.registerButton.frame.origin.y - yAxisMovement,
                self.registerButton.frame.size.width,
                self.registerButton.frame.size.height)
            self.regButtonUp = true
            }
        })
        
        let screenSize: CGRect = UIScreen.main.bounds
        let oneThirdScreenHeight = screenSize.height/3
        
        
        scrollView.contentSize = CGSize(width:scrollViewContentSize.frame.width, height: screenSize.height + oneThirdScreenHeight)
        }
    
    func setupCleaner(){
        
        chooseVideoButton.isHidden = false
        maleFemaleControl.isHidden = false
        bioTextField.isHidden = false
        birthdateTextField.isHidden = false
        cityStateTextField.isHidden = false
        
        let yAxisMovement = chooseVideoButton.frame.height * -9
        
        var duration: TimeInterval = 1.0
        UIView.animate(withDuration: duration, animations: { () -> Void in
            if(self.regButtonUp){
            self.registerButton.frame = CGRect(
                self.registerButton.frame.origin.x,
                self.registerButton.frame.origin.y - yAxisMovement,
                self.registerButton.frame.size.width,
                self.registerButton.frame.size.height)
            self.regButtonUp = false
            }
        })
        
        let screenSize: CGRect = UIScreen.main.bounds
        let oneThirdScreenHeight = screenSize.height/3
        
        
        scrollView.contentSize = CGSize(width:scrollViewContentSize.frame.width, height: screenSize.height + oneThirdScreenHeight + oneThirdScreenHeight)
        

    }
    
    func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            customer = true
            setupCustomer()
        }else{
            customer = false
            setupCleaner()
        }
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
        
        if ((customer) && (fullNameTextField.isEmpty) || (addressTextField.isEmpty) || (bedBathTextField.isEmpty) || (homeTypeTextField.isEmpty)) {
            let alert = UIAlertController(title: "Please fill out required info", message: "You didn't fill everything out", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Great!", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true) {
                
                print("done")
            }
        }
        
        if ((!customer) && (!videoChosen)) {
            let alert = UIAlertController(title: "Please add your video", message: "You didn't fill everything out", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Great!", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true) {
                
                print("done")
            }
        }
        
        
        
        
        
        userRef.child("email").setValue(user?.email)
        userRef.child("full_name").setValue(fullNameTextField.text)
        userRef.child("address").setValue(addressTextField.text)
        userRef.child("bed_bath").setValue(bedBathTextField.text)
        userRef.child("home_type").setValue(homeTypeTextField.text)
        if(customer){
            userRef.child("user_type").setValue("customer")

        }else{
            userRef.child("user_type").setValue("cleaner")

        }
        userRef.child("phone_number").setValue(phoneNumberTextField.text){ (error, ref) -> Void in
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
    
    func initialSetup(){
        ref = Database.database().reference()
        userRef = self.ref.child("users").childByAutoId()
        
        
        signupSegmentedControl.addTarget(self, action: #selector(self.segmentedControlValueChanged(segment:))
            , for: .valueChanged)
        
        
//        if (user != nil) {
//            emailTextView.text = user?.email
//            emailTextView.allowsEditingTextAttributes = false
//        }
//        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
    }
}

    extension CompleteSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let mediaType = info[UIImagePickerControllerMediaType] as? String {

            
            
            if mediaType  == "public.image" {
                dismiss(animated: true, completion: {
                    
                    print("Image Selected")
                    //let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                    //imageView.image = tempImage
                    
                    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                        self.imageView.image = image
                    }
                    else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                        self.imageView.image = image
                    } else{
                        print("Something went wrong")
                    }
                    
                    let imageData = UIImagePNGRepresentation(self.imageView.image!) as NSData?
                    
                    
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
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                    } catch let error {
                        debugPrint("ERRor ::\(error)")
                    }
                })
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
                                                self.videoChosen = true
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

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}

extension UITextField {
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
}
