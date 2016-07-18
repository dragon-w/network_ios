//
//  ViewController.swift
//  network
//
//  Created by dragon-w on 16/7/18.
//  Copyright © 2016年 dragon-w. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDelegate,  NSURLSessionDataDelegate{
    
    //属性
    var session: NSURLSession!
    var destinationPath: NSURL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestUrl("https://www.baidu.com/")
        
    }
    
    
    func requestUrl(urlString: String){
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()//默认配置
        config.timeoutIntervalForRequest = 15 //连接超时时间
        
        session = NSURLSession(configuration: config, delegate: self, delegateQueue:nil)//队列中,如果想要程序在主线程中执行,可以使用NSOperationQueue.mainQueue()
        
        let url = NSURL(string: urlString)
        
        
        let task = session.dataTaskWithURL(url!, completionHandler: { (
            data, response, error) -> Void in
            
            
//            let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            print("Done!")
            
            
           self.session.finishTasksAndInvalidate() //确保执行完成后,释放session
            
            if error == nil {
                
                let manager = NSFileManager()
                
                do {
                    
                     self.destinationPath = try manager.URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: url, create: true);
                } catch {
                    // deal with error
                }
                
                let componenetsOfUrl = url!.absoluteString.componentsSeparatedByString("/")
                
                let index = componenetsOfUrl.count - 1
                
                let fileNameFromUrl = componenetsOfUrl[index]
                
                 self.destinationPath = self.destinationPath.URLByAppendingPathComponent(fileNameFromUrl)
                
                
                let message = "保存下载数据到 = \(self.destinationPath)"
                
                self.displayAlertWithTitle("Success", message: message)
                
            }else{
                self.displayAlertWithTitle("Error", message: "不能下载这数据,一个错误抛出")
            }
        })
        
       task.resume() //这个是启动任务的,不调用,则不会执行请求
        
    }
    
    
    func displayAlertWithTitle(title:String,message:String){
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

