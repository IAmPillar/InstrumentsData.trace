//
//  GZChineseKeyboardCore.h
//  HanvonKeyboard
//
//  Created by hanvon on 2017/12/29.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *中文全键盘、中文九键盘、中文笔画键盘
 *调用核心库
 *初始化工作空间、字典
 ***/

@interface GZChineseKeyboardCore : NSObject
+ (id)shareChineseKeyboardCore;
- (HWIM_HANDLE *)getHandle;
- (char*)getRam;
- (void)cleanData;
- (void)releaseDictionary; //释放键盘词典 适用于同核心的键盘之间切换
- (void)releaseWorkspace; //键盘核心全局运行，不再释放
- (BOOL)changeDictionary:(int)type; //修改词典 0中文 1英文 2手写联想
@end
