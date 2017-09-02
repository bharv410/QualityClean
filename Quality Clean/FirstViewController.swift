
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

class FirstViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var user = Auth.auth().currentUser
    @IBOutlet weak var jobsLabel: UILabel!
    @IBOutlet weak var vidViewHolder: UIView!
    
    @IBOutlet weak var callUsNowButton: UIButton!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bedBathLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var homeTypeLabel: UILabel!
    
    @IBOutlet weak var scrollViewContentView: UIView!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var ref: DatabaseReference!
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    var isCleaner = false
    var completedSignup = false
    var hasVid = false
    
    var originalScrollSize = CGSize()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        //originalScrollSize = scrollView.contentSize
        fetchUserData()
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
                            self.isCleaner = false
                        }
                        if(userTypeString == "cleaner"){
                            self.completedSignup = true
                            self.isCleaner = true
                        }
                    }

                    if let bedBath = thisUserObject["bed_bath"]{
                        self.bedBathLabel.text = bedBath as! String
                    }
                    
                    if let email = thisUserObject["email"]{
                        self.emailLabel.text = email as! String
                    }
                    
                    if let address = thisUserObject["address"]{
                        self.addressLabel.text = address as! String
                    }
                    
                    if let fullName = thisUserObject["full_name"]{
                        self.jobsLabel.text = fullName as! String
                    }
                    
                    if let phoneNum = thisUserObject["phone_number"]{
                        self.phoneNumberLabel.text = phoneNum as! String
                    }
                    
                    if let address = thisUserObject["home_type"]{
                        self.homeTypeLabel.text = address as! String
                    }
                    
                    if(self.isCleaner){
                    if let video = thisUserObject["video"]{
                        self.hasVid = true
                        let url = URL(string:video as! String)
                        self.player = AVPlayer(url: url!)
                        self.avpController = AVPlayerViewController()
                        self.avpController.player = self.player
                        self.avpController.view.frame = self.vidViewHolder.frame
                        self.addChildViewController(self.avpController)
                        self.scrollViewContentView.addSubview(self.avpController.view)
                        //self.scrollView.contentSize = self.originalScrollSize

                        }
                    }
                    
                    if let image = thisUserObject["image"]{
                        let url = URL(string:image as! String)
                        self.profileImageView.downloadedFrom(url: url!)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.callBackAfterLoginDone()
                    })
                }else{
                    self.logoutUser()
                }
            }
        )
    }
    
    
    func callBackAfterLoginDone(){
        if(!self.completedSignup){
            self.finishSignUp()
        }
        
        if(!self.hasVid){
            self.vidViewHolder.isHidden = true
           scrollView.contentSize = CGSize(width: scrollView.contentSize.width,height: 1.0)

        }
        
        if(self.isCleaner){
            if let tabBarController = self.tabBarController {
                let indexToRemove = 1
                if indexToRemove < (tabBarController.viewControllers?.count)! {
                    var viewControllers = tabBarController.viewControllers
                    viewControllers?.remove(at: indexToRemove)
                    tabBarController.viewControllers = viewControllers
                }
            }
            
            
//            if  let arrayOfTabBarItems = self.tabBarController?.tabBar.items as! AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
//                tabBarItem.isEnabled = false
//            }
            
            
            if  let arrayOfTabBarItems = self.tabBarController?.tabBar.items as! AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
                tabBarItem.title = "Unaccepted"
            }
        }
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
    
    //    func fetchUserData(){
    //        let currentUserRef = ref.child("users").queryOrdered(byChild: "email")
    //            .queryEqual(toValue: user?.email).observeSingleEvent(of: .value, with: { (snapshot) in
    //
    //                if let value = snapshot.value as? NSDictionary{
    //                    var hasVid = false
    //                    //GOT USER OBJECT
    //                    let thisUserObject = value.allValues.first as! NSDictionary
    //
    //                    for actualProperties in thisUserObject as NSDictionary{
    //                        if let keyTitle = actualProperties.key as? String {
    //
    //                            if keyTitle == "full_name"{
    //                                if let text = actualProperties.value as? String {
    //                                    self.jobsLabel.text = text
    //                                }
    //                            }
    //                            var customer = false
    //
    //
    //
    //
    //                            if keyTitle == "home_type"{
    //                                if let text = actualProperties.value as? String {
    //                                    self.homeTypeLabel.text = text
    //                                }
    //                            }
    //
    //                            if keyTitle == "phone_number"{
    //                                if let text = actualProperties.value as? String {
    //                                    self.phoneNumberLabel.text = text
    //                                }
    //                            }
    //
    //
    //                            if keyTitle == "full_name"{
    //                                if let text = actualProperties.value as? String {
    //                                    self.jobsLabel.text = text
    //                                }
    //                            }
    //
    //                        }
    //                    }
    //
    //
    //
    //
    //                }
    //
    //            })
    //
    //    }
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
                self.profileImageView.image = UIImage(data: data)
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
