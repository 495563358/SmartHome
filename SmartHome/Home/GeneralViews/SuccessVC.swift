//
//  SuccessVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class SuccessVC: UIViewController {
   var setUserType:SetUserType?
    override func viewDidLoad() {
        super.viewDidLoad()

       configView()
    }

    func configView(){
    
        switch setUserType!
        {
        case SetUserType.Modify : break
          
        case SetUserType.Reg : break
           
        case SetUserType.Reset : break
            
        }
    
    }
    
}
