//
//  BookingDetailViewController.swift
//  Quality Clean
//
//  Created by Ben Harvey on 9/2/17.
//  Copyright © 2017 Quality Clean Nation LLC. All rights reserved.
//

import UIKit

class BookingDetailViewController: UIViewController {

    
    var shouldShowClaimButton = true
    @IBOutlet weak var claimButton: UIButton!
    
    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if(!shouldShowClaimButton){
            claimButton.isHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func onClaimClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "You have claimed this booking", message: "Yay!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true) {
            
        }
    }
    
    @IBAction func onDismissClicked(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            
        }
    }
}
