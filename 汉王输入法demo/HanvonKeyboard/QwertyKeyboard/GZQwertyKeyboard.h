//
//  GZQwertyKeyboard.h
//  HanvonKeyboard
//
//  Created by hanvon on 2017/11/4.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *全键盘view
 *注意：除了中英切换功能、英文全键的大小写切换功能、删除键（一部分），在当前页面直接操作外。
 *     其余所有按钮的点击事件都回调给父视图操作。
 ***/


@interface GZQwertyKeyboard : GZKeyboardBackgroundeView
@property (nonatomic,strong) id superTarget;
@property (nonatomic, copy) void(^sendSelectedStr)(NSString* text); //文本按键返回
@property (nonatomic, copy) void(^sendSelectedFunc)(int funcType); //功能按键返回 1分隔 2删除 3符号 4下一个输入法 5数字 6空格 7中英切换 8回车 10逗号 11点号
@property (nonatomic, copy) void(^sendDeleteTap)(BOOL isDelete); //删除功能键 返回 删除功能不在sendSelectedFunc中返回功能
/**
 *初始化全键盘 Type为初始化时默认键盘
 *1中文 2英文小写  3大写  4大写锁定
 ***/
- (instancetype)initWithFrame:(CGRect)frame andKeyboardType:(int)type;
/**
 *切换横竖屏时，传入的新高度
 ***/
- (void)changeViewFrame:(CGRect)newFrame;
- (void)changeBackgroudColor;
/**
 *键盘中英文切换
 *1中文全键盘 2英文全键盘-小写  3英文大写 4英文大写锁定
 ***/
- (void)changeKeyboardType:(int)type;
- (void)changeKeyboardStatusToInput:(BOOL)input; //正在输入中
- (void)stopTimer; //手动停止计时器

@end
