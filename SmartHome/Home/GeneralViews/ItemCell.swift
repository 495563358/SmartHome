//
//  FloorCell.swift
//  SmartHome
//
//  Created by sunzl on 15/12/18.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    var editView: EditView?
    @IBOutlet var bgView: UIView!
    @IBOutlet var access: UIImageView!
    @IBOutlet var floor: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
//        let frame = CGRectMake(ScreenWidth, 0, self.frame.height / 4 * 3, self.frame.height)
//        editView = EditView(frame: frame)
//        self.contentView.addSubview(editView!)
//        
//        
//        
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
//        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
//        self.addGestureRecognizer(leftSwipe)
//        
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
//        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
//        self.addGestureRecognizer(rightSwipe)
        
    }
    
    var longPressAction: (() -> ())?
    
    func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
        print("long")
        longPressAction?()
    }
    
    func handleSwipe(_ swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.left:
           
            let nowCenter = self.bgView.center
             print(nowCenter.x)
            if nowCenter.x == self.frame.size.width/2{
                UIView.animate(withDuration: 0.3, animations: { [unowned self] () -> Void in
                    self.bgView.center = CGPoint(x: self.frame.size.width/2 - self.editView!.frame.size.width, y: nowCenter.y)
                    self.editView!.center = CGPoint(x: self.frame.size.width - self.editView!.frame.size.width / 2, y: nowCenter.y)
                    })
            }
        case UISwipeGestureRecognizerDirection.right:
           
           let nowCenter = self.bgView.center
            print(nowCenter.x)
            if nowCenter.x == self.frame.size.width / 2 - self.editView!.frame.width {
                UIView.animate(withDuration: 0.3, animations: { [unowned self] () -> Void in
                    self.bgView.center = CGPoint(x: self.frame.size.width / 2, y: nowCenter.y)
                    self.editView!.center = CGPoint(x: self.frame.size.width + self.editView!.frame.size.width / 2, y: nowCenter.y)
                    })
            }
        default:
            break
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
