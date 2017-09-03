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
import DGElasticPullToRefresh

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
        
        addRefresh()
        // Do any additional setup after loading the view.
        print("here")
        
        getBookings()
    }
    
    func getBookings(){
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
                
                print("\(String(describing: name)) loves \(String(describing: food))")
                
                
                
                newItems.append(food as! String)
            }
            self.fruits = newItems
            self.tableVie.reloadData()
            self.tableVie.dg_stopLoading()
        }
        )
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addRefresh(){
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 192/255.0, green: 216/255.0, blue: 144/255.0, alpha: 1.0)
        self.tableVie.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.getBookings()
            }, loadingView: loadingView)
        self.tableVie.dg_setPullToRefreshFillColor(UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0))
        self.tableVie.dg_setPullToRefreshBackgroundColor(tableVie.backgroundColor!)
    }
    
    deinit {
        tableVie.dg_removePullToRefresh()
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
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookingDetail")
        self.present(vc!, animated: true) { 
            
            
        }

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! BookingsCellTableViewCell
        
        cell.cellLabel?.text = fruits[indexPath.row]
        
        return cell
    }
}
