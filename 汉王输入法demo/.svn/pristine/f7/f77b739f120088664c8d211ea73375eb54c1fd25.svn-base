//
//  GZPublicMethod.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/8.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZPublicMethod.h"

static GZPublicMethod *_sharedManager;
static dispatch_once_t onceToken;

@implementation GZPublicMethod

+ (GZPublicMethod *)sharedPublicMethod{
    dispatch_once(&onceToken, ^{
        _sharedManager = [[GZPublicMethod alloc] init];
    });
    return _sharedManager;
}

- (void)releasePublicMethod {
    onceToken = 0;
    _sharedManager = nil;
}


//计算字符串宽高
- (CGSize)measureSinglelineStringWithString:(NSString*)str andFont:(UIFont*)wordFont{

    if (str == nil)
        return CGSizeMake(0,0);

    CGSize measureSize = [str boundingRectWithSize:CGSizeMake(0, 0)
                                           options:NSStringDrawingUsesFontLeading
                                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, nil]
                                           context:nil].size;

    //    if([[UIDevice currentDevice].systemVersion floatValue] < 7.0){
    //        measureSize = [str sizeWithFont:wordFont constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //    }else{
    //        measureSize = [str boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, nil] context:nil].size;
    //    }
    return measureSize;
}

//计算带有字间距、行间距的字符串尺寸
- (CGSize)getStringSize:(NSString*)str
               withFont:(UIFont*)font
              wordSpace:(NSNumber*)wordSpace //字间距
              lineSpace:(CGFloat)lineSpace { //行间距

    if (str == nil)
        return CGSizeMake(0,0);

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    //paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{
                          NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:wordSpace
                          };

    CGSize size = [str boundingRectWithSize:CGSizeMake(0, 0)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:dic
                                    context:nil].size;
    return size;
}


//计算字符串的宽度
- (float)widthForString:(NSString *)value
                   font:(UIFont *)font
                //color:(UIColor *)color
              andHeight:(float)height{
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{
                                                     //NSForegroundColorAttributeName:color,
                                                     NSFontAttributeName:font
                                                     }
                                           context:nil];

    return sizeToFit.size.width;
}
//计算字符串的高度
- (float)heightForString:(NSString *)value
                    font:(UIFont *)font
                 //color:(UIColor *)color
                andWidth:(float)width{
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{
                                                     //NSForegroundColorAttributeName:color,
                                                     NSFontAttributeName:font
                                                     }
                                           context:nil];

    return sizeToFit.size.height;
}


//获取像素的宽高
- (CGFloat)getPXWithPt:(CGFloat)pt {
    double scale;
    if (IS_IPHONE_6P || IS_IPHONE_X){
        scale = 1/2.0;
    }else if (IS_IPHONE_6){
        scale = 2.0;
    }else{
        scale = 1.0;
    }
    NSLog(@"=======%f",scale);
    return pt * scale;
}


//判断键盘是否开启 允许完全访问 权限
- (BOOL)isAllowFullAccess {
    if (@available(iOS 10.0, *)) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if ([pasteboard hasStrings]) {
            return YES;
        }
        else if ([pasteboard hasURLs]) {
            return YES;
        }
        else if ([pasteboard hasColors]) {
            return YES;
        }
        else if ([pasteboard hasImages]) {
            return YES;
        }
        else // In case the pasteboard is blank
        {
            pasteboard.string = @"";
            if ([pasteboard hasStrings]) {
                return YES;
            }else {
                return NO;
            }
        }
    } else {
        // Fallback on earlier versions
        id pasteboard = [UIPasteboard generalPasteboard];
        if ([pasteboard isKindOfClass:[UIPasteboard class]]) {
            return YES;
        }else {
            return NO;
        }
        //return [UIPasteboard generalPasteboard];
    }
//    if (iOS_Version >= 10.0) {
//
//    }else {
//
//    }
}


//创建导航按钮
- (UIBarButtonItem *)barButtonTitle:(NSString *)title
                              Image:(NSString *)image
                             Target:(id)target
                                Sel:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setFrame:CGRectMake(0, 0, 60, 25)];
    
    if (target != nil) {
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }

    if (title != nil){
        [button setTitleColor:float_Color_button_navigation forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
    }

    if (image != nil){
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *image_new = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:image_new forState:UIControlStateNormal];
    }

    //    [button sizeToFit];
    //    if (button.bounds.size.width < 40) {
    //        CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
    //        button.bounds = CGRectMake(0, 0, width, 40);
    //    }

    //通过UIButton自定义UIBarButtonItem
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
}



@end
