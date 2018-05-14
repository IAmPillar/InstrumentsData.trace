//
//  UIColor+GZColorHex.h
//  SwaPO1
//
//  Created by pillar on 17/3/17.
//  Copyright © 2017年 SwaPO. All rights reserved.
//

#import <UIKit/UIKit.h>

/***十六进制的color转换***/

@interface UIColor (GZColorHex)

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式

+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
