
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
    
    var ref: DatabaseReference!
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    var isCleaner = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchUserData()
}

    func fetchUserData(){
        let currentUserRef = ref.child("users").queryOrdered(byChild: "email")
            .queryEqual(toValue: user?.email).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let value = snapshot.value as? NSDictionary{
                    var hasVid = false
                    //GOT USER OBJECT
                    let thisUserObject = value.allValues.first as! NSDictionary
                    for actualProperties in thisUserObject as NSDictionary{
                        if let keyTitle = actualProperties.key as? String {
                            
                            if keyTitle == "full_name"{
                                if let text = actualProperties.value as? String {
                                    self.jobsLabel.text = text
                                }
                            }
                            
                            if keyTitle == "bed_bath"{
                                if let text = actualProperties.value as? String {
                                    self.bedBathLabel.text = text
                                }
                            }
                            
                            if keyTitle == "email"{
                                if let text = actualProperties.value as? String {
                                    self.emailLabel.text = text
                                }
                            }
                            
                            if keyTitle == "address"{
                                if let text = actualProperties.value as? String {
                                    self.addressLabel.text = text
                                }
                            }
                            
                            if keyTitle == "home_type"{
                                if let text = actualProperties.value as? String {
                                    self.homeTypeLabel.text = text
                                }
                            }
                            
                            if keyTitle == "phone_number"{
                                if let text = actualProperties.value as? String {
                                    self.phoneNumberLabel.text = text
                                }
                            }
                            
                            
                            if keyTitle == "full_name"{
                                if let text = actualProperties.value as? String {
                                    self.jobsLabel.text = text
                                }
                            }
                            
                            
                            
                            
                            if keyTitle == "video"{
                                hasVid = true
                                let url = URL(string:actualProperties.value as! String)
                                self.player = AVPlayer(url: url!)
                                self.avpController = AVPlayerViewController()
                                self.avpController.player = self.player
                                self.avpController.view.frame = self.vidViewHolder.frame
                                self.addChildViewController(self.avpController)
                                self.scrollViewContentView.addSubview(self.avpController.view)
                                self.isCleaner = true
                            }
                            
                            if keyTitle == "image"{
                                let url = URL(string:actualProperties.value as! String)
                                
                                self.profileImageView.downloadedFrom(url: url!)
                                
                            }
                        }
                    }
                    
                    
                    if(self.isCleaner){
                        if  let arrayOfTabBarItems = self.tabBarController?.tabBar.items as! AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
                            tabBarItem.isEnabled = false
                        }
                    }else{
                        self.vidViewHolder.isHidden = true
                    }
                    
                }else{
                    self.logoutUser()
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

