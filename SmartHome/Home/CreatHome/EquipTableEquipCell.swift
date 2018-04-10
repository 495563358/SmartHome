//
//  EquipTableEquipCell.swift
//  SmartHome
//
//  Created by kincony on 16/1/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class EquipTableEquipCell: UITableViewCell {

    
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    var editView: EditView?
        
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconImage.contentMode = .scaleAspectFit
        // Initialization code
//        let frame = CGRectMake(ScreenWidth, 0, self.contentView.frame.size.height / 4 * 3, self.contentView.frame.size.height)
//        editView = EditView(frame: frame)
//        let tap = UITapGestureRecognizer(target: self, action: Selector("handleEdit:"))
//        editView!.addGestureRecognizer(tap)
//        self.addSubview(editView!)
//        
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
//        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
//        self.addGestureRecognizer(leftSwipe)
//        
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
//        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
//        self.addGestureRecognizer(rightSwipe)
    }
    
    func handleEdit(_ tap: UITapGestureRecognizer) {
        
    }
    
    func handleSwipe(_ swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.left:
            print("left")
            let nowCenter = self.contentView.center
            if nowCenter.x == self.bounds.width / 2 {
                UIView.animate(withDuration: 0.3, animations: { [unowned self] () -> Void in
                    self.contentView.center = CGPoint(x: self.bounds.width / 2 - self.editView!.frame.size.width, y: nowCenter.y)
                    self.editView!.center = CGPoint(x: ScreenWidth - self.editView!.frame.size.width / 2, y: nowCenter.y)
                    })
            }
        case UISwipeGestureRecognizerDirection.right:
            print("right")
            let nowCenter = self.contentView.center
            if nowCenter.x == self.bounds.width / 2 - self.editView!.frame.size.width {
                UIView.animate(withDuration: 0.3, animations: { [unowned self] () -> Void in
                    self.contentView.center = CGPoint(x: self.bounds.width / 2, y: nowCenter.y)
                    self.editView!.center = CGPoint(x: ScreenWidth + self.editView!.frame.size.width / 2, y: nowCenter.y)
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
