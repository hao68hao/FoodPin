//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by lauda on 16/7/18.
//  Copyright © 2016年 lauda. All rights reserved.
//

import UIKit

class DiscoverTableViewController: UITableViewController {
    
    //新建一个数据，保存从leancloud端取回的数据
    var restaurants:[AVObject] = []
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //实现下拉刷新效果
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: #selector(DiscoverTableViewController.getNewData), forControlEvents: UIControlEvents.ValueChanged)
        
        getRecordFromCloud()
        
        //代码写上菊花代码
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func getNewData()  {
        getRecordFromCloud(true)
    }
    
    //从服务器端取回数据的方法getRecordFromCloud
    func getRecordFromCloud(needNew : Bool = false) {
//        let query = AVQuery(className: "Restaurant")
        let query = AVQuery(className: "Hokaoneone")
        
        if needNew {
            query.cachePolicy = AVCachePolicy.IgnoreCache
        } else {
            //设置数据先从缓存读取再从网络读取
            query.cachePolicy = AVCachePolicy.CacheElseNetwork
            //每隔2分钟读取一次缓存
            query.maxCacheAge = 60 * 2
        }
        
        
        
        if query.hasCachedResult() {
            print("本次数据从缓存中读取")
        }
        
        
        query.findObjectsInBackgroundWithBlock { (objects, e) -> Void in
            if let e = e {
                print(e.localizedDescription)
            } else if let objects = objects as? [AVObject] {
                self.restaurants = objects
                
                //将页面更新添加到主线程中
                NSOperationQueue.mainQueue().addOperationWithBlock{
                    //重新刷新表格
                    self.tableView.reloadData()
                    //菊花停止转动
                    self.spinner.stopAnimating()
                }
                
            }
        }
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
        return restaurants.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        //声明变量，将数据组中数据付给它
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant["name"] as? String
        
        //设置占位图
        cell.imageView?.image = UIImage(named: "photoalbum")
        
        //设置cell的图片,异步传输
        if let img = restaurant["image"] as? AVFile {
            //下载图片
            img.getDataInBackgroundWithBlock({ (data, e) -> Void in
                guard e == nil else {
                    print(e.localizedDescription)
                    return
                }
                
                //加载到主线程
                NSOperationQueue.mainQueue().addOperationWithBlock{
                    cell.imageView?.image = UIImage(data: data)  //当下载完AVFILE数据后，可以使用getdata方法重新获取数据
                }
            })
            
        }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
