//
//  AddDeviceViewController.swift
//  SmartHome
//
//  Created by kincony on 15/12/22.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire

class AddDeviceViewController: UIViewController ,QRCodeReaderDelegate{
    static let myreader=QRCodeReaderViewController(cancelButtonTitle:NSLocalizedString("取消识别", comment: ""))
    
    var tiaoint = 0
    
    var onceToken:Int = 0
    @IBOutlet var compeletBtn: UIButton! {
        didSet {
            compeletBtn.layer.cornerRadius = 5
            compeletBtn.layer.masksToBounds = true
        }
    }
    @IBOutlet var serialNumberTF: UITextField!
    var deviceCode = ""
    @IBOutlet var nicknameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isTranslucent = false
        
            self.compeletBtn.setTitle(NSLocalizedString("添加", comment: ""), for: UIControlState())
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "导航栏L"), for: UIBarMetrics.default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = NSLocalizedString("添加主机", comment: "")
        if self.tiaoint == 0{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("跳过", comment: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddDeviceViewController.handleRightItem(_:)))
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddDeviceViewController.handleBack(_:)))
        
        let tipLab = UILabel.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 30))
        tipLab.textAlignment = .center
        tipLab.textColor = UIColor.gray
        tipLab.text = "温馨提示:您可以扫描主机底座的二维码来获取序列号。"
        tipLab.backgroundColor = UIColor.groupTableViewBackground
        tipLab.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(tipLab)
        
    }
    
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRightItem(_ sender: UIBarButtonItem) {
        app.window!.rootViewController = TabbarC()
    }
    
    @IBAction func handleScanning(_ sender: UITapGestureRecognizer) {
      
        
        if (QRCodeReader.supportsMetadataObjectTypes([AVMetadataObject.ObjectType.qr])) {
                
            AddDeviceViewController.myreader?.modalPresentationStyle = UIModalPresentationStyle.formSheet
            AddDeviceViewController.myreader?.delegate = self
            AddDeviceViewController.myreader?.setCompletionWith({ (resultAsString) -> Void in
                   
                })   


            self.present(AddDeviceViewController.myreader!, animated: true, completion: nil)
               
              
            
                
               
            }
            else {
                print("设备不支持照相功能")
                showMsg(msg: "请在设置->隐私->相机 打开相机")
            }
        }
        
//- #pragma mark - QRCodeReader Delegate Methods
    func reader(_ reader: QRCodeReaderViewController!, didScanResult result: String!) {
        self.deviceCode = result
        self.serialNumberTF.text = result
        self.dismiss(animated: true, completion: nil)
    }
    func readerDidCancel(_ reader: QRCodeReaderViewController!) {
        self.dismiss(animated: true, completion: nil)

    }
            
    
    //完成添加主机后配置WiFi
    func setCompeletBlock(_ block: @escaping () -> ()) {
        self.compeletBlock = block
    }
    
    fileprivate var compeletBlock: (() -> ())?
    
    @IBAction func handleCompelet(_ sender: UIButton) {
        
        self.deviceCode = self.serialNumberTF.text!
        
        if self.deviceCode == ""
        {
            showMsg(msg: NSLocalizedString("请扫入二维码", comment: ""));
        return
        }
        if self.nicknameTF.text == ""{
            showMsg(msg: NSLocalizedString("请输入名称", comment: ""));
            return
        }
        let parameters = ["deviceCode":self.deviceCode,"nickName":self.nicknameTF.text!]
        BaseHttpService.sendRequestAccess(shaom_do, parameters: parameters as NSDictionary) {[unowned self] (anyObject) -> () in
            
        print(anyObject)
            
            if anyObject.count == 0 {
                self.navigationController?.dismiss(animated: false, completion: nil)
                self.compeletBlock?()
            }else{
                showMsg(msg: NSLocalizedString("主机没有添加在服务器", comment: ""))
            }   
        }
     
        
        
    }
    
  
    @IBAction func exitKeyboard(_ sender: UITextField) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.serialNumberTF.resignFirstResponder()
        self.nicknameTF.resignFirstResponder()
    }

 

}
