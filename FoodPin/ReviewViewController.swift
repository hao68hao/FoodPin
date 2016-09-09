//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by lauda on 16/6/29.
//  Copyright © 2016年 lauda. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
 
    var rating:String?
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBAction func ratingBtnTapped(sender: UIButton) {
        switch sender.tag {
        case 100:
            rating = "dislike"
        case 200:
            rating = "good"
        case 300:
            rating = "great"
        default:break
        }
        
        performSegueWithIdentifier("unwindToDetailView", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       //定义背景的模糊效果
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = view.frame
        bgImageView.addSubview(effectView)
        
        //将动画设置为0，即进入view,先不可见。
        
        let scale = CGAffineTransformMakeScale(0, 0)
        
        let tranlate = CGAffineTransformMakeTranslation(0, 500)
        
        stackView.transform = CGAffineTransformConcat(scale, tranlate)
       
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //正常的动画效果
        UIView.animateWithDuration(2) { () -> Void in
            self.stackView.transform = CGAffineTransformIdentity
        }
        
        //带抖动的动画效果
//        UIView.animateWithDuration(0.3, delay: 0,
//                                   usingSpringWithDamping: 0.3,
//                                   initialSpringVelocity: 0.5,
//                                   options: [],
//                                   animations: { () -> Void in
//                                    self.stackView.transform = CGAffineTransformIdentity
//                                    },
//                                   completion: nil)
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
