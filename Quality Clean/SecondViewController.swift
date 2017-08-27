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

    
    var ref: DatabaseReference!
    @IBOutlet var user = Auth.auth().currentUser

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func requestBooking(_ sender: Any) {
        
        
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = false // to hide time and show only date picker
        picker.completionHandler = { date in
            self.reguestBooking(date: date)
        }
    }

    func reguestBooking(date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        
        let bookingDateString = dateFormatter.string(from: date)
        
        self.ref.child("bookings").child((user?.uid)!).childByAutoId().setValue(["text": bookingDateString]){ err, ref in
            print("done")
        }
        
        
        
        
        let alert = UIAlertController(title: "You have succesfuly booked a cleaner for the below date! We will contact you within the hour with another confirmation", message: bookingDateString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Great!", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true) {
            
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

