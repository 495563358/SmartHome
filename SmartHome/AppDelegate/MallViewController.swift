//
//  MallViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/7/27.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class MallViewController: UIViewController,UIWebViewDelegate {
    var webView:UIWebView = UIWebView(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
    var strUrl:String = ""
    var strNavTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        

        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        webView.isUserInteractionEnabled = true
        webView.delegate = self
        webView.isOpaque = false
        webView.scalesPageToFit = true
        webView.backgroundColor = UIColor.white
        self.navigationItem.title = strNavTitle
        self.view.addSubview(webView)
        webView.loadRequest(NSURLRequest.init(url: (NSURL.init(string: strUrl)! as URL)) as URLRequest)
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
