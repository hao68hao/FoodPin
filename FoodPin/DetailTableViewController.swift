//
//  DetailTableViewController.swift
//  FoodPin
//
//  Created by lauda on 16/6/28.
//  Copyright © 2016年 lauda. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var restaurant : Restaurant!
   
    @IBOutlet weak var ratingBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置CELL的背景色和cell的footerview，还有title
        imageView.image = UIImage(data:restaurant.image!)
        tableView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorColor = UIColor(white: 0.9, alpha: 1)
        title = restaurant.name
        
        tableView.estimatedRowHeight = 36
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! DetailTableViewCell

        switch indexPath.row {
        case 0:
            cell.filedLabel.text = "店名"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.filedLabel.text = "类别"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.filedLabel.text = "地点"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.filedLabel.text = "是否来过"
            cell.valueLabel.text = restaurant.isVisited.boolValue ? "来过" : "没来过"
        default:
            cell.filedLabel.text = ""
            cell.valueLabel.text = ""
        }

        cell.backgroundColor = UIColor.clearColor()
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMap"{
            let mapDestVC = segue.destinationViewController as! MapViewController
            mapDestVC.restaurant = self.restaurant
        
        }
    }
    
    
    @IBAction func close(segue: UIStoryboardSegue) {
//        if let reviewVC = segue.sourceViewController as? ReviewViewController{
//            if let rating = reviewVC.rating{
//                self.restaurant.rating = rating
//                self.ratingBtn.setImage(UIImage(named: rating), forState: UIControlState.Normal)
//            }
//        }
        if let reviewVC = segue.sourceViewController as? ReviewViewController {
            if let rating = reviewVC.rating{
                self.restaurant.rating = rating
                self.ratingBtn.setImage(UIImage(named: rating), forState: .Normal)
                
                let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
                
                do {
                    try buffer?.save()
                } catch {
                    print(error)
                }
                
            }
        }
        
    }

}
