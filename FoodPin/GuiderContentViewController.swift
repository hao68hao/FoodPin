//
//  GuiderContentViewController.swift
//  FoodPin
//
//  Created by lauda on 16/7/14.
//  Copyright © 2016年 lauda. All rights reserved.
//

import UIKit

class GuiderContentViewController: UIViewController {

    @IBOutlet weak var pageCtrl: UIPageControl!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var labelFooter: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func doneBtnTapped(sender: UIButton) {
        //点击按钮引导页消失
        dismissViewControllerAnimated(true, completion: nil)
        
        //记录引导页是否已经启动，
        //判断引导页是否启动在RestaurantTableViewController中的viewdidapper方法
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "GuiderShowed")
        
    }
    
    var index = 0
    var heading = ""
    var footer = ""
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageCtrl.currentPage = index
        
        labelFooter.text = footer
        labelHeading.text = heading
        imageView.image = UIImage(named: imageName)
        
        if index == 2 {
            doneBtn.hidden = false
            doneBtn.setTitle("马上体验", forState: UIControlState.Normal)
        } else {
            doneBtn.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
