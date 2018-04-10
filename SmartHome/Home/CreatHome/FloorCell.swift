//
//  FloorCell.swift
//  SmartHome
//
//  Created by kincony on 15/12/25.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class FloorCell: UITableViewCell {

    @IBOutlet var floorName: UITextField!
    @IBOutlet var unfoldBtn: UIButton!
    var lastText:String?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    fileprivate var unfoldBlock: ((_ isUnfold: Bool) -> ())?
    fileprivate var keyboardAdapt: ((_ index: IndexPath) -> ())?
    fileprivate var endEditing: ((String) -> ())?
    fileprivate var endChange: ((String) -> ())?
    
    func configUnfoldBlock(_ block: @escaping (Bool) -> ()) {
        unfoldBlock = block
    }
    func configKeyboardAdpt(_ block: @escaping (_ index: IndexPath) -> ()) {
        keyboardAdapt = block
    }
    func configEndEditing(_ block: @escaping (_ text: String) -> ()) {
        endEditing = block
    }
    //
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


    @IBAction func editingBeginAction(_ sender: UITextField) {
        self.lastText = sender.text
        keyboardAdapt?(indexPath!)
    }
    @IBAction func editingEnd(_ sender: UITextField) {
        if sender.text?.trimString() == ""
        {
            showMsg(msg: NSLocalizedString("不能为空", comment: ""))
            sender.text = self.lastText
        }
        endEditing?(sender.text!)
    }

    @IBAction func handleUnfold(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        unfoldBlock?(sender.isSelected)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
