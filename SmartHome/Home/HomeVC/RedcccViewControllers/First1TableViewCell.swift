//
//  First1TableViewCell.swift
//  SmartHome
//
//  Created by Komlin on 16/6/16.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class First1TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var index:IndexPath?
    var img:UIImageView!
    var but:UIButton!
    var bool = false
    let scalew = ScreenWidth / 320
    let scaleh = ScreenHeight / 568
    
    func setinit(){
        
        //img.image = UIImage(named: "红外1")
        but = UIButton(frame: CGRect(x: (ScreenWidth-(10*scalew+img.frame.size.width))/2+img.frame.size.width, y: (ScreenHeight/5-40*scaleh)/2, width: 40*scalew, height: 40*scaleh))
        but.setImage(UIImage(named: "红外不选中"), for: UIControlState())
        but.addTarget(self, action: #selector(First1TableViewCell.butt(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(but)
    }
    func setimg(_ img:UIImage){
        self.img = UIImageView(frame: CGRect(x: 10*scalew, y: 5*scaleh, width: ScreenWidth/2, height: (ScreenHeight/5-10*scaleh)))
        self.img.image = img
        self.img.backgroundColor = UIColor.red
        self.addSubview(self.img)

    }
    @objc func butt(_ but:UIButton){
        bool = !bool
        if bool{
            but.setImage(UIImage(named: "红外选中"), for: UIControlState())
        }else{
            but.setImage(UIImage(named: "红外不选中"), for: UIControlState())
        }
    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
