//
//  ScrollViewController.swift
//  Quality Clean
//
//  Created by Ben Harvey on 8/26/17.
//  Copyright © 2017 Quality Clean Nation LLC. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class ScrollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var ref: DatabaseReference!
    @IBOutlet var user = Auth.auth().currentUser
    
    var fruits = [""]

    
    @IBOutlet weak var tableVie: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.tableVie.delegate = self
        self.tableVie.dataSource = self
        
        // Do any additional setup after loading the view.
        print("here")
        
        let imageName = "owl.jpg"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        
        
        
        let pastBookingsRef = ref.child("bookings").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            var newItems = [String]()
            
            // loop through the children and append them to the new array
            for item in snapshot.children {
                let snap = item as! DataSnapshot //each child is a snapshot
                
                let dict = snap.value as! [String: Any] // the value is a dict
                
                let name = dict["accepted"]
                let food = dict["booking_date"]
                
                print("\(name) loves \(food)")
                
                
                
                newItems.append(String(describing: item))
            }
            self.fruits = newItems
            self.tableVie.reloadData()

        }
        )

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

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = fruits[indexPath.row]
        
        return cell
    }
}
