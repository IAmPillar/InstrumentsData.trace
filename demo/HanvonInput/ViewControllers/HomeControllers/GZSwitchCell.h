//
//  GZSwitchCell.h
//  HanvonInput
//
//  Created by hanvon on 2017/11/14.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *带选择开关的cell
 *键盘设置使用
 **/

@interface GZSwitchCell : UITableViewCell
@property (nonatomic,copy) UILabel *title;
@property (nonatomic,copy) UISwitch *switchButton;
@property (nonatomic,copy) void(^sendSwitch)(BOOL isOpen);
@end
