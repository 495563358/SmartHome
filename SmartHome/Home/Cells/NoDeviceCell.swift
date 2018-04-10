//
//  NoDeviceCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/28.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class NoDeviceCell: UITableViewCell {

    @IBOutlet var showLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    @IBAction func delayChoseTap(sender: AnyObject) {
//        let parent =  self.parentController() as! CreateModelVC
//        parent.sunData?.setNumberOfComponents(1, SET:["1","2"], addTarget:parent.navigationController!.view , complete: { (one, two, three) -> Void in
//            let a = "\(one),\(two),\(three)"
//            print(a)
//        })
//    }
//    //返回根视图
//    func parentController()->UIViewController?
//    {
//        for (var next = self.superview; (next != nil); next = next!.superview) {
//            let nextr = next?.nextResponder()
//            if nextr!.isKindOfClass(HomeVC.classForCoder()){
//                return (nextr as! UIViewController)
//            }
//            
//        }
//        return nil
//    }
}
