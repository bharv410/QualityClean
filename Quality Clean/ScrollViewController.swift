//
//  ScrollViewController.swift
//  Quality Clean
//
//  Created by Ben Harvey on 8/26/17.
//  Copyright © 2017 Quality Clean Nation LLC. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let imageName = "owl.jpg"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
//        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
//        contentView.addSubview(imageView)
//        
//        let imageView2 = UIImageView(image: image!)
//        
//        contentView.insertSubview(imageView2, belowSubview: imageView)
//        
//        let imageView3 = UIImageView(image: image!)
//        
//        contentView.insertSubview(imageView3, belowSubview: imageView2)
//        
//        let imageView4 = UIImageView(image: image!)
//        
//        contentView.insertSubview(imageView4, belowSubview: imageView3)
//        

        
        
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

}
