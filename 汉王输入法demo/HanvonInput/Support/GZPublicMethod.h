//
//  GZPublicMethod.h
//  HanvonInput
//
//  Created by hanvon on 2017/11/8.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GZPublicMethod : NSObject

+ (GZPublicMethod *)sharedPublicMethod;
- (void)releasePublicMethod;

#pragma mark -----------
/**单行
 *计算字符串宽高
 */
- (CGSize)measureSinglelineStringWithString:(NSString*)str
                                    andFont:(UIFont*)wordFont;
/**单行
 *计算带有字间距、行间距的字符串尺寸
 **/
- (CGSize)getStringSize:(NSString*)str
               withFont:(float)font
              wordSpace:(float)wordSpace //字间距
              lineSpace:(CGFloat)lineSpace; //行间距

/**多行
 *计算字符串宽
 */
- (float)widthForString:(NSString *)value
                   font:(float)font
                //color:(UIColor *)color
              andHeight:(float)height;

/**多行
 *计算字符串高
 */
- (float)heightForString:(NSString *)value
                    font:(UIFont *)font
                 //color:(UIColor *)color
                andWidth:(float)width;

#pragma mark -----------
/**
 *获取像素的宽高
 ***/
- (CGFloat)getPXWithPt:(CGFloat)pt;


#pragma mark -----------
/**
 *判断键盘是否开启 允许完全访问 权限
 ***/
- (BOOL)isAllowFullAccess;


#pragma mark -----------
//创建导航按钮
- (UIBarButtonItem *)barButtonTitle:(NSString *)title
                              Image:(NSString *)image
                             Target:(id)target
                                Sel:(SEL)selector;
@end
