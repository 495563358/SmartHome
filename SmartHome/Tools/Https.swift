//
//  Https.swift
//  SmartHome
//
//  Created by kincony on 16/1/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation

let baseUrl = "http://120.77.250.17:8080/smarthome.IMCPlatform/xingUser/"
//改版后登录注册修改账号密码接口
let AppbaseUrl = "http://120.77.250.17:8080/smarthome.IMCPlatform/appLogin/"
//门锁接口
let baseUrlLock = "http://120.77.250.17:8080/smarthome.IMCPlatform/doorlock/"
//tupian
let imgUrl = "http://120.77.250.17:8080/smarthome.IMCPlatform/"

//let baseUrl = "http://192.168.1.171:8080/smarthome.IMCPlatform/xingUser/"
////改版后登录注册修改账号密码接口
//let AppbaseUrl = "http://192.168.1.171:8080/smarthome.IMCPlatform/appLogin/"
////门锁接口
//let baseUrlLock = "http://192.168.1.171:8080/smarthome.IMCPlatform/doorlock/"
////tupian
//let imgUrl = "http://192.168.1.171:8080/smarthome.IMCPlatform/"
//添加楼层

//let addFloor_do = "\(baseUrl)addfloor.action"
////添加房间
//let addRoom_do = "\(baseUrl)addroom.action"
let getAirInfo = "\(imgUrl)customization/gainParams.action"
let getCustomAirTimeInfo = "\(imgUrl)customization/gainTimingListInfo.action"
let setCustomAirTimeInfo =  "\(imgUrl)customization/airTiming.action"
let controlAir =  "\(imgUrl)customization/control.action"
let getAirBundingList =  "\(imgUrl)customization/gainBindingPanelInfo.action"
let clearAirBunding =  "\(imgUrl)customization/panelCancelBinding.action"
let addAirBunding =  "\(imgUrl)customization/panelBinding.action"

//添加房间
let ezToken = "\(baseUrl)gainfluoriteaccesstoken.action"
//添加设备
let addEq_do = "\(baseUrl)setDeviceInfo.action"
//添加传感器
let addsensor = "\(baseUrl)addsensor.action"
//学习传感器
let studysensor = "\(baseUrl)studysensor.action"

let hasclassifiedsensor_do = "\(baseUrl)hasclassifiedsensor.action"
let deviceStatus_do="\(baseUrl)queryroomdevicestate.action"
//查询未分类设备
let unclassifyEquip_do = "\(baseUrl)unclassifyqueryequipment.action"
let classifyEquip_do = "\(baseUrl)classifyqueryequipment.action"
//let hasclassifiedsensor_do = "\(baseUrl)hasclassifiedsensor.action"
//发送验证码 
let sendCode_do = "\(baseUrl)send.action"
let refreshToken_do = "\(baseUrl)refresh_accessToken.action"
//扫描设备
let shaom_do="\(baseUrl)verify_with_sweep_host.action"

let getversion_do="\(baseUrl)getversion.action"

let setversion_do="\(baseUrl)setversion.action"

let getroom_do="\(baseUrl)getroom.action"

let deleteroom_do="\(baseUrl)deleteroom.action"
let deletefloor_do="\(baseUrl)deletefloor.action"

let updatinfo="\(baseUrl)updatinfo.action"

let commad_do="\(baseUrl)commad.action"

let getallhost_do = "\(baseUrl)getallhost.action"

let login_do = "\(baseUrl)login.action"
let deletedevice_do = "\(baseUrl)deletedevice.action"
//------------------------------------------
//商品
//商品展示
let Commodity_display="\(baseUrl)gaingoodslist.action"
//商品详情
let Commdity_di="\(baseUrl)gaingoodsdetailedInfo.action"
//意见反馈
let Yijian_do="\(baseUrl)feedback.action"

//获取用户信息
let GetUser="\(baseUrl)getuser.action"
//修改用户姓名
let GetUserName="\(baseUrl)setusername.action"
//修改性别
let GetUserSex="\(baseUrl)setusersex.action"
//修改签名
let GetUserSignature="\(baseUrl)setsignature.action"
//修改城市
let GetUserCity="\(baseUrl)setcity.action"
//上传图片
let GetUserFileupload="\(baseUrl)fileupload.action"
//----------
//添加购物车
let Add_Shopping="\(baseUrl)addshoppingcart.action"
//获取购物车商品
let Set_QueryShopping="\(baseUrl)queryshoppingcart.action"
//删除购物车商品
let Dele_shopoing = "\(baseUrl)delectshoppingcart.action"
//一键报修
let Add_Repair = "\(baseUrl)addRepair.action"
//解绑主机
let Dele_tallhost = "\(baseUrl)unbundlinghost.action"
//----
//支付回调接口
let Notifypay = "\(baseUrl)notifypay.action"
//已购接口
let Get_gainuserorder = "\(baseUrl)gainuserorder.action"
//物车里已购详情模块
let Get_gainuserorderInfo = "\(baseUrl)gainuserorderInfo.action"
//保存红外设备
let Set_setinfrareddeviceinfo = "\(baseUrl)setinfrareddeviceinfo.action"
//获取红外按钮
let Get_gaininfraredbuttonses = "\(baseUrl)gaininfraredbuttonses.action"
//----
//添加红外线
let Add_addinfraredbuttonses = "\(baseUrl)addinfraredbuttonses.action"
//删除红外线
let Dele_deleteinfraredbuttonses = "\(baseUrl)deleteinfraredbuttonses.action"
//学习控制
let studyandcommand = "\(baseUrl)studyandcommand.action"

//上传情景模式详情
let addmodelinfo = "\(baseUrl)addmodelinfo.action"
//情景模式----
//获取情景模式
let Get_gainmodel = "\(baseUrl)gainmodel.action"
//情景模式详情
let Get_gainmodelinfo = "\(baseUrl)gainmodelinfo.action"
//情景模式删除deletemodel.action
let Dele_deletemodel = "\(baseUrl)deletemodel.action"
//添加
let Add_addmodel = "\(baseUrl)addmodel.action"
//-----
//控制
let commandmodel = "\(baseUrl)commandmodel.action"
//--
//删除未分类里面设备
let Dele_wei = "\(baseUrl)deleteunclassifieddevice.action"
//--
//推动 手机编号
let shou_deviceToken = "\(baseUrl)storagepushcid.action"
//萤石
let gaineztoken = "\(baseUrl)gaineztoken.action"
//密码登陆
let lo_pass = "\(baseUrl)loginforpassword.action"
//设置登录密码
let setloginpassword = "\(baseUrl)setloginpassword.action"
//获取红外 有没有gaininfraredvalue.action
let gaininfraredvalue = "\(baseUrl)gaininfraredvalue.action"
//获取情景模式所有值
let creates = "\(baseUrl)creates.action"
//修改红外按钮名 updatebutten.action
let updatebutten = "\(baseUrl)updatebutten.action"
//设置 传感器时间 单个
let setSensorSecurityTime = "\(baseUrl)setSensorSecurityTime.action"
//设置 传感器总时间
let setTotalSecuritySwitch = "\(baseUrl)setTotalSecuritySwitch.action"
//获取 传感器信息
let gainSensor = "\(baseUrl)gainSensor.action"
//传感器名称
let setSensorName = "\(baseUrl)setSensorName.action"
//刷新未分类的设备
let quickscanhost = "\(baseUrl)quickscanhost.action"
//添加红外模块
let createButton = "\(baseUrl)createButton.action"
//删除传感器
let deleteSensor = "\(baseUrl)deleteSensor.action"
//删除红外模块
let deleteButton = "\(baseUrl)deleteButton.action"
//调整红外模块
let adjustInfraredLocation = "\(baseUrl)adjustInfraredLocation.action"
//修改主机名称
let modifyHostNickname = "\(baseUrl)modifyHostNickname.action"
//查询主机网络号 信道
let queryNetworkNumber = "\(baseUrl)queryNetworkNumber.action"
//配置
let config = "\(baseUrl)config.action"
//写入
let setNetworkNumber = "\(baseUrl)setNetworkNumber.action"
//获取单个传感器详情
let gainAloneSensors = "\(baseUrl)gainAloneSensors.action"
//设置传感器时间
let setModelTiming = "\(baseUrl)setModelTiming.action"
//获取时间
let gainModelTiming = "\(baseUrl)gainModelTiming.action"
//修改传感器
let updateSensorsPram = "\(baseUrl)updateSensorsPram.action"
//获取传感器报警记录
let gainAlarmRecord = "\(baseUrl)gainAlarmRecord.action"
//获取控制盒
let gainControlEnclosure = "\(baseUrl)gainControlEnclosure.action"
//控制 控制盒按钮
let control_ControlEnclosure = "\(baseUrl)control_ControlEnclosure.action"
//控制盒单个修改名称
let updateControlEnclosureName = "\(baseUrl)updateControlEnclosureName.action"
//控制盒刷新状态
let dropDownControlEnclosureRelayStatus = "\(baseUrl)dropDownControlEnclosureRelayStatus.action"
//版本号
let appVersionManager = "\(baseUrl)appVersionManager.action"
//判断是否主账号
let  gainCurrentAccountType = "\(baseUrl)gainCurrentAccountType.action"
//授权发送短信
let authorizeSendMsg = "\(baseUrl)authorizeSendMsg.action"
//授权
let startAuthorize = "\(baseUrl)startAuthorize.action"
//获取授权列表
let gainAuthorizeList = "\(baseUrl)gainAuthorizeList.action"
//主账号删除绑定的账号
let primaryAccountRemoveBelowAccount = "\(baseUrl)primaryAccountRemoveBelowAccount.action"
//次账号解除绑定
let subordinateAccountRemoveAuthorize = "\(baseUrl)subordinateAccountRemoveAuthorize.action"
//开锁输入密码
let lockControl = "\(baseUrlLock)lockControl.action"
//获取锁的状态 电量
let gainParams = "\(baseUrlLock)gainParams.action"
//设置推送
let pushSet = "\(baseUrlLock)pushSet.action"
//获取长期临时密码
let longTermPassList = "\(baseUrlLock)longTermPassList.action"
//点击开锁是判断
let verifyLock = "\(baseUrlLock)verifyLock.action"
//修改长期临时密码
let remotePasswordSet = "\(baseUrlLock)remotePasswordSet.action"
//获取门锁的推送记录
let pushRecord = "\(baseUrlLock)pushRecord.action"
//获取门锁成员列表
let gainFingerprintMembers = "\(baseUrlLock)gainFingerprintMembers.action"
//成员头像上次
let fingerprintHeadpic = "\(baseUrlLock)fingerprintHeadpic.action"
//修改姓名
let updateFingerprintName = "\(baseUrlLock)updateFingerprintName.action"
//临时密码删除
let lockPwdDelete = "\(baseUrlLock)lockPwdDelete.action"
//主页安防总开关
let securityTotalSwitch = "\(baseUrl)securityTotalSwitch.action"
//获取安防总开关的状态
let gainSecurityTotalSwitch = "\(baseUrl)gainSecurityTotalSwitch.action"
//首页下拉刷新
let queryDeviceState = "\(baseUrl)queryDeviceState.action"
//忘记密码
let resetPwd = "\(baseUrl)resetPwd.action"
//修改登录密码
let setPwd = "\(baseUrl)setPwd.action"
//锁进入验证密码
let initLockLogin = "\(baseUrlLock)initLockLogin.action"
//萤石Eztoken失效
let gaineztokens = "\(baseUrl)gainEzTokens.action"
//获取服务器接口里面的数据状态
let queryDbDeviceState = "\(baseUrl)queryDbDeviceState.action"
//改版之后注册接口
let appUserRegister = "\(AppbaseUrl)appUserRegister.action"
//改版之后登录接口
let appUserLogin = "\(AppbaseUrl)appUserLogin.action"
//改版后修改密码
let find_pwd = "\(AppbaseUrl)find_pwd.action"
//改版后发送验证码接口
let phoneVcode = "\(AppbaseUrl)phoneVcode.action"
//改版后邮箱发送验证码接口
let emailVcode = "\(AppbaseUrl)emailVcode.action"
//改版后邮箱找回接口
let find_email_pwd="\(AppbaseUrl)find_email_pwd.action"
//改版后 授权接口
let authorize = "\(baseUrl)authorize.action"
//改动后 授权接口
let authorize1 = "\(baseUrl)newAuthorization.action"
//改动后 编辑授权的接口
let updateAuthorize = "\(baseUrl)updateAuthorization.action"
//改动后 获取用户已授权设备
let authorizeDevice = "\(baseUrl)gainDevicesList.action"
//移交主账户
let changeAccount = "\(baseUrl)changeAccount.action"
