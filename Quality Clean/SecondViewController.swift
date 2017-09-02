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

class SecondViewController: UIViewController {


    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var ref: DatabaseReference!
    @IBOutlet var user = Auth.auth().currentUser

    var chosenDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        chooseDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pickerView(pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int){updateLabel()
    }
    
    
    @IBAction func requestBooking(_ sender: Any) {
        
        
        
        
        self.reguestBooking(date: self.chosenDate)

    }
    
    func chooseDate(){
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = false // to hide time and show only date picker
        picker.completionHandler = { date in
            self.chosenDate = date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
            
            self.dateLabel.text = "When?: " + dateFormatter.string(from: date)
            
            let pickerData = [
                ["value": "once", "display": "Just this once"],
                ["value": "weekly", "display": "Weekly"],
                ["value": "biweekly", "display": "Every other week"],
                ["value": "Monthly", "display": "Monthly"]
            ]
            
            PickerDialog().show("Frequency", options: pickerData, selected: "kilometer") {
                (value) -> Void in
                
                print("Unit selected: \(value)")
                
                self.frequencyLabel.text = " \(value)"
            }
            
            
        }
    }
    
    //MARK - Instance Methods
    func updateLabel(){
//        let size = pickerData[0][myPicker.selectedRowInComponent(0)]
//        let topping = pickerData[1][myPicker.selectedRowInComponent(1)]
//        pizzaLabel.text = "Pizza: " + size + " " + topping
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
            print("done")
        }

        
        
        
        let alert = UIAlertController(title: "You have succesfuly booked a cleaner for the below date! We will contact you within the hour with another confirmation", message: bookingDateString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Great!", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true) {
            self.dateLabel.text = "When?: " + bookingDateString
            print("done")
        }
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
}

