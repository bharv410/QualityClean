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

class BookingsViewControllerTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    @IBOutlet var user = Auth.auth().currentUser
    var tbc = GlobalTabBarViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tbc = self.tabBarController as! GlobalTabBarViewController
        ref = Database.database().reference()
        
        addRefresh()
        if(!self.tbc.isCleaner){
            addFloaty()
        }

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
        //fetchData()
    }

    // MARK: - UITableViewDataSource
    
    
    var fruits = ["1", "2", "3","4"]
    
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
            self.tableView.dg_stopLoading()
            
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! BookingsCellTableViewCell
        
        cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        cell.cellLabel?.text = fruits[indexPath.row]
        
        return cell
    }
    
}
