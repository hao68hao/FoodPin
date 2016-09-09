//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by lauda on 16/6/23.
//  Copyright © 2016年 lauda. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var restaurants:[Restaurant] = []
    
    var sr : [Restaurant] = []
    
    var frc : NSFetchedResultsController!
    
    //声明一个UISearchController的变量
    var sc : UISearchController!
    
    //更新搜索结果方法
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if var textToSearch = sc.searchBar.text{
            
            //去除搜索字符串左右和中间的空格
            textToSearch = textToSearch.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            searchFilter(textToSearch)
            tableView.reloadData()
        }
    }
    
    //创建搜索结果筛选器
    func searchFilter(textToSearch : String) {
        sr = restaurants.filter({ (r) -> Bool in
            return r.name.containsString(textToSearch)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let request = NSFetchRequest(entityName: "Restaurant")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //获取缓冲区
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: buffer!, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
            restaurants = frc.fetchedObjects as! [Restaurant]
        }catch{
            print(error)
        }
        
        //在tableView的tableHeaderView添加搜索框
        sc = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = sc.searchBar
        sc.searchBar.placeholder = "输入名称搜索..."
//        sc.searchBar.tintColor = UIColor.whiteColor()
//        sc.searchBar.barTintColor = UIColor.orangeColor()
        sc.searchBar.searchBarStyle = .Minimal
        
        sc.searchResultsUpdater = self
        sc.dimsBackgroundDuringPresentation = false
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //检测引导页是否已经启动过
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("GuiderShowed") {
            return
        }
        
        //显示引导页
        if let guiderVC = storyboard?.instantiateViewControllerWithIdentifier("GuideController") as? GuiderPageViewController{
            presentViewController(guiderVC, animated: true, completion: nil)
        }
    }
    
    //当控制器开始处理内容变化时
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    //当控制器完成处理内容变化时
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let _newIndexPath = newIndexPath{
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Automatic)
            }
        case .Delete:
            if let _indexPath = indexPath{
                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Automatic)
            }
        case .Update:
            if let _indexPath = indexPath{
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Automatic)
            }
        default:
            tableView.reloadData()
        }
        restaurants = controller.fetchedObjects as! [Restaurant]
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
        if sc.active {
            return sr.count
        } else{
            return restaurants.count
        }
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableViewCell
        
//        if let r = sc.active {
//            return sr[indexPath.row]
//        } else {
//            return restaurants[indexPath.row]
//        }
        
        let r = sc.active ? sr[indexPath.row] : restaurants[indexPath.row]
        
        //每个Cell中图片和三个标签的内容
        cell.restaurantImage.image = UIImage(data: r.image!)
        cell.restaurantName.text = r.name
        cell.restaurantLocation.text = r.location
        cell.resturantType.text = r.type
        
        
        //设置图片为圆形
        cell.restaurantImage.layer.cornerRadius = cell.restaurantImage.frame.size.width / 2
        cell.restaurantImage.clipsToBounds = true
        
        //匹配来自didSelectRowAtIndexPat方法中的【是否来过】动作中，点击选中这行的存到数据组中的状态，并将该行的标记进行修改
//        if 去过的餐馆[indexPath.row] == true {
//            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//        } else {
//            cell.accessoryType = UITableViewCellAccessoryType.None
//        }
        
        if r.isVisited.boolValue == true {
            cell.favImage.hidden = false
        } else {
            cell.favImage.hidden = true
        }

        return cell
    }
    
    
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !sc.active
     }
    
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        一、先创建一个提示（UIAlertController），确定风格是【ActionSheet】还是【Alert】;
        二、在这个提示上添加菜单，同时这个菜单具有动作的功能（UIAlertAction）;
        三、添加第二步的动作到第一步的界面上；
        四、将第一步创建的提示显示在最顶层的view(presentViewController)，并设定提示的动画，以后提示点击的动作
        */
        
        
        //创建一个提示，风格是actionsheet菜单
        let 选择菜单 = UIAlertController(title: "message", message: "You select me", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //在actionsheet添加一个【取消菜单】动作
        let 取消菜单 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        //在actionsheet添加一个【收藏】动作
        let 收藏 = UIAlertAction(title: "收藏", style: UIAlertActionStyle.Destructive, handler: nil)
        
        //创建【播打电话】的形为处理 程序闭包
        let 播打电话的形为处理 = { (action:UIAlertAction) -> Void in
            //在闭包中创建一个提示，风格是alert
            let 新的提示 = UIAlertController(title: "提示", message: "播打的根本不是电话号码", preferredStyle: UIAlertControllerStyle.Alert)
            //在提示添加【好的动作】
            let 好的动作 = UIAlertAction(title: "OKKKKKKK", style: .Default, handler: nil)
            //添加【【好的动作】到【新的提示】
            新的提示.addAction(好的动作)
            
            self.presentViewController(新的提示, animated: true, completion: nil)
            
        }
        
        //在提示中添加一个【播打电话】动作
        let 播打电话 = UIAlertAction(title: "请播打电话010-2223  \(indexPath.row)", style: UIAlertActionStyle.Default, handler: 播打电话的形为处理)
        
        //在提示中添加一个【是否来过】动作
        let 是否来过 = UIAlertAction(title: "是否来过？来过请点击", style: UIAlertActionStyle.Default)
        { (action:UIAlertAction!)  -> Void in
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.去过的餐馆[indexPath.row] = true
        }
        
        选择菜单.addAction(取消菜单)
        选择菜单.addAction(播打电话)
        选择菜单.addAction(收藏)
        选择菜单.addAction(是否来过)
        
        //添加到菜单
        self.presentViewController(选择菜单, animated: true, completion: nil)
    }
    */

 
    //原生滑动菜单commitEditingStyle
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            restaurants.removeAtIndex(indexPath.row)
            
            
            //打印效果看看
            print(restaurants.count)
            
            for 店名 in restaurants {
                print(店名)
            }
            
            //删除一行，后面行有动画效果的上移
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
        } else if editingStyle == .Insert {
           
        }    
    }
    
    //自定义滑动菜单editActionsForRowAtIndexPath
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //定义滑动菜单的项目【删除】
        let 删除形为 = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "删除") { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
//            self.restaurants.removeAtIndex(indexPath.row)
//            
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
            let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
            let restaurantToDel = self.frc.objectAtIndexPath(indexPath) as! Restaurant
            
            buffer?.deleteObject(restaurantToDel)
            
            do {
                try buffer?.save()
            }catch{
                print(error)
            }
        }
        
        
        //定义滑动菜单的项目【分享】
        let 分享形为 = UITableViewRowAction(style: UITableViewRowActionStyle .Default, title: "share"){ (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            //生成分享菜单ActionSheet
            let 分享菜单 = UIAlertController(title: "分享", message: "点击分享到社交平台", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let qqAction = UIAlertAction(title: "QQ", style: UIAlertActionStyle.Default, handler: nil)
            let weiboAction = UIAlertAction(title: "WeiBo", style: UIAlertActionStyle.Default, handler: nil)
            let wxAction = UIAlertAction(title: "WeiXIN", style: UIAlertActionStyle.Default, handler: nil)
            
            分享菜单.addAction(qqAction)
            分享菜单.addAction(weiboAction)
            分享菜单.addAction(wxAction)
            
            self.presentViewController(分享菜单, animated: true, completion: nil)
            
        }
        
        分享形为.backgroundColor = UIColor(red: 90/255, green: 122/255, blue: 58/255, alpha: 1)
        
        //editActionsForRowAtIndexPath方法，返回值是数组
        return [分享形为, 删除形为]
    }


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

  
    // MARK: - Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurantDetail" {
            
            let destVC = segue.destinationViewController as! DetailTableViewController
            
            //隐藏目标页DetailTableViewController的tab bar
            destVC.hidesBottomBarWhenPushed = true
            
            destVC.restaurant = sc.active ? sr[(tableView.indexPathForSelectedRow!.row)] :
                restaurants[(tableView.indexPathForSelectedRow!.row)]
        }
    }
    
    @IBAction func unwindtoHome(segue: UIStoryboardSegue) {
        
    }
    
    

}

//    //Restaurant(name: "咖啡胡同", type: "咖啡 & 茶店", location: "香港上环德辅道西78号G/F", image: "cafedeadend.jpg", isVisited: false) ,
//    Restaurant(name: "优酷", type: "咖啡 & 茶店", location: "北京中关村中钢国际广场", image: "cafedeadend.jpg", isVisited: false) ,
//    //Restaurant(name: "霍米", type: "咖啡", location: "香港上环文咸东街太平山22-24A，B店", image: "homei.jpg", isVisited: false) ,
//    Restaurant(name: "李昊家", type: "咖啡 & 茶店", location: "河南省许昌市魏都区八一路王月桥", image: "cafedeadend.jpg", isVisited: false) ,
//    Restaurant(name: "茶.家", type: "茶屋", location: "香港葵涌和宜合道熟食市场地下", image: "teakha.jpg", isVisited: false) ,
//    Restaurant(name: "洛伊斯咖啡", type: "奥地利式 & 休闲饮料", location: "香港新界葵涌屏富径", image: "cafeloisl.jpg", isVisited: false) ,
//    Restaurant(name: "贝蒂生蚝", type: "法式", location: "香港九龙尖沙咀河内道18号(近港铁尖东站N3,N4出口) ", image: "petiteoyster.jpg", isVisited: false) ,
//    Restaurant(name: "福奇餐馆", type: "面包房", location: "香港岛中环都爹利街13号乐成行地库中层", image: "forkeerestaurant.jpg", isVisited: false) ,
//    Restaurant(name: "阿波画室", type: "面包房", location: "香港岛铜锣湾轩尼诗道555号崇光百货地库2楼30号铺", image: "posatelier.jpg", isVisited: false) ,
//    Restaurant(name: "伯克街面包坊", type: "巧克力", location: "4 Hickson Rd、The Rocks NSW 2000", image: "bourkestreetbakery.jpg", isVisited: false) ,
//    Restaurant(name: "黑氏巧克力", type: "咖啡", location: "31 Wheat Rd、Sydney NSW 2001", image: "haighschocolate.jpg", isVisited: false) ,
//    Restaurant(name: "惠灵顿雪梨", type: "美式 & 海鲜", location: "1/11-31 York Street Sydney NSW Australia、Sydney NSW 2000", image: "palominoespresso.jpg", isVisited: false) ,
//    Restaurant(name: "北州", type: "美式", location: "Macy's、151 W 34th St Fifth Floor、New York, NY 10001", image: "upstate.jpg", isVisited: false) ,
//    Restaurant(name: "布鲁克林塔菲", type: "美式", location: "250 8th Ave、New York, NY 10107", image: "traif.jpg", isVisited: false) ,
//    Restaurant(name: "格雷厄姆大街肉", type: "早餐 & 早午餐", location: "55-1 Riverwalk Pl、West New York, NJ 07093", image: "grahamavenuemeats.jpg", isVisited: false) ,
//    Restaurant(name: "华夫饼 & 沃夫", type: "法式 & 茶", location: "1585 Broadway、New York, NY 10036-8200", image: "wafflewolf.jpg", isVisited: false) ,
//    Restaurant(name: "五叶", type: "咖啡 & 茶", location: "1460 Broadway、New York, NY 10036", image: "fiveleaves.jpg", isVisited: false) ,
//    Restaurant(name: "眼光咖啡", type: "拉丁美式", location: "250 8th Ave、New York, NY 10107", image: "cafelore.jpg", isVisited: false) ,
//    Restaurant(name: "忏悔", type: "西班牙式", location: "822 Lexington Ave、New York, NY 10065", image: "confessional.jpg", isVisited: false) ,
//    Restaurant(name: "巴拉菲娜", type: "西班牙式", location: "Unit 2, Eldon Chambers、30-32 Fleet St、London EC4Y 1AA", image: "barrafina.jpg", isVisited: false) ,
//    Restaurant(name: "多尼西亚", type: "西班牙式", location: "Waterloo Station、London SE1 7LY", image: "donostia.jpg", isVisited: false) ,
//    Restaurant(name: "皇家橡树", type: "英式", location: "Unit 4a、44-58 Brompton Rd、London SW3 1BW", image: "royaloak.jpg", isVisited: false) ,
//    Restaurant(name: "泰咖啡", type: "泰式", location: "7-9 Golders Green Rd、London NW11 8DY", image: "thaicafe.jpg", isVisited: false)


