//
//  GZSwitchCell.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/14.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZSwitchCell.h"

@implementation GZSwitchCell

- (void)dealloc {
    NSLog(@"键盘设置 cell 销毁");
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)cellStyle reuseIdentifier:(NSString*)cellID {
    self = [super initWithStyle:cellStyle reuseIdentifier:cellID];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}

- (void)creatUI {

    CGFloat left = 10;
    CGFloat height = self.frame.size.height;

    CGFloat titleW = (SCREEN_WIDTH*2)/3;
    _title = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, titleW, height)];
    _title.backgroundColor = [UIColor whiteColor];
    _title.textColor = [UIColor blackColor];
    _title.textAlignment = NSTextAlignmentLeft;
    _title.font = [UIFont systemFontOfSize:18];
    [self addSubview:_title];

    //默认尺寸为79 * 27
    CGFloat switchW = 79;
    CGFloat switchH = 27;
    CGFloat switchX = SCREEN_WIDTH - left - switchW;
    _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(switchX, (height-switchH)/2.0, switchW, switchH)];
    [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_switchButton];
}

- (void)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        if (self.sendSwitch) {
            [switchButton setOn:NO];
            self.sendSwitch(NO);
        }
    }else {
        if (self.sendSwitch) {
            [switchButton setOn:YES];
            self.sendSwitch(YES);
        }
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
