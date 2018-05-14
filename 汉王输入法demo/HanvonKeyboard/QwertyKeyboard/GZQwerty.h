//
//  GZQwerty.h
//  HanvonKeyboard
//
//  Created by hanvon on 2017/11/4.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *全键盘 核心库操作
 ***/

@interface GZQwerty : NSObject
typedef void (^SuccesInputBlock)(NSString *compontText, NSArray *candiateArray);//输入 成功回传数据
typedef void (^SuccesSelectBlock)(NSString *compontText, NSArray *candiateArray);//选择候选 成功回传数据
typedef void (^SuccesPredictBlock)(NSArray *candiateArray);//联想 成功回传数据
typedef void (^SuccesPinyinBlock)(NSString *compontText, NSArray *candiateArray, NSArray *compontArr);//更多候选 选择拼音
+ (id)defaultQwerty;
- (void)sendInput:(int)inputCode complation:(SuccesInputBlock)data; //键盘输入
- (void)sendSelectedIndex:(int)index andStr:(NSString*)str selectComplation:(SuccesSelectBlock)selectdata predicComplation:(SuccesPredictBlock)predicdata; //点击候选按钮 有联系
- (void)selectIndex:(int)index complation:(SuccesSelectBlock)selectdata; //选择候选 没有联想
- (void)predicInput:(NSString*)text complation:(SuccesPredictBlock)data; //文字联想
- (void)sendPinyinCompontInput:(int)inputCode complation:(SuccesPinyinBlock)data; //带候选拼音 键盘输入
- (void)sendSelectedPinyinIndex:(int)index andStr:(NSString*)str complation:(SuccesPinyinBlock)data; //选择某一候选拼音
- (BOOL)isSelectFinish; //选择候选index是否结束
- (NSString*)getResultStr; //候选结束，获取之前的选择 比如“好ren” //获取拼音串
- (NSArray*)getCompontArr; //获取拼音候选
- (NSInteger)getSelectedCompont; //获取拼音高亮的数据
- (void)changeDictionary:(int)type; //修改词典 -1重新初始化 0中文 1英文
- (void)changeFuzzy; //修改模糊音设置
- (void)changeRecovery; //修改纠错设置
- (void)keyboardReset; // 重置
- (void)releaseShare; //释放单例
- (void)releaseDictionary; //释放字典
- (void)releaseWorkspace; // 释放工作空间
@end
