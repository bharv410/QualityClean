//
//  SecondViewController.swift
//  Quality Clean
//
//  Created by Ben Harvey on 8/24/17.
//  Copyright © 2017 Quality Clean Nation LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import DateTimePicker
import SwiftForms
import Floaty


class SecondViewController: FormViewController {

    struct Static {
        static let nameTag = "name"
        static let passwordTag = "password"
        static let lastNameTag = "lastName"
        static let jobTag = "job"
        static let emailTag = "email"
        static let URLTag = "url"
        static let phoneTag = "phone"
        static let enabled = "enabled"
        static let check = "check"
        static let segmented = "segmented"
        static let picker = "picker"
        static let birthday = "birthday"
        static let categories = "categories"
        static let button = "button"
        static let stepper = "stepper"
        static let slider = "slider"
        static let textView = "textview"
    }


    var cleanDateRow = FormRowDescriptor(tag: Static.birthday, type: .dateAndTime, title: "Cleaning Date")
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var ref: DatabaseReference!
    @IBOutlet var user = Auth.auth().currentUser

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
        
        let form = FormDescriptor(title: "Cleaning Form")
        
        let section0 = FormSectionDescriptor(headerTitle: "  ", footerTitle: nil)

        let section1 = FormSectionDescriptor(headerTitle: "Finish Requesting Booking", footerTitle: nil)
        
        cleanDateRow.configuration.cell.showsInputToolbar = true

        section1.rows.append(cleanDateRow)
        
        
        var row = FormRowDescriptor(tag: Static.picker, type: .picker, title: "Frequency")
        row.configuration.cell.showsInputToolbar = true
        row.configuration.selection.options = (["O", "W", "B", "M"] as [String]) as [AnyObject]
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            switch option {
            case "O":
                return "Once"
            case "W":
                return "Weekly"
            case "B":
                return "Every 2 weeks"
            case "M":
                return "Monthly"
            default:
                return ""
            }
        }
        
        row.value = "O" as AnyObject
        
        section1.rows.append(row)
        
        
        
        let section7 = FormSectionDescriptor(headerTitle: "Notes for your cleaner:", footerTitle: nil)
        row = FormRowDescriptor(tag: Static.textView, type: .multilineText, title: "Notes")
        section7.rows.append(row)
        
        let section8 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        row = FormRowDescriptor(tag: Static.button, type: .button, title: "Request Booking!")
        row.configuration.button.didSelectClosure = { _ in
            self.view.endEditing(true)
            print("done")
            

            if let dt = self.cleanDateRow.value as? Date{
                self.reguestBooking(date: self.cleanDateRow.value as! Date)
            }else{
                let alert = UIAlertController(title: "Enter a date", message: "You can't book a cleaning without choosing a date", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) { (UIAlertAction) in

                })
                
                //self.dateLabel.text = "When?: " + bookingDateString
                
                //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookingDetail") as! BookingDetailViewController
                //        vc.shouldShowClaimButton = false
                self.present(alert, animated: true) {
                }
            }
        }
        section8.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.button, type: .button, title: "Cancel")
        row.configuration.button.didSelectClosure = { _ in
            self.dismiss(animated: true, completion: {
                
                
            })
        }
        section8.rows.append(row)
        
        form.sections = [section0, section1, section7, section8]
        
        self.form = form
    }

//        chooseDate()
//    }
//
//    func pickerView(pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int){updateLabel()
//    }
//    
//    
//    @IBAction func requestBooking(_ sender: Any) {
//        self.reguestBooking(date: self.chosenDate)
//    }
//    
    func chooseDate(){

        print(cleanDateRow.value)
//        let min = Date()
//        let max = Date().addingTimeInterval(365*60 * 60 * 24)
//        let picker = DateTimePicker.show(minimumDate: min, maximumDate: max)
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .long
//        dateFormatter.timeStyle = .short
//        dateFormatter.doesRelativeDateFormatting = true
//        
//        picker.is12HourFormat = true
//        picker.dateFormat = "MMM d, h:mm a"
//        picker.highlightColor = UIColor(red: 192.0/255.0, green: 216.0/255.0, blue: 144.0/255.0, alpha: 1)
//        picker.isDatePickerOnly = false // to hide time and show only date picker
//        picker.completionHandler = { date in
//            self.chosenDate = date
//            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .long
//            dateFormatter.timeStyle = .short
//            dateFormatter.doesRelativeDateFormatting = true
//
//            //self.dateLabel.text = "When?: " + dateFormatter.string(from: date)
//            
//            let pickerData = [
//                ["value": "once", "display": "Just this once"],
//                ["value": "weekly", "display": "Weekly"],
//                ["value": "biweekly", "display": "Every other week"],
//                ["value": "Monthly", "display": "Monthly"]
//            ]
//            
//            
//            PickerDialog().show("How often?", options: pickerData, selected: "kilometer") {
//                (value) -> Void in
//                
//                print("Unit selected: \(value)")
//                
//                //self.frequencyLabel.text = " \(value)"
//            }
//            
//            
//        }
    }
//
//    func updateLabel(){
//    }
//    
//
//
//
//    private func callNumber(phoneNumber:String) {
//        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
//            let application:UIApplication = UIApplication.shared
//            if (application.canOpenURL(phoneCallURL)) {
//                application.open(phoneCallURL, options: [:], completionHandler: nil)
//            }
//        }
//    }
//}
//
}
