//
//  InfraredViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/4/18.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit


class SensorViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,pusView{

    fileprivate var compeletBlock: ((String,String)->())?
    func configCompeletBlock(_ compeletBlock: @escaping (_ equipType: String,_ v:String)->()) {
        self.compeletBlock = compeletBlock
        
    }
    var isMoni:Bool = false
    var index:IndexPath?
    var equip:Equip?
    func pus(_ id:Int) {
        self.compeletBlock!(self.models[id].modelName,self.models[id].modelId)
        self.navigationController?.popViewController(animated: true)
    }
    //modeltag
    var models = [ChainModel]()

    //判断学习控制 默认值 0默认学习 1控制
    
   
    //空值的设备地址
    var Address:String?
    
    @IBOutlet weak var MyCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title=NSLocalizedString("情景选择", comment: "")
       // self.navigationController!.navigationBar.setBackgroundImage(UIImage(imageLiteral: "透明图片.png"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        //MyCollection.layer.masksToBounds = true
        // Do any additional setup after loading the view.

        

    }



    
    func WillAppear(){

        BaseHttpService .sendRequestAccess(Get_gainmodel, parameters:["":""]) { (response) -> () in
            print(response)
            app.models = [ChainModel]()
            if response.count == 0{
                self.MyCollection.reloadData()
                return
            }
            self.models.removeAll()
            for model in (response as! Array<Dictionary<String,String>>)
            {
                let modele = ChainModel()
                modele.modelName = model["modelName"]!
                modele.modelId = model["modelId"]!
               self.models.append(modele)
            }
            self.MyCollection.reloadData()
        }
    }



    //闭包函数 获取姓名
    func somsomeFunctionThatTakesAClosure1(_ string:String) -> Void{
        print(string)


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let layout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.sectionInset = UIEdgeInsetsMake(5,5,5,5)
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSize( width: (ScreenWidth - 16) / 3 - 15 , height: (ScreenWidth - 16) / 3 - 15);
        self.MyCollection.collectionViewLayout = layout
        self.MyCollection.backgroundColor = UIColor.white
        //注册Cell，必须要有
//        let nib = UINib(nibName: "infCell", bundle: NSBundle.mainBundle())
//        self.MyCollection.registerNib(nib , forCellWithReuseIdentifier: "inf_cell")
        MyCollection.register(UINib(nibName:"infCell", bundle: nil), forCellWithReuseIdentifier:"inf")
        MyCollection.dataSource = self
        MyCollection.delegate = self
        MyCollection.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        MyCollection.layer.cornerRadius = 24.0

        WillAppear()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("选择情景退出")
     
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //定义展示的UICollectionViewCell的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    //定义展示的Section的个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //每个UICollectionView展示的内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inf", for: indexPath) as? infCell

                let infCell1:Infrared = Infrared.init(aname:self.models[indexPath.row].modelName, and: self.Address!)
                cell?.but.setBackgroundImage(UIImage.init(imageLiteralResourceName: "红外线"), for: UIControlState())
                cell?.JudgeI = 0
                cell?.tag = indexPath.row
                print("\(cell?.tag)")
                cell?.setinf(infCell1)
                cell?.delegate = self
            return cell!
       
        
    }
    

    //    #pragma mark --UICollectionViewDelegate
    //UICollectionView被选中时调用的方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    //返回这个UICollectionView是否可以被选择
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
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
