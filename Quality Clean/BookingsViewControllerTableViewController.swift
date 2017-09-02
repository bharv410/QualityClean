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

    var fruits = ["Apple", "Apricot", "Banana", "Blueberry", "Cantaloupe", "Cherry",
                  "Clementine", "Coconut", "Cranberry", "Fig", "Grape", "Grapefruit",
                  "Kiwi fruit", "Lemon", "Lime", "Lychee", "Mandarine", "Mango",
                  "Melon", "Nectarine", "Olive", "Orange", "Papaya", "Peach",
                  "Pear", "Pineapple", "Raspberry", "Strawberry"]
    
    // MARK: - UITableViewDataSource
    
    
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
