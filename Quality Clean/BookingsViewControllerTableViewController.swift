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
import DGElasticPullToRefresh
import Floaty
import UIEmptyState

class BookingsViewControllerTableViewController: UITableViewController, UIEmptyStateDataSource, UIEmptyStateDelegate  {
    
    var ref: DatabaseReference!
    @IBOutlet var user = Auth.auth().currentUser
    var tbc = GlobalTabBarViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        // Optionally remove seperator lines from empty cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        tbc = self.tabBarController as! GlobalTabBarViewController
        ref = Database.database().reference()
        
        addRefresh()
        if(!self.tbc.isCleaner){
            addFloaty()
        }
        self.navigationItem.title = "History"

    }
    
    func done() {
        
    }
    
    func addFloaty(){
        let floaty = Floaty()
        floaty.buttonColor = UIColor.white
        floaty.plusColor = UIColor(red: 192.0/255.0, green: 216.0/255.0, blue: 144.0/255.0, alpha: 1)
        floaty.addItem("Request A Cleaner", icon: UIImage(named: "icon")!, handler: { item in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookNow") as! SecondViewController
            
            self.present(vc, animated: true, completion: {
                
            })
            floaty.close()
        })
        self.view.addSubview(floaty)
    }
    
    func addRefresh(){
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 192/255.0, green: 216/255.0, blue: 144/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.fetchData()
            }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0))
        self.tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
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
                
                let snap = item as! DataSnapshot //each child is a snapshot
                
                let dict = snap.value as! [String: Any] // the value is a dict
                
                let accepted = dict["accepted"] as! BooleanLiteralType
                let food = dict["booking_date"]
                let uid  = dict["customer"] as! String
                

                
                if((!self.tbc.isCleaner) && (uid == self.user?.uid)){
                    newItems.append(food as! String)
                }
            }
            
            
            // replace the old array
            self.fruits = newItems
            // reload the UITableView
            self.updateTable()
            
            
            
        })
    }
    
    func updateTable(){
        self.tableView.reloadData()
        self.tableView.dg_stopLoading()
        self.reloadEmptyState()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! BookingsCellTableViewCell
        
        cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        cell.cellLabel?.text = fruits[indexPath.row]
        
        return cell
    }
    
}
