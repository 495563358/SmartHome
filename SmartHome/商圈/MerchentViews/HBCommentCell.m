//
//  HBCommentCell.m
//  SmartHome
//
//  Created by Smart house on 2018/4/28.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "HBCommentCell.h"

@implementation HBCommentCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andInfoDict:(NSDictionary *)commentInfo{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView:commentInfo];
    }return self;
}

//总高度 50
-(void)createView:(NSDictionary *)commentinfo{
    
    UIImageView *headimg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 28, 28)];
    headimg.layer.cornerRadius = 14;
    headimg.layer.masksToBounds = YES;
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(50, 14, 200, 20)];
    name.font = [UIFont systemFontOfSize:15];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 200, 14, 180, 20)];
    time.textAlignment = NSTextAlignmentRight;
    time.font = [UIFont systemFontOfSize:13];
    time.textColor = [UIColor grayColor];
    
    for(int i = 0;i<[commentinfo[@"level"] intValue];i++){
        UIButton *starView = [[UIButton alloc]initWithFrame:CGRectMake(15 + 16 * i, 45, 14, 14)];
        [starView setImage:[UIImage imageNamed:@"pingfen-xuanz"] forState:UIControlStateNormal];
        [self.contentView addSubview:starView];
    }
    
    NSString *str = commentinfo[@"images"];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *images = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    CGFloat height = [commentinfo[@"content"] length]/25 + 1;
    
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 65, Sc_w - 20, 25 * height)];
    commentLabel.font = [UIFont systemFontOfSize:15];
    commentLabel.numberOfLines = 0;
    
    CGFloat hh = commentLabel.frame.origin.y + commentLabel.frame.size.height + 10;
    if ([commentinfo[@"images"] length] > 10) {
        hh += 90;
        for(int j = 0 ;j<images.count;j++){
            UIButton *imgBtns = [[UIButton alloc]initWithFrame:CGRectMake(15 + 87 * j , commentLabel.frame.origin.y + commentLabel.frame.size.height + 10, 77, 77)];
            [self.contentView addSubview:imgBtns];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *immm = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[AddressPath stringByAppendingString:images[j]] ]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imgBtns setImage:immm forState:UIControlStateNormal];
                });
            });
        }
    }
    if ([commentinfo[@"replay_content"] length] > 0) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, hh, Sc_w - 20, 20)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = [@"掌柜回复:" stringByAppendingString:commentinfo[@"replay_content"]];
        label.backgroundColor = My_gray;
        [self.contentView addSubview:label];
        hh += 30;
    }
    if ([commentinfo[@"append_content"] length] > 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, hh, Sc_w - 20, 20)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = [@"用户追加评价:" stringByAppendingString:commentinfo[@"append_content"]];
        [self.contentView addSubview:label];
        hh += 30;
    }
    if ([commentinfo[@"append_images"] length] > 10) {
        NSString *str = commentinfo[@"append_images"];
        
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *images = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        for(int j = 0 ;j<images.count;j++){
            UIButton *imgBtns = [[UIButton alloc]initWithFrame:CGRectMake(10 + 87 * j , hh, 77, 77)];
            [self.contentView addSubview:imgBtns];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *immm = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[AddressPath stringByAppendingString:images[j]] ]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imgBtns setImage:immm forState:UIControlStateNormal];
                });
            });
        }
        hh += 90;
    }
    
    if ([commentinfo[@"append_replay_content"] length] > 0) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, hh, Sc_w - 20, 20)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = [@"掌柜回复:" stringByAppendingString:commentinfo[@"append_replay_content"]];
        label.backgroundColor = My_gray;
        [self.contentView addSubview:label];
        hh += 30;
    }
    
    [self.contentView addSubview:headimg];
    [self.contentView addSubview:name];
    [self.contentView addSubview:time];
    [self.contentView addSubview:commentLabel];
    
    headimg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:commentinfo[@"headimgurl"]]]];
    name.text = commentinfo[@"nickname"];
    time.text = commentinfo[@"createtime"];
    commentLabel.text = commentinfo[@"content"];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
