//
//  GZView+GZSetting.m
//  HanvonKeyboard
//
//  Created by hanvon on 2017/11/30.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZView+GZSetting.h"
#import "GZKeyboardSkin.h"

@implementation GZView (GZSetting)
- (void)setButtonBackgroundColor:(UIColor*)backgroungColor {
    if (!backgroungColor) {
        self.backgroundColor = [UIColor clearColor];
        return;
    }
    self.backgroundColor = backgroungColor;
}
- (void)setButtonShadow:(UIColor*)shadowColor {
    if (!shadowColor) {
        return;
    }
    self.layer.shadowColor = [shadowColor CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowRadius = 5;
}
- (void)setButtonCornerRadius:(CGFloat)radius {
    if (radius == 0.0) {
        return;
    }
    self.layer.cornerRadius = radius;
}
@end


//导航
@implementation GZKeyboardNavigationView (GZSetting)
- (void)setViewStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    //背景图
    if (skin.backgroudImage_nav) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.bounds];
        imageview.image = [UIImage imageNamed:skin.backgroudImage_nav];
        [self addSubview:imageview];
    }

    //背景色
    self.backgroundColor = skin.backgroungColor_nav;

    //阴影
    if (skin.shadowColor_nav) {
        self.layer.shadowColor = [skin.shadowColor_nav CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }
}
@end

//候选框
@implementation GZKeyboardCandidateView (GZSetting)
- (void)setViewStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    //背景图
    if (skin.backgroudImage_cd) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.bounds];
        imageview.image = [UIImage imageNamed:skin.backgroudImage_cd];
        [self addSubview:imageview];
    }

    //背景色
    self.backgroundColor = skin.backgroungColor_cd;

    //阴影
    if (skin.shadowColor_cd) {
        self.layer.shadowColor = [skin.shadowColor_cd CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }
    //按钮
}
@end

//键盘父视图
@implementation GZKeyboardBackgroundeView (GZSetting)
- (void)setViewStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    //背景图
    if (skin.backgroudImage_kb) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.bounds];
        imageview.image = [UIImage imageNamed:skin.backgroudImage_kb];
        [self addSubview:imageview];
    }

    //背景色
    self.backgroundColor = Color_background_kb;
}
@end

//悬浮视图视图 如符号键盘
@implementation GZKeyboardSuspendView (GZSetting)
- (void)setViewStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    //背景图
    if (skin.backgroudImage_suspend) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.bounds];
        imageview.image = [UIImage imageNamed:skin.backgroudImage_suspend];
        [self addSubview:imageview];
    }

    //背景色
    if (skin.backgroungColor_suspend) {
        self.backgroundColor = skin.backgroungColor_suspend;
    }

    //阴影颜色
    if (skin.shadowColor_suspend) {
        self.layer.shadowColor = [skin.shadowColor_suspend CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }

    //圆角
    if (skin.cornerRadius_suspend) {
        self.layer.cornerRadius = skin.cornerRadius_suspend;
    }
}
@end

//悬浮视图视图 如符号键盘左侧
@implementation GZKeyboardSuspendView_left (GZSetting)
- (void)setViewStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    //背景图
    if (skin.backgroudImage_suspend_l) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.bounds];
        imageview.image = [UIImage imageNamed:skin.backgroudImage_suspend_l];
        [self addSubview:imageview];
    }

    //背景色
    if (skin.backgroungColor_suspend_l) {
        self.backgroundColor = skin.backgroungColor_suspend_l;
    }

    //阴影颜色
    if (skin.shadowColor_suspend_l) {
        self.layer.shadowColor = [skin.shadowColor_suspend_l CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }

    //圆角
    if (skin.cornerRadius_suspend_l != 0) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = skin.cornerRadius_suspend_l;
    }
}
@end

//悬浮视图视图 如符号键盘底部
@implementation GZKeyboardSuspendView_bottom (GZSetting)
- (void)setViewStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    //背景图
    if (skin.backgroudImage_suspend_b) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.bounds];
        imageview.image = [UIImage imageNamed:skin.backgroudImage_suspend_b];
        [self addSubview:imageview];
    }

    //背景色
    if (skin.backgroungColor_suspend_b) {
        self.backgroundColor = skin.backgroungColor_suspend_b;
    }

    //阴影颜色
    if (skin.shadowColor_suspend_b) {
        self.layer.shadowColor = [skin.shadowColor_suspend_b CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }

    //圆角
    if (skin.cornerRadius_suspend_b) {
        self.layer.cornerRadius = skin.cornerRadius_suspend_b;
    }
}
@end
