//
//  PickupView.h
//  qmcp
//
//  Created by 谢永明 on 16/7/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface PickupView : BaseView
@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UILabel *qrButton;
@property(nonatomic,strong) UILabel *signButton;

@property(nonatomic,strong) UILabel *codeText;
@property(nonatomic,strong) UILabel *nameText;
@property(nonatomic,strong) UILabel *phoneText;


@property(nonatomic,strong) UIView *headView;
@end
