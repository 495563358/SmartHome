//
//  RoomCell.swift
//  SmartHome
//
//  Created by kincony on 15/12/25.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {

    var indexPath: IndexPath?
    var lastText:String?
    func handleEdit(_ tap: UITapGestureRecognizer) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        // Initialization code
//        let frame = CGRectMake(ScreenWidth, 0, self.contentView.frame.size.height / 4 * 3, self.contentView.frame.size.height)
//        editView = EditView(frame: frame)
//        let tap = UITapGestureRecognizer(target: self, action: Selector("handleEdit:"))
//        editView!.addGestureRecognizer(tap)
//        self.addSubview(editView!)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(RoomCell.handleSwipe(_:)))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(leftSwipe)
        
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
//        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
//        self.addGestureRecognizer(rightSwipe)
    }
    
    @IBOutlet var roomName: UITextField!
    var editView: EditView?
    
    @objc func handleSwipe(_ swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.left:
            print("left")
            let nowCenter = roomName.center
            if nowCenter.x == ScreenWidth / 2 {
                UIView.animate(withDuration: 0.3, animations: { [unowned self] () -> Void in
                    self.roomName.center = CGPoint(x: ScreenWidth / 2 - self.editView!.frame.size.width, y: nowCenter.y)
                    self.editView!.center = CGPoint(x: ScreenWidth - self.editView!.frame.size.width / 2, y: nowCenter.y)
                    })
            }
//        case UISwipeGestureRecognizerDirection.Right:
//            print("right")
//            let nowCenter = roomName.center
//            if nowCenter.x == (ScreenWidth / 2 - self.editView!.frame.width) {
//                UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
//                    self.roomName.center = CGPointMake(ScreenWidth / 2, nowCenter.y)
//                    self.editView!.center = CGPointMake(ScreenWidth + self.editView!.frame.size.width / 2, nowCenter.y)
//                    })
//            }
        default:
            break
        }
        
    }
    fileprivate var keyboardAdapt: ((_ index: IndexPath) -> ())?
    fileprivate var endEditing: ((String) -> ())?
    func configKeyboardAdpt(_ block: @escaping (_ index: IndexPath) -> ()) {
        keyboardAdapt = block
    }
    func configEndEditing(_ block: @escaping (_ text: String) -> ()) {
        endEditing = block
    }
    @IBAction func endEditingAction(_ sender: UITextField) {
        print(sender.text)
        if sender.text?.trimString() == ""
        {
            //showMsg("不能为空")
            sender.text = self.lastText
        }
        endEditing?(sender.text!)
    }
    

    @IBAction func beginEditingAction(_ sender: UITextField) {
        self.lastText = sender.text
        print("text = \(self.lastText)")
        keyboardAdapt?(indexPath!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //
     fileprivate var endChange: ((String) -> ())?
    func configEndChange(_ block: @escaping (_ text: String) -> ()) {
        endChange = block
    }
    @IBAction func editingChange(_ sender: UITextField) {
        var str = ""
        if sender.markedTextRange != nil{
            str = sender.text(in: sender.markedTextRange!)!;
        }
        print("str-->\(str)");
        if str.characters.count <= 0
        {
            endChange?(sender.text!)
        }
    }
}
