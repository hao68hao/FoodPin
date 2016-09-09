//
//  AddRestaurantController.swift
//  FoodPin
//
//  Created by lauda on 16/7/13.
//  Copyright © 2016年 lauda. All rights reserved.
//

import UIKit
import CoreData

class AddRestaurantController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var restaurant:Restaurant!
    var isVisited = false

    @IBOutlet weak var labelVisited: UILabel!
    @IBAction func isVisitedTapped(sender: UIButton) {
        if sender.tag == 8001 {
            isVisited = true
            labelVisited.text = "我来过了"
        }else{
            isVisited = false
            labelVisited.text = "没来过"
        }
    }
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var location: UITextField!
    
    @IBAction func saveBtnTapped(sender: UIBarButtonItem) {
        
        //实例化托管对象的缓冲区
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        
        //新建一个餐馆实体
        let restaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: buffer!) as! Restaurant
        
        
        restaurant.name = name.text!
        restaurant.type = type.text!
        restaurant.location = location.text!
        
        //存储为NSData类型的图片（png格式）
        if let image = imageView.image{
            restaurant.image = UIImagePNGRepresentation(image)
        }
        
        //NSNumber类型和数字布尔类型自动转换
        restaurant.isVisited = isVisited
        
        //保存数据
        do{
           try buffer?.save()
        }catch{
            print(error)
        }
        
        //点击保存按钮，触发保存数据到leanCloud端
        saveRecordToCloud(restaurant)
        
        //保存数据后，返回首页
        performSegueWithIdentifier("unwindToHomeList", sender: sender)
        
    }
    
    //保存新添加的餐馆数据到leanCloud端
    func saveRecordToCloud(restaurant:Restaurant!) {
        
        //准备一条需要保存的记录
        let record = AVObject(className: "Restaurant")
        
        record["name"] = restaurant.name
        record["type"] = restaurant.type
        record["location"] = restaurant.location
        
        //图像尺寸重新调整
        let originImg = UIImage(data: restaurant.image!)!
        let scalingFac = (originImg.size.width > 1024) ? 1024 / originImg.size.width : 1.0  //图片大于1024的压缩后上传
        let scaledImg = UIImage(data: restaurant.image!, scale: scalingFac)!
        
        //把图片保存成jpg，并leanCloud的file类型保存
        let imgFile = AVFile(name: "\(restaurant.name).jpg", data: UIImageJPEGRepresentation(scaledImg, 0.8))
        imgFile.saveInBackground()
        
        //关联图像文件
        record["image"] = imgFile
        
        //后台保存并通知结果
        record.saveInBackgroundWithBlock { (_, e) -> Void in
            if let e = e {
                print(e.localizedDescription)
            } else {
                print("record save successed")
            }
        }
        
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    //静态列表
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        let leftCons = NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem:imageView.superview , attribute: .Leading, multiplier: 1, constant: 0)
        
        let rightCons = NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: imageView.superview, attribute: .Trailing, multiplier: 1, constant: 0)
        
        let topCons = NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: imageView.superview, attribute: .Top, multiplier: 1, constant: 0)
        
        let bottomCons = NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: imageView.superview, attribute: .Bottom, multiplier: 1, constant: 0)
        
        leftCons.active = true
        rightCons.active = true
        topCons.active = true
        bottomCons.active = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
