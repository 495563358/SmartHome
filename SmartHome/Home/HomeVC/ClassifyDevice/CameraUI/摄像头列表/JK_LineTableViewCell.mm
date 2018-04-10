//
//  JK_LineTableViewCell.m
//  ZNJD2
//
//  Created by he on 14-7-18.
//
//

#import "JK_LineTableViewCell.h"
#import "JK_ViewController.h"
@interface JK_LineTableViewCell()
@property (nonatomic,strong)Equip *equip;
@property (strong, nonatomic) IBOutlet UILabel *equipID;
@property (nonatomic, strong) IBOutlet UIButton *but;
@end
@implementation JK_LineTableViewCell

- (void)awakeFromNib
{
    // Initialization code
   // self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.but setTitle:NSLocalizedString(@"添加", "") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(Equip *)equip
{
    self.equip = equip;
    self.titleLabel.text  = equip.name;
    self.equipID.text = equip.equipID;
}
- (IBAction)addToHome:(id)sender {
    NSLog(@"ssss");
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"请输入密码", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
  //  _userName =[alert textFieldAtIndex:0];
    _passWord =[alert textFieldAtIndex:0];
    _passWord.keyboardType =UIKeyboardTypeNumbersAndPunctuation;
    [alert show];
   
}
#pragma mark --UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
      __weak typeof(self) weakSelf = self;
    switch (buttonIndex) {
        case 1:
        {
            NSLog(@"ssss");
            NSDictionary *dict = @{@"roomCode":self.equip.roomCode,
                                   @"deviceAddress":self.equip.equipID,
                                   @"nickName":self.equip.name,
                                   @"ico":@"list_camera",
                                   @"deviceType":@"100",
                                   @"validationCode":self.passWord.text,
                                   @"deviceCode":@"commonsxt"};
          
            [BaseHttpService sendRequestAccess:[NSString stringWithFormat:@"%@/smarthome.IMCPlatform/xingUser/setDeviceInfo.action",BaseHttpUrl] parameters:dict success:^(id _Nonnull) {
     
             NSLog(@"ssss");
                weakSelf.equip.hostDeviceCode = @"commonsxt";
                weakSelf.equip.num = weakSelf.passWord.text;
                
             
                [weakSelf.equip saveEquip];
                [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"添加成功", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"我知道了", nil) otherButtonTitles:nil, nil]show];
                [[weakSelf parentController] startSearch];
            }];
        }
            break;
            
        default:
            
            break;
    }
    
}
- (JK_ViewController *)parentController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[JK_ViewController class]]) {
            return (JK_ViewController*)nextResponder;
        }
    }
    return nil;
}

@end
