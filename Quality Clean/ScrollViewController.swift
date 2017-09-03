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
import Floaty

class ScrollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tbc = GlobalTabBarViewController()
    var ref: DatabaseReference!
    @IBOutlet var user = Auth.auth().currentUser
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var fruits = [""]

    
    @IBOutlet weak var tableVie: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbc = self.tabBarController as! GlobalTabBarViewController
        ref = Database.database().reference()
        self.tableVie.delegate = self
        self.tableVie.dataSource = self
        
        addRefresh()
        // Do any additional setup after loading the view.
        print("here")
        
        getBookings()
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
    
    
    func getBookings(){
//        let imageName = "owl.jpg"
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(image: image!)
        
        
        
        
        let pastBookingsRef = ref.child("bookings").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            var newItems = [String]()
            
            // loop through the children and append them to the new array
            for item in snapshot.children {
                let snap = item as! DataSnapshot //each child is a snapshot
                
                let dict = snap.value as! [String: Any] // the value is a dict
                
                let accepted = dict["accepted"] as! BooleanLiteralType
                let food = dict["booking_date"]
                let uid  = dict["customer"] as! String
                
                print("\(String(describing: accepted)) loves \(String(describing: food))")
                
                if(self.tbc.isCleaner && !accepted){
                    newItems.append(food as! String)
                    self.titleLabel.text = "Unaccepted Bookings"
                }
                
                
                if((!self.tbc.isCleaner) && (uid == self.user?.uid)){
                    newItems.append(food as! String)
                }
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
