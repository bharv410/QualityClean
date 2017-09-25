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

    struct Static {
        static let picker = "picker"
        static let birthday = "birthday"
        static let button = "button"
        static let textView = "textview"
    }
    
    @IBOutlet var user = Auth.auth().currentUser
    var cleanDateRow = FormRowDescriptor(tag: Static.birthday, type: .date, title: "Birthdate")
    var fullNameRow = FormRowDescriptor(tag: Static.textView, type: .text, title: "Full Name")
    var addressRow = FormRowDescriptor(tag: Static.textView, type: .text, title: "Address")
    var phoneNumberRow = FormRowDescriptor(tag: Static.textView, type: .phone, title: "Phone #")
    var ref: DatabaseReference!
    var chosenDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        loadForm()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func reguestBooking(date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        
        let bookingDateString = dateFormatter.string(from: date)
        
        let childRef = self.ref.child("bookings").childByAutoId()
        childRef.child("accepted").setValue(false)
        childRef.child("booking_date").setValue(bookingDateString)
        childRef.child("customer").setValue(user?.uid){ (error, ref) -> Void in
            self.successAlert(bookingDateString: bookingDateString)
        }
    }
    
    func successAlert(bookingDateString: String){
        let alert = UIAlertController(title: "You have succesfuly booked a cleaner for the below date! We will contact you within the hour with another confirmation", message: bookingDateString, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yay!", style: UIAlertActionStyle.default) { (UIAlertAction) in
            self.dismiss(animated: true, completion: {
                
                
            })
        })
        
        //self.dateLabel.text = "When?: " + bookingDateString
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookingDetail") as! BookingDetailViewController
        //        vc.shouldShowClaimButton = false
        self.present(alert, animated: true) {
        }
        
    }
    
    
    fileprivate func loadForm() {
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let form = FormDescriptor(title: "Cleaning Form")
        
        let section0 = FormSectionDescriptor(headerTitle: "  ", footerTitle: nil)
        
        let section1 = FormSectionDescriptor(headerTitle: "Finish Cleaner Signup", footerTitle: nil)
        
        
        
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
            self.view.endEditing(true)
            print("done")
            if let dateVal = self.cleanDateRow.value{
                print(dateVal)
            }else{
                self.errorCompleteAllFields()
            }
            
            if let nameVal = self.fullNameRow.value{
                print(nameVal)
            }else{
                self.errorCompleteAllFields()
            }
            
            if let addressVal = self.addressRow.value{
                print(addressVal)
            }else{
                self.errorCompleteAllFields()
            }
            
            
            
            
        }
        section8.rows.append(row)
        
        
        form.sections = [section0, section1, section8]
        
        self.form = form
    }
    
    func errorCompleteAllFields(){
        let alert = UIAlertController(title: "Complete all fields", message: "You can't continue until you fill out every thing on this page", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) { (UIAlertAction) in
            
        })
        
        self.present(alert, animated: true) {
        }
    }
}
