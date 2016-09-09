//
//  WebViewController.swift
//  FoodPin
//
//  Created by lauda on 16/7/15.
//  Copyright © 2016年 lauda. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.sian.com.cn/")!))
        
        if let url = NSURL(string: "http://www.baidu.com/") {
            webView.loadRequest(NSURLRequest(URL: url))
            
        
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
