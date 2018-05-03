//
//  GZAlertInputView.h
//  HanvonInput
//
//  Created by hanvon on 2017/12/21.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *alert样式的输入框
 ***/

@interface GZAlertInputView : UIView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title detail:(NSString*)detail;
- (void)setInputTextDetail:(NSString*)detailStr; //设置文本框内容 可以为nil
@property (nonatomic,copy) void(^sendInputString)(NSString *inputString); //inputString=nil表示取消
@end
