//
//  HeadCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class HeadCell: UITableViewCell {
   
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var bgImg: UIImageView!
    @IBOutlet var iconImg: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
   var myScorllView: MySxtScorllView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let   senddate = Date()
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "YYYY/MM/dd"
        
        let   locationString = dateformatter.string(from: senddate)
        
        
        
        dataLabel.text = locationString
        //设置轮播图
        
    }
    func configHeadView(){
 
        
            myScorllView = MySxtScorllView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: 180 * ScreenHeight/568))
            
            self.addSubview(myScorllView)
       
    }
    func removeHeadView(){
        if myScorllView != nil{
            myScorllView.doBack()
            myScorllView.removeFromSuperview()
            myScorllView = nil
          
        }
    
    }
    
    func setWeatherModel(_ model:WeatherModel){
        print("天气预报")
     
       
        addressLabel.text = model.address
       
        tempLabel.text = model.aSmallTemp+" ~ "+model.aMaxTemp+"°C"
       
        weatherLabel.text = model.aWeather
        
        let str = model.aWeather as NSString
        switch (str.substring(from: str.length-1))
        {
        case "雨":
            bgImg.image = UIImage(named: "img_rainy")
            iconImg.image = UIImage(named: "icon_rainy")
            break
        case "晴":
            bgImg.image = UIImage(named: "img_fine")
            iconImg.image = UIImage(named: "icon_fine")
            break
        default:
            bgImg.image = UIImage(named: "img_cloudy")
            iconImg.image = UIImage(named: "icon_cloudy")
            break
          
            
        
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
