//
//  WorkOrderStepCell.m
//  qmcp
//
//  Created by 谢永明 on 16/3/30.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"

@interface WorkOrderStepCell()
@property(nonatomic, strong) UILabel *titleText;
@property (nonatomic,strong)UIImageView *image;
@property (nonatomic,strong)UILabel *contentText;
@end
@implementation WorkOrderStepCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"gb";
    
    WorkOrderStepCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[WorkOrderStepCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.selectedBackgroundView.backgroundColor = [UIColor themeColor];
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

//重写属性的setter方法，给子控件赋值
- (void)setWorkOrderStep:(WorkOrderStep *)workOrderStep
{
    if(workOrderStep != nil){
        _titleText.text = workOrderStep.stepName;
        _contentText.text = workOrderStep.content;
    }

}

-(void)imageBackgroud:(NSString *)imageName
{
    UIImage *backgroudImage = [[UIImage imageNamed:imageName]resizableImageWithCapInsets:UIEdgeInsetsMake(30,80,5,30)];
    [_image setImage:backgroudImage];
}

-(void)initView
{
    _image = [UIImageView new];
    [self.contentView addSubview:_image];
    [_image mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(4);
    }];
    
    _titleText = [UILabel new];
    [self.contentView addSubview:_titleText];
    [_titleText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.equalTo(self.contentView.mas_left).with.offset(50);
        make.right.equalTo(self.contentView.mas_right).with.offset(10);
    }];

    _contentText = [UILabel new];
    _contentText.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_contentText];
    [_contentText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_titleText.mas_bottom).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(50);
        make.right.equalTo(self.contentView.mas_right).with.offset(10);
    }];

}
@end
