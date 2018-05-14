//
//  GZButton+GZSetting.m
//  HanvonKeyboard
//
//  Created by hanvon on 2017/11/23.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZButton+GZSetting.h"
#import "GZKeyboardSkin.h"

@implementation GZButton (GZSetting)
- (void)setButtonBackgroudHightlight:(NSString*)image {
    if (!image || ![UIImage imageNamed:image]) {
        return;
    }
    [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
}
- (void)setButtonBackgroudImage:(NSString*)image {
    if (!image || ![UIImage imageNamed:image]) {
        return;
    }
    [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}
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


//键盘字母按键
@implementation GZKeyButton (GZSetting)
- (void)setButtonStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    if (skin.hightlightImage_btn) {
        [self setBackgroundImage:[UIImage imageNamed:skin.hightlightImage_btn] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:skin.hightlightImage_btn] forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    if (skin.backgroudImage_btn) {
        [self setBackgroundImage:[UIImage imageNamed:skin.backgroudImage_btn] forState:UIControlStateNormal];
    }
    if (skin.backgroungColor_btn) {
        [self setBackgroundColor:skin.backgroungColor_btn];
    }
    if (skin.shadowColor_btn) {
        self.layer.shadowColor = [skin.shadowColor_btn CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }
    if (skin.cornerRadius_btn != 0.0) {
        self.layer.cornerRadius = skin.cornerRadius_btn;
    }
    if (skin.titleColor_btn) {
        [self setTitleColor:skin.titleColor_btn forState:UIControlStateNormal];
    }
}
@end

//数字按键
@implementation GZNumberButton (GZSetting)
- (void)setButtonStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    if (skin.hightlightImage_btn) {
        [self setBackgroundImage:[UIImage imageNamed:skin.hightlightImage_btn] forState:UIControlStateHighlighted];
    }
    if (skin.backgroudImage_btn) {
        [self setBackgroundImage:[UIImage imageNamed:skin.backgroudImage_btn] forState:UIControlStateNormal];
    }
    if (skin.backgroungColor_btn) {
        [self setBackgroundColor:skin.backgroungColor_btn];
    }
    if (skin.shadowColor_btn) {
        self.layer.shadowColor = [skin.shadowColor_btn CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }
    if (skin.cornerRadius_btn != 0.0) {
        self.layer.cornerRadius = skin.cornerRadius_btn;
    }
    if (skin.titleColor_btn) {
        [self setTitleColor:skin.titleColor_btn forState:UIControlStateNormal];
    }
}
@end

//符号按键
@implementation GZSymbolButton (GZSetting)
- (void)setButtonStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    if (skin.hightlightImage_btn) {
        [self setBackgroundImage:[UIImage imageNamed:skin.hightlightImage_btn] forState:UIControlStateHighlighted];
    }
    if (skin.backgroudImage_btn) {
        [self setBackgroundImage:[UIImage imageNamed:skin.backgroudImage_btn] forState:UIControlStateNormal];
    }
    if (skin.backgroungColor_btn) {
        [self setBackgroundColor:skin.backgroungColor_btn];
    }
    if (skin.shadowColor_btn) {
        self.layer.shadowColor = [skin.shadowColor_btn CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }
    if (skin.cornerRadius_btn != 0.0) {
        self.layer.cornerRadius = skin.cornerRadius_btn;
    }
    if (skin.titleColor_btn) {
        [self setTitleColor:skin.titleColor_btn forState:UIControlStateNormal];
    }
}
@end

//候选框按键
@implementation GZCadidateButton (GZSetting)
- (void)setButtonStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    if (skin.hightlightImage_cd_btn) {
        [self setBackgroundImage:[UIImage imageNamed:skin.hightlightImage_cd_btn] forState:UIControlStateHighlighted];
    }
    if (skin.backgroudImage_cd_btn) {
        [self setBackgroundImage:[UIImage imageNamed:skin.backgroudImage_cd_btn] forState:UIControlStateNormal];
    }
    if (skin.backgroungColor_cd_btn) {
        [self setBackgroundColor:skin.backgroungColor_cd_btn];
    }
    if (skin.shadowColor_cd_btn) {
        self.layer.shadowColor = [skin.shadowColor_cd_btn CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }
    if (skin.cornerRadius_cd_btn != 0.0) {
        self.layer.cornerRadius = skin.cornerRadius_cd_btn;
    }
    if (skin.titleColor_cd_btn) {
        [self setTitleColor:skin.titleColor_cd_btn forState:UIControlStateNormal];
    }
}
@end

//功能符号按键
@implementation GZFunctionButton (GZSetting)
- (void)setButtonStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    if (skin.hightlightImage_btn_f) {
        [self setBackgroundImage:[UIImage imageNamed:skin.hightlightImage_btn_f] forState:UIControlStateHighlighted];
    }
    if (skin.backgroudImage_btn_f) {
        [self setBackgroundImage:[UIImage imageNamed:skin.backgroudImage_btn_f] forState:UIControlStateNormal];
    }
    if (skin.backgroungColor_btn_f) {
        [self setBackgroundColor:skin.backgroungColor_btn_f];
    }
    if (skin.shadowColor_btn_f) {
        self.layer.shadowColor = [skin.shadowColor_btn_f CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }
    if (skin.cornerRadius_btn_f != 0.0) {
        self.layer.cornerRadius = skin.cornerRadius_btn_f;
    }
    if (skin.titleColor_btn_f) {
        [self setTitleColor:skin.titleColor_btn_f forState:UIControlStateNormal];
    }
}
@end

//功能按键 手写键盘左侧
@implementation GZFunctionButton_wright_l (GZSetting)
- (void)setButtonStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    if (skin.hightlightImage_btn_wright_l) {
        [self setBackgroundImage:[UIImage imageNamed:skin.hightlightImage_btn_wright_l] forState:UIControlStateHighlighted];
    }
    if (skin.backgroudImage_btn_wright_l) {
        [self setBackgroundImage:[UIImage imageNamed:skin.backgroudImage_btn_wright_l] forState:UIControlStateNormal];
    }
    if (skin.backgroungColor_btn_wright_l) {
        [self setBackgroundColor:skin.backgroungColor_btn_wright_l];
    }
    if (skin.shadowColor_btn_wright_l) {
        self.layer.shadowColor = [skin.shadowColor_btn_wright_l CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }
    if (skin.cornerRadius_btn_wright_l != 0.0) {
        self.layer.cornerRadius = skin.cornerRadius_btn_wright_l;
    }
    if (skin.titleColor_btn_wright_l) {
        [self setTitleColor:skin.titleColor_btn_wright_l forState:UIControlStateNormal];
    }
}
@end

//功能按键 符号键盘左侧
@implementation GZFunctionButton_symbol_l (GZSetting)
- (void)setButtonStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    if (skin.hightlightImage_btn_symbol_l) {
        [self setBackgroundImage:[UIImage imageNamed:skin.hightlightImage_btn_symbol_l] forState:UIControlStateHighlighted];
    }
    if (skin.backgroudImage_btn_symbol_l) {
        [self setBackgroundImage:[UIImage imageNamed:skin.backgroudImage_btn_symbol_l] forState:UIControlStateNormal];
    }
    if (skin.backgroungColor_btn_symbol_l) {
        [self setBackgroundColor:skin.backgroungColor_btn_symbol_l];
    }
    if (skin.shadowColor_btn_symbol_l) {
        self.layer.shadowColor = [skin.shadowColor_btn_symbol_l CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }
    if (skin.cornerRadius_btn_symbol_l != 0.0) {
        self.layer.cornerRadius = skin.cornerRadius_btn_symbol_l;
    }
    if (skin.titleColor_btn_symbol_l) {
        [self setTitleColor:skin.titleColor_btn_symbol_l forState:UIControlStateNormal];
    }
}
@end

//功能按键 符号键盘底端
@implementation GZFunctionButton_symbol_b (GZSetting)
- (void)setButtonStyleWithSkin:(NSString*)skinName {
    GZKeyboardSkin *skin = [GZKeyboardSkin defaultKeyboardSkin];

    if (skin.hightlightImage_btn_symbol_b) {
        [self setBackgroundImage:[UIImage imageNamed:skin.hightlightImage_btn_symbol_b] forState:UIControlStateHighlighted];
    }
    if (skin.backgroudImage_btn_symbol_b) {
        [self setBackgroundImage:[UIImage imageNamed:skin.backgroudImage_btn_symbol_b] forState:UIControlStateNormal];
    }
    if (skin.backgroungColor_btn_symbol_b) {
        [self setBackgroundColor:skin.backgroungColor_btn_symbol_b];
    }
    if (skin.shadowColor_btn_symbol_b) {
        self.layer.shadowColor = [skin.shadowColor_btn_symbol_b CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 5;
    }
    if (skin.cornerRadius_btn_symbol_b != 0.0) {
        self.layer.cornerRadius = skin.cornerRadius_btn_symbol_b;
    }
    if (skin.titleColor_btn_symbol_b) {
        [self setTitleColor:skin.titleColor_btn_symbol_b forState:UIControlStateNormal];
    }
}
@end

//删除按键
@implementation GZDeleteButton (GZSetting)
- (void)setButtonStyleWithSkin:(NSString*)skinName {
//    [self setBackgroundImage:[UIImage imageNamed:@"key_hightlight"] forState:UIControlStateHighlighted];
}
@end

