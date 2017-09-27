//
//  FinishSignUpController.swift
//  Quality Clean
//
//  Created by Ben Harvey on 9/25/17.
//  Copyright © 2017 Quality Clean Nation LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import DateTimePicker
import SwiftForms
import Floaty

class FinishSignUpController: FormViewController {

    var imagePickerController = UIImagePickerController()

    struct Static {
        static let picker = "picker"
        static let birthday = "birthday"
        static let button = "button"
        static let textView = "textview"
    }
    
    @IBOutlet var user = Auth.auth().currentUser
    var ref: DatabaseReference!
    var userRef : DatabaseReference!

    var cleanDateRow = FormRowDescriptor(tag: Static.birthday, type: .date, title: "Birthdate")
    var fullNameRow = FormRowDescriptor(tag: Static.textView, type: .text, title: "Full Name")
    var addressRow = FormRowDescriptor(tag: Static.textView, type: .text, title: "Address")
    var phoneNumberRow = FormRowDescriptor(tag: Static.textView, type: .phone, title: "Phone #")
    
    var profilePictureUplaoded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        userRef = self.ref.child("users").childByAutoId()
        loadForm()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    fileprivate func loadForm() {
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let form = FormDescriptor(title: "Finish Sign Up Form")
        
        let section0 = FormSectionDescriptor(headerTitle: "  ", footerTitle: nil)
        
        let section1 = FormSectionDescriptor(headerTitle: "Just a few more details...", footerTitle: nil)
        
        
        var row1 = FormRowDescriptor(tag: Static.button, type: .button, title: "Choose Profile Picture")
        row1.configuration.button.didSelectClosure = { _ in
            self.tapDetected()
            
        }
        section1.rows.append(row1)
        
        fullNameRow.configuration.cell.showsInputToolbar = true
        section1.rows.append(fullNameRow)
        
        addressRow.configuration.cell.showsInputToolbar = true
        section1.rows.append(addressRow)
        
        cleanDateRow.configuration.cell.showsInputToolbar = true
        section1.rows.append(cleanDateRow)
        
        phoneNumberRow.configuration.cell.showsInputToolbar = true
        section1.rows.append(phoneNumberRow)

        
        let section8 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        var row = FormRowDescriptor(tag: Static.button, type: .button, title: "Finished!")
        row.configuration.button.didSelectClosure = { _ in
            self.onFinishClicked()
        }
        section8.rows.append(row)
        
        form.sections = [section0, section1, section8]
        
        self.form = form
    }
    
    func onFinishClicked(){
        self.view.endEditing(true)

        userRef.child("email").setValue(user?.email)
        userRef.child("user_type").setValue("cleaner")
        userRef.child("onboardingcomplete").setValue(false)

        
        if let dateVal = self.cleanDateRow.value{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
            
            let dateString = dateFormatter.string(from: dateVal as! Date)
            userRef.child("birthdate").setValue(dateString)
        }else{
            self.errorCompleteAllFields()
            return
        }
        
        if let nameVal = self.fullNameRow.value{
            userRef.child("full_name").setValue(nameVal)
        }else{
            self.errorCompleteAllFields()
            return
        }
        
        if let addressVal = self.addressRow.value{
            userRef.child("address").setValue(addressVal)
        }else{
            self.errorCompleteAllFields()
            return
        }
        
        if let phoneVal = self.phoneNumberRow.value{
            userRef.child("phone_number").setValue(phoneVal){ (error, ref) -> Void in
                print("check")
                
                
                if(self.profilePictureUplaoded){
                    self.dismiss(animated: true, completion: { 
                        print("dismised")
                    })
                    //benmark
//                    
//                    self.present(BaseNavViewController(), animated: true, completion: nil)
                }else{
                    self.profilePicError()
                }
                
            }
        }else{
            self.errorCompleteAllFields()
            return
        }
    }

    func tapDetected() {
        print("Imageview Clicked")
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    func errorCompleteAllFields(){
        let alert = UIAlertController(title: "Complete all fields", message: "You can't continue until you fill out every thing on this page", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) { (UIAlertAction) in
            
        })
        
        self.present(alert, animated: true) {
        }
    }
    
    func profilePicError(){
        let alert = UIAlertController(title: "No Profile Picture", message: "Sorry, you're profile picture hasn't been uploaded yet. Please try again or wait a few seconds", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) { (UIAlertAction) in
            
        })
        
        self.present(alert, animated: true) {
        }
    }
}

extension FinishSignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            
            
            
            if mediaType  == "public.image" {
                dismiss(animated: true, completion: {
                    
                    print("Image Selected")
                    //let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                    //imageView.image = tempImage
                    
                    var realImage = UIImage()
                    
                    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                        realImage = image
                    }
                    else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                        realImage = image
                    } else{
                        print("Something went wrong")
                    }
                    
                    let imageData = UIImagePNGRepresentation(realImage) as NSData?
                    
                    
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
                                    self.profilePictureUplaoded = true
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
