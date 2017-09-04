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
        static let picker = "picker"
        static let birthday = "birthday"
        static let button = "button"
        static let textView = "textview"
    }

    @IBOutlet var user = Auth.auth().currentUser
    var cleanDateRow = FormRowDescriptor(tag: Static.birthday, type: .dateAndTime, title: "Cleaning Date")
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

    func chooseDate(){
        print(cleanDateRow.value)
    }
}
