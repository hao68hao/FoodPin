//
//  GuiderPageViewController.swift
//  FoodPin
//
//  Created by lauda on 16/7/14.
//  Copyright © 2016年 lauda. All rights reserved.
//

import UIKit

class GuiderPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    //添加头标签，尾标签，图片的数组
    var headers = ["私人定制","餐馆定位","美食发现"]
    var footers = ["好店随时加，打造自己的美食向导","马上找到大餐的位置","发现其它美食爱好者的珍藏"]
    var images = ["foodpin-intro-1","foodpin-intro-2","foodpin-intro-3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        if let startVC = viewControllerAtIndex(0){
            setViewControllers([startVC], direction: .Forward, animated: true, completion: nil)
        }
    }
    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return headers.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! GuiderContentViewController).index
        index += 1
        return viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! GuiderContentViewController).index
        index -= 1
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> GuiderContentViewController? {
        if case 0 ..< headers.count = index {
            if let contextVC = storyboard?.instantiateViewControllerWithIdentifier("GuiderContentController") as? GuiderContentViewController{
                contextVC.heading = headers[index]
                contextVC.footer = footers[index]
                contextVC.imageName = images[index]
                contextVC.index = index
                
                return contextVC
            }
        } else {
            return nil
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?{
//        var index = (UIViewController() as! GuiderContentViewController).index
//        index++
//        return
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
