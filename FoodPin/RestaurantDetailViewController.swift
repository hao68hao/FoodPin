//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by lauda on 16/6/26.
//  Copyright © 2016年 lauda. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    var restaurant : Restaurant!
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        restaurantImageView.image = UIImage(named: restaurant.image)
        restaurantImageView.image = UIImage(data: restaurant.image!)
        
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
