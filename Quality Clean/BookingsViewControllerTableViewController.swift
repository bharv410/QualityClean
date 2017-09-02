//
//  BookingsViewControllerTableViewController.swift
//  Quality Clean
//
//  Created by Ben Harvey on 8/25/17.
//  Copyright © 2017 Quality Clean Nation LLC. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class BookingsViewControllerTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    @IBOutlet var user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }

    // MARK: - UITableViewDataSource
    
    
    var fruits = [""]
    
    func fetchData(){
        let pastBookingsRef = ref.child("bookings").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            var newItems = [String]()
            
            // loop through the children and append them to the new array
            for item in snapshot.children {
                newItems.append(String(describing: item))
            }
            
            // replace the old array
            self.fruits = newItems
            // reload the UITableView
            self.tableView.reloadData()
            
            
            if(self.fruits.count<1){
                let alert = UIAlertController(title: "No past bookings", message: "Almost there!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true) {
                    
                    print(self.user?.email)
                }
            }
            
            
        })
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = fruits[indexPath.row]
        
        return cell
    }
    
}
