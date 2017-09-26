
//
//  FirstViewController.swift
//  Quality Clean
//
//  Created by Ben Harvey on 8/24/17.
//  Copyright © 2017 Quality Clean Nation LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import AVKit
import AVFoundation
import Floaty
import Stripe
import SurveyMonkeyiOSSDK

class FirstViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var user = Auth.auth().currentUser
    @IBOutlet weak var jobsLabel: UILabel!
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var ref: DatabaseReference!
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    
    var completedSignup = false
    var hasVid = false
    var forceLogout = false
    var originalScrollSize = CGSize()
    
    var tbc = GlobalTabBarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbc = self.tabBarController as! GlobalTabBarViewController
        ref = Database.database().reference()
        fetchUserData()
        setupImageView()
        
        self.navigationItem.title = "My Profile"

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
    func setupImageView(){
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    func fetchUserData(){
        let currentUserRef = ref.child("users").queryOrdered(byChild: "email")
            .queryEqual(toValue: user?.email).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary{
                    let thisUserObject = value.allValues.first as! NSDictionary
                    if let userType = thisUserObject["user_type"]{
                        let userTypeString = userType as! String
                        if((userTypeString == "customer")){
                            self.completedSignup = true
                            self.tbc.isCleaner = false
                        }
                        if(userTypeString == "cleaner"){
                            self.completedSignup = true
                            self.tbc.isCleaner = true
                        }
                    }
//
//                    if let bedBath = thisUserObject["bed_bath"]{
//                        self.bedBathLabel.text = bedBath as! String
//                    }
//                    
                    if let email = thisUserObject["email"]{
                        self.emailLabel.text = email as! String
                    }
//
//                    if let address = thisUserObject["address"]{
//                        self.addressLabel.text = address as! String
//                    }
//                    
                    if let fullName = thisUserObject["full_name"]{
                        self.jobsLabel.text = fullName as! String
                    }
                    
//                    if let phoneNum = thisUserObject["phone_number"]{
//                        self.phoneNumberLabel.text = phoneNum as! String
//                    }
//                    
//                    if let address = thisUserObject["home_type"]{
//                        self.homeTypeLabel.text = address as! String
//                    }
//                    
                    if(self.tbc.isCleaner){
//                    if let video = thisUserObject["video"]{
//                        self.hasVid = true
//                        let url = URL(string:video as! String)
//                        self.player = AVPlayer(url: url!)
//                        self.avpController = AVPlayerViewController()
//                        self.avpController.player = self.player
//                        self.avpController.view.frame = self.vidViewHolder.frame
//                        self.addChildViewController(self.avpController)
//                        self.scrollViewContentView.addSubview(self.avpController.view)
//                        //self.scrollView.contentSize = self.originalScrollSize
//
//                        }
                    }
                    
                    if let image = thisUserObject["image"]{
                        let url = URL(string:image as! String)
                        self.profileImageView.downloadedFrom(url: url!)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.callBackAfterLoginDone()
                    })
                }else{
                    self.forceLogout = true
                    self.logoutUser()
                }
            }
        )
    }
    
    
    func callBackAfterLoginDone(){
        if(!self.completedSignup){
            self.finishSignUp()
        }
        
    
            
            if(!tbc.isCleaner){
                addFloaty()
            }
//            if  let arrayOfTabBarItems = self.tabBarController?.tabBar.items as! AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
//                tabBarItem.isEnabled = false
//            }
            
            
            if  let arrayOfTabBarItems = self.tabBarController?.tabBar.items as! AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
                tabBarItem.title = "Unaccepted"
            }
            
//            if(!self.hasVid){
//                self.vidViewHolder.isHidden = true
//                scrollView.contentSize = CGSize(width: scrollView.contentSize.width,height: 1.0)
//                
//            }
        }
    
    func finishSignUp(){
        print("nil")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteSignUp")
        self.present(vc!, animated: true, completion: {
            let alert = UIAlertController(title: "Please complete sign up", message: "You're one step away from the app!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.default, handler: nil))
            
            vc?.present(alert, animated: true) {
                
                print(self.user?.email)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addItemToDB(_ sender: Any) {
        
        self.ref.child("items").childByAutoId().setValue(["text": textField.text])
        
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        logoutUser()
        
    }
    
    @IBAction func callUsNow(_ sender: Any) {
        guard let number = URL(string: "tel://" + "4438784794") else { return }
        UIApplication.shared.open(number)
    }
    
    func logoutUser() {
        if(!forceLogout){
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in

            self.realLogOutMethod()
            
        }))
        
        
        self.present(alert, animated: true) {
            
        }
        }else{
            self.realLogOutMethod()
        }
    }
    
    func realLogOutMethod(){
        do{
            UserDefaults.standard.setValue(nil, forKey: "uid")
        }catch {
            print("error logging out")
        }
        
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.profileImageView.maskCircle(anyImage: UIImage(data: data)!)
                print("updated photo")
            }
        }
    }
    
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}
