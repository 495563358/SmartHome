//
//  JK_ViewController.h
//  ZNJD2
//
//  Created by he on 14-7-19.
//
//
//

#import <UIKit/UIKit.h>
#import "HTPlayCamerViewController.h"
#import "SearchDVS.h"
#import "SmartHome-Swift.h"
@interface JK_ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, SearchCameraResultProtocol>
{
    CSearchDVS* dvs;
    NSDictionary *_moblieDict;
   
      NSMutableArray <Equip *> *prefixDataArray;
}
@property (nonatomic,strong) NSMutableArray <Equip *> *dataArray;
@property (nonatomic,strong)NSString *roomCode;
@property  CPPPPChannelManagement* m_PPPPChannelMgt;
@property (nonatomic, retain) NSTimer* searchTimer;

- (void) startSearch;
//@property (nonatomic, retain) NSCondition* m_PPPPChannelMgtCondition;
@end
