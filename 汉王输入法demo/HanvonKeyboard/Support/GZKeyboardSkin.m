//
//  GZKeyboardSkin.m
//  HanvonKeyboard
//
//  Created by hanvon on 2017/11/29.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZKeyboardSkin.h"
//#import "UIColor+GZColorHex.h"

static GZKeyboardSkin *share;
static dispatch_once_t onceToken;

@implementation GZKeyboardSkin
+ (id)defaultKeyboardSkin {
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}

- (void)setSkin:(NSString*)skin {

    if ([skin isEqualToString:@"default"]) {
        //默认皮肤 日间、夜间

        //键盘背景相关
        _backgroungColor_kb = Color_background_kb;

        //导航相关
        _backgroungColor_nav = [UIColor whiteColor];

        //悬浮视图相关 如符号键盘左侧的滚动视图
        _backgroudImage_suspend = nil;
        _backgroungColor_suspend = Color_background_kb;
        _shadowColor_suspend = nil;
        _cornerRadius_suspend = 5;
        _backgroudImage_suspend_l = nil;
        _backgroungColor_suspend_l = [UIColor whiteColor];
        _shadowColor_suspend_l = nil;
        _cornerRadius_suspend_l = 5;
        _backgroudImage_suspend_b = nil;
        _backgroungColor_suspend_b = [UIColor colorWithHexString:float_Color_button_function alpha:1];
        _shadowColor_suspend_l = nil;
        _cornerRadius_suspend_b = 5;

        //候选框相关
        _backgroungColor_cd = [UIColor whiteColor];
        _shadowColor_cd = nil;
        _hightlightImage_cd_btn = nil; //@"key_hightlight";
        _backgroungColor_cd_btn = [UIColor clearColor];
        _shadowColor_cd_btn =  nil;//[UIColor blackColor];
        _backgroungColor_cd_subs = [UIColor whiteColor];
        _cornerRadius_cd_btn = 0;
        _titleColor_cd_btn = [UIColor blackColor];

        //按钮相关
        _hightlightImage_btn = nil; //@"key_hightlight";
        _backgroungColor_btn = [UIColor whiteColor];
        _shadowColor_btn = nil;//[UIColor blackColor];
        _cornerRadius_btn = 5;
        _titleColor_btn = [UIColor blackColor];

        //功能按钮相关
        _hightlightImage_btn_f = nil; //@"key_hightlight";
        _backgroungColor_btn_f = [UIColor colorWithHexString:float_Color_button_function alpha:1];
        _shadowColor_btn_f = nil;//[UIColor blackColor];
        _cornerRadius_btn_f = 5;
        _titleColor_btn_f = [UIColor whiteColor];

        //功能按键 手写键盘左侧
        _hightlightImage_btn_wright_l = nil; //@"key_hightlight";
        _backgroungColor_btn_wright_l = [UIColor clearColor];
        _shadowColor_btn_wright_l = nil;//[UIColor whiteColor];
        _cornerRadius_btn_wright_l = 0;
        _titleColor_btn_wright_l = [UIColor whiteColor];

        //功能按钮 符号键盘左侧
        _hightlightImage_btn_symbol_l = nil; //@"key_hightlight";
        _backgroungColor_btn_symbol_l = [UIColor whiteColor];
        _shadowColor_btn_symbol_l = nil;
        _cornerRadius_btn_symbol_l = 0;
        _titleColor_btn_symbol_l = [UIColor blackColor];

        //功能按键 符号键盘底端
        _hightlightImage_btn_symbol_b = nil; //@"key_hightlight";
        _backgroungColor_btn_symbol_b = nil;
        _shadowColor_btn_symbol_b = nil;
        _cornerRadius_btn_symbol_b = 0;
        _titleColor_btn_symbol_b = [UIColor whiteColor];

    }else {
        //下载的
    }
}


/*
 //保留的代码
 - (void)getSettingData {
 NSNumber *nightMode; //0日间模式 1夜间模式
 if ([nightMode isEqualToNumber:@0]) {
 _backgroungColor_kb = Color_background_kb; //键盘背景相关

 _backgroungColor_nav = [UIColor whiteColor]; //导航相关

 _backgroungColor_cd = [UIColor whiteColor]; //候选框相关
 _shadowColor_cd = nil;
 _hightlightImage_cd_btn = nil; //@"key_hightlight";
 _backgroungColor_cd_btn = [UIColor clearColor];
 _shadowColor_cd_btn =  [UIColor blackColor];
 _backgroungColor_cd_subs = [UIColor whiteColor];
 _cornerRadius_cd_btn = 0;
 _titleColor_cd_btn = [UIColor blackColor];

 _hightlightImage_btn = nil; //@"key_hightlight"; //按钮相关
 _backgroungColor_btn = [UIColor whiteColor];
 _shadowColor_btn = [UIColor blackColor];
 _cornerRadius_btn = 5;
 _titleColor_btn = [UIColor blackColor];

 _hightlightImage_btn_f = nil; //@"key_hightlight"; //功能按钮相关
 _backgroungColor_btn_f = [UIColor lightGrayColor];
 _shadowColor_btn_f = [UIColor blackColor];
 _cornerRadius_btn_f = 5;
 _titleColor_btn_f = [UIColor whiteColor];

 _hightlightImage_btn_wright_l = nil; //@"key_hightlight"; //功能按键 手写键盘左侧
 _backgroungColor_btn_wright_l = [UIColor clearColor];
 _shadowColor_btn_wright_l = [UIColor whiteColor];
 _cornerRadius_btn_wright_l = 0;
 _titleColor_btn_wright_l = [UIColor whiteColor];

 //_hightlightImage_btn_symbol_l = nil; //@"key_hightlight"; //功能按钮 符号键盘左侧
 _backgroungColor_btn_symbol_l = [UIColor whiteColor];
 _shadowColor_btn_symbol_l = nil;
 _cornerRadius_btn_symbol_l = 0;
 _titleColor_btn_symbol_l = [UIColor blackColor];

 //_hightlightImage_btn_symbol_b = nil; //@"key_hightlight"; //功能按键 符号键盘底端
 _backgroungColor_btn_symbol_b = nil;
 //_shadowColor_btn_symbol_b = [UIColor blackColor];
 _cornerRadius_btn_symbol_b = 0;
 _titleColor_btn_symbol_b = [UIColor whiteColor];
 }else if ([nightMode isEqualToNumber:@1]) {
 _backgroungColor_kb = [UIColor colorWithWhite:0.6 alpha:1]; //键盘背景相关

 _backgroungColor_nav = [UIColor colorWithWhite:0.6 alpha:1]; //导航相关

 _backgroungColor_cd = [UIColor colorWithWhite:0.6 alpha:1]; //候选框相关
 _shadowColor_cd = nil;
 _hightlightImage_cd_btn = nil; //@"key_hightlight";
 _backgroungColor_cd_btn = [UIColor clearColor];
 _shadowColor_cd_btn =  [UIColor blackColor];
 _backgroungColor_cd_subs = [UIColor colorWithWhite:0.7 alpha:1];
 _cornerRadius_cd_btn = 0;
 _titleColor_cd_btn = [UIColor blackColor];

 _hightlightImage_btn = nil; //@"key_hightlight"; //按钮相关
 _backgroungColor_btn = [UIColor colorWithWhite:0.7 alpha:1];
 _shadowColor_btn = [UIColor blackColor];
 _cornerRadius_btn = 5;
 _titleColor_btn = [UIColor blackColor];

 _hightlightImage_btn_f = nil; //@"key_hightlight"; //功能按钮相关
 _backgroungColor_btn_f = [UIColor lightGrayColor];
 _shadowColor_btn_f = [UIColor blackColor];
 _cornerRadius_btn_f = 5;
 _titleColor_btn_f = [UIColor blackColor];

 _hightlightImage_btn_wright_l = nil; //@"key_hightlight"; //功能按键 手写键盘左侧
 _backgroungColor_btn_wright_l = [UIColor clearColor];
 _shadowColor_btn_wright_l = [UIColor whiteColor];
 _cornerRadius_btn_wright_l = 0;
 _titleColor_btn_wright_l = [UIColor whiteColor];

 //_hightlightImage_btn_symbol_l = nil; //@"key_hightlight"; //功能按钮 符号键盘左侧
 _backgroungColor_btn_symbol_l = [UIColor colorWithWhite:0.7 alpha:1];
 _shadowColor_btn_symbol_l = nil;
 _cornerRadius_btn_symbol_l = 0;
 _titleColor_btn_symbol_l = [UIColor blackColor];

 //_hightlightImage_btn_symbol_b = nil; //@"key_hightlight"; //功能按键 符号键盘底端
 _backgroungColor_btn_symbol_b = nil;
 //_shadowColor_btn_symbol_b = [UIColor blackColor];
 _cornerRadius_btn_symbol_b = 0;
 _titleColor_btn_symbol_b = [UIColor whiteColor];

 }else {}
 }*/

@end
