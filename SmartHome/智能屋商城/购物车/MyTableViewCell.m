//
//  MyTableViewCell.m
//  个人通讯录
//
//  Created by mac on 2016/11/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MyTableViewCell.h"

static CGFloat CELL_HEIGHT = 100;


@interface MyTableViewCell () <UITextFieldDelegate>


@end

@implementation MyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createview];
    }
    return self;
}

-(void)createview{
    
    UIImage *normolImg = [UIImage imageNamed:@"morensz"];
    UIImage *selectImg = [UIImage imageNamed:@"morensz-xuanz"];
    
//    选中按钮
    self.selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CELL_HEIGHT/2 - 10, 20, 20)];
    [_selectBtn setImage:normolImg forState:UIControlStateNormal];
    
    [_selectBtn addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_selectBtn setImage:normolImg forState:UIControlStateNormal];
    [_selectBtn setImage:selectImg forState:UIControlStateSelected];
    [self.contentView addSubview:_selectBtn];
    
    
//    商品图片
    _shoppingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_selectBtn.frame)+7, 12, 70, 70)];
    _shoppingImgView.layer.borderWidth = 1;
    _shoppingImgView.layer.borderColor = My_gray.CGColor;
    
    
    [self.contentView addSubview:_shoppingImgView];
    
//    商品标题
    _title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shoppingImgView.frame)+10, 10, Sc_w -CGRectGetMaxX(_shoppingImgView.frame)-15, 21)];
    _title.font=[UIFont systemFontOfSize:14];
    _title.textColor=[UIColor blackColor];
    [self.contentView addSubview:_title];
    
//    规格
    _typeName = [[UILabel alloc] initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_title.frame) + 10, 60, 20)];
    _typeName.font=[UIFont systemFontOfSize:12];
    _typeName.textColor=[UIColor blackColor];
    [self.contentView addSubview:_typeName];
    
    _colortype = [[UIButton alloc]initWithFrame:CGRectMake(_title.frame.origin.x + 60, CGRectGetMaxY(_title.frame) + 10, 70, 20)];
    _colortype.layer.cornerRadius = 3.0;
    _colortype.titleLabel.font = [UIFont systemFontOfSize:12];
    _colortype.backgroundColor = Color_system;
    [self.contentView addSubview:_colortype];
    
    _price = [[UILabel alloc]initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_typeName.frame)+12, 100, 17)];
    _price.hidden =NO;
    _price.font =  [UIFont systemFontOfSize:14];
    _price.textColor=[UIColor redColor];
    [self.contentView addSubview:_price];
    
    
    _countLab = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 60, 60, 40, 20)];
    _countLab.font = [UIFont systemFontOfSize:15];
    _countLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_countLab];
    
    _removeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 80, 30, 50, 20)];
    [_removeBtn setTitle:@"删除" forState:UIControlStateNormal];
    _removeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_removeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_removeBtn];
    _removeBtn.hidden = YES;
    [_removeBtn addTarget:self action:@selector(removeClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)removeClick{
    
    self.removeBlock();
    
}


-(void)setOptionstock:(NSInteger)optionstock{
    _optionstock = optionstock;
    
    
    NSLog(@"%f",_buyCount.frame.size.width);
    if (_buyCount.frame.size.width == 120) {
        return;
        
    }
    _buyCount = [[WLZ_ChangeCountView alloc] initWithFrame:CGRectMake(Sc_w - 120, 60, 120, 35) chooseCount:_choosedCount totalCount:_optionstock];
    
    [_buyCount.subButton addTarget:self action:@selector(subButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _buyCount.numberFD.delegate = self;
    
    [_buyCount.addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_buyCount];
    
    NSLog(@"22------");
}




-(void)clickSelect:(UIButton *)sender
{
    
    _selectBtn.selected = !_selectBtn.selected;
    
    if(_selectBtn.selected){
        NSLog(@"选中");
        self.selectBlock(_choosedCount);
    }else{
        self.selectBlock(-_choosedCount);
    }
    
}


- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _buyCount.numberFD = textField;
    if ([self isPureInt:_buyCount.numberFD.text]) {
        if ([_buyCount.numberFD.text integerValue]<0) {
            _buyCount.numberFD.text=@"1";
        }
        
    }
    else
    {
        _buyCount.numberFD.text=@"1";
    }
    
    
    if ([_buyCount.numberFD.text isEqualToString:@""] || [_buyCount.numberFD.text isEqualToString:@"0"]||[_buyCount.numberFD.text isEqualToString:@"1"]) {
//        self.choosedCount = 1;
        _buyCount.numberFD.text=@"1";
        
        _buyCount.subButton.enabled = NO;
        _buyCount.addButton.enabled = YES;
    }
    NSString *numText = _buyCount.numberFD.text;
    if ([numText intValue]>self.optionstock) {
        _buyCount.numberFD.text=[NSString stringWithFormat:@"%zi",self.optionstock];
        
        _buyCount.addButton.enabled=NO;
        _buyCount.subButton.enabled = YES;
        
    }
    NSLog(@"%ld - %ld",self.choosedCount,[_buyCount.numberFD.text integerValue]);
    
    if (_selectBtn.selected) {
        
        self.selectBlock([_buyCount.numberFD.text integerValue] - self.choosedCount);
    }
    
    self.choosedCount = [_buyCount.numberFD.text integerValue];
    
}


//减
- (void)subButtonPressed:(id)sender
{
    
    -- self.choosedCount ;
    
    if (self.choosedCount==1) {
        self.choosedCount= 1;
        _buyCount.subButton.enabled=NO;
    }
    else
    {
        _buyCount.addButton.enabled=YES;
        
    }
    _buyCount.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
    
    if (_selectBtn.selected) {
        self.selectBlock(-1);
    }
    
}

//加
- (void)addButtonPressed:(id)sender
{
    
    
    ++self.choosedCount ;
    if (self.choosedCount>0) {
        _buyCount.subButton.enabled=YES;
    }
    
    
    if (_optionstock<self.choosedCount) {
        self.choosedCount  = _optionstock;
        _buyCount.addButton.enabled = NO;
    }
    else
    {
        _buyCount.subButton.enabled = YES;
    }
    
    
    _buyCount.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
    if (_selectBtn.selected) {
        self.selectBlock(1);
    }
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
