//
//  AddressViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/9/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "AddressViewController.h"
#import <ActionSheetCustomPicker.h>
#import "Masonry.h"
#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "AddressManager.h"
@interface AddressViewController () <ActionSheetCustomPickerDelegate>

@property (nonatomic,strong) NSArray *provinceArr; // 省
@property (nonatomic,strong) NSArray *countryArr; // 市
@property (nonatomic,strong) NSArray *districtArr; // 区
@property (nonatomic,assign) NSInteger index1; // 省下标
@property (nonatomic,assign) NSInteger index2; // 市下标
@property (nonatomic,assign) NSInteger index3; // 区下标
@property (nonatomic,strong) ActionSheetCustomPicker *picker; // 选择器
@property (nonatomic,strong) UILabel *locationLabel;
@property (nonatomic,strong) UIButton *locationButton;

@end

@implementation AddressViewController


-(void)loadData{
    _index1 = 0;
    _index2 = 0;
    _index3 = 0;
    _provinceArr = [[AddressManager getInstance] getProvince];
    [self p_calculateAddress];
}

-(void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    _locationLabel = [UILabel new];
    _locationLabel.font = [UIFont systemFontOfSize:12];
    _locationLabel.textColor = [UIColor blackColor];
    [self.view addSubview:_locationLabel];
    
    _locationButton = [UIButton new];
    _locationButton.backgroundColor = [UIColor nameColor];
    [_locationButton setTitle:@"点击" forState:UIControlStateNormal];
    [self.view addSubview:_locationButton];
    
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).with.offset(50);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(@30);
    }];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_locationButton.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(@20);
    }];
    
}
-(void)bindListener{
    _locationButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        self.picker = [[ActionSheetCustomPicker alloc]initWithTitle:@"选择地区" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(self.index1),@(self.index2),@(self.index3)]];
        self.picker.tapDismissAction  = TapActionSuccess;
        [self.picker showActionSheetPicker];
        return [RACSignal empty];
    }];
}

-(void)saveData{
    
}

// 根据传进来的下标数组计算对应的三个数组
- (void)p_calculateAddress{
    _countryArr = [[AddressManager getInstance] getCity:_index1];
    _districtArr = [[AddressManager getInstance] getDistanceByProvinceIndex:_index1 andCityIndex:_index2];
}

#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    // Returns
    switch (component){
        case 0:
            return self.provinceArr.count;
        case 1:
            return self.countryArr.count;
        case 2:
            return self.districtArr.count;
        default:break;
    }
    return 0;
}

#pragma mark UIPickerViewDelegate Implementation

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component){
        case 0:
            return self.provinceArr[row];
            break;
        case 1:
            return self.countryArr[row];
            break;
        case 2:
            return self.districtArr[row];
            break;
        default:
            break;
    }
    return nil;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* label = (UILabel*)view;
    if (!label){
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:12]];
    }
    
    NSString * title = @"";
    switch (component){
        case 0:
            title = self.provinceArr[row];
            break;
        case 1:
            title = self.countryArr[row];
            break;
        case 2:
            title = self.districtArr[row];
            break;
        default:
            break;
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.text=title;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component){
        case 0:{
            self.index1 = row;
            self.index2 = 0;
            self.index3 = 0;
            // 滚动的时候都要进行一次数组的刷新
            [self p_calculateAddress];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
            
        case 1:{
            self.index2 = row;
            self.index3 = 0;
            [self p_calculateAddress];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        }
            break;
        case 2:
            self.index3 = row;
            break;
        default:
            break;
    }
}

- (void)configurePickerView:(UIPickerView *)pickerView{
    pickerView.showsSelectionIndicator = NO;
}
// 点击done的时候回调
- (void)actionSheetPickerDidSucceed:(ActionSheetCustomPicker *)actionSheetPicker origin:(id)origin{
    NSMutableString *detailAddress = [[NSMutableString alloc] init];
    if (self.index1 < self.provinceArr.count) {
        NSString *firstAddress = self.provinceArr[self.index1];
        [detailAddress appendString:firstAddress];
    }
    if (self.index2 < self.countryArr.count) {
        NSString *secondAddress = self.countryArr[self.index2];
        [detailAddress appendString:secondAddress];
    }
    if (self.index3 < self.districtArr.count) {
        NSString *thirfAddress = self.districtArr[self.index3];
        [detailAddress appendString:thirfAddress];
    }
    _locationLabel.text = detailAddress;
    
}


@end
