//
//  GZCandidateBarView.h
//  HanvonKeyboard
//
//  Created by hanvon on 2017/11/4.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *键盘输入 候选区
 ***/

@interface GZCandidateBarView : UIView

/**点击删除键 删除第一个候选的 最后一个字符 （手写键盘专用）
 *回删按钮 成功回传
 *isSucsess删除成功
 *isRemoveCandidateView需要清除候选框view
 ***/
typedef void (^SuccesDeleteBackwardBlock)(BOOL isSucsess, BOOL isRemoveCandidateView);
- (void)deleteBackwardActionByNowCandidates:(NSArray*)texArr complation:(SuccesDeleteBackwardBlock)data;

- (void)changeShowPinyin:(NSString *)pinyin andRange:(NSRange)range; //改变拼音结果 带下划线
- (void)changeShowText:(NSArray*)textArr; //改变候选结果
- (BOOL)isTabBarHasData; //判断是否存在候选内容
- (BOOL)isTabBarHasPinyin; //是否有拼音
- (void)changeShowMoreButton:(int)type; //改变展示更多 按钮  0收起 1展示更多
- (void)changeShowMoreToDelete:(BOOL)changeToDelete; //改变展示更多按钮 成为删除按钮 1添加删除 0移除删除并移除tabbar
//- (NSArray*)getCadidateArray; //获取候选内容
- (NSString*)getFirstCandidate; //获取候选第一个
//- (NSString*)getPinyin; //获取拼音
- (void)changeViewFrame:(CGRect)newFrame; //切换横竖屏时，传入的新高度
//- (void)changeViewToHidden; //隐藏候选栏

@property (nonatomic, copy) void(^sendSelectedStr)(NSString* text, int index); //选择候选 返回结果
@property (nonatomic, copy) void(^sendShowMoreFunc)(BOOL isShowMore, NSArray *data); //展示更多候选结果
@property (nonatomic, copy) void(^sendRemoveTabbar)(BOOL remove); //调用删除键 移除候选栏

@end
