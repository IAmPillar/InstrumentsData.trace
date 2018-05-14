//
//  Header.h
//  SwaPO1
//
//  Created by pillar on 17/3/3.
//  Copyright © 2017年 SwaPO. All rights reserved.
//

#ifndef Header_h
#define Header_h



/**********系统的路径*****************/
#define SYSTEMPath   NSHomeDirectory() //系统的路径
#define DOCUMENTPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] //沙盒的Document路径
#define CACHESPath   NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] //系统缓存目录
#define TMPPath      NSTemporaryDirectory() //系统的tmp路径



/**********定义屏幕的宽高***************/
//屏幕宽高
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
//适配宽高比例 以iPhone6p为基准
#define ratio_Width(value) value/414.0 //宽比例
#define ratio_Height(value) value/736.0 //高比例
#define coordinate_X(value) SCREEN_WIDTH*ratio_Width(value) //最终x坐标
#define coordinate_Y(value) SCREEN_HEIGHT*ratio_Height(value) //y坐标
//#define State_HEIGHT  ([[UIApplication sharedApplication] statusBarFrame].size.height) //状态栏高
//#define NavBar_HEIGHT self.navigationController.navigationBar.frame.size.height //导航栏高



/**********字体的大小***************/
#define size_font(a) ({CGFloat tmp; if(IS_IPHONE_X){tmp=a;}else if(IS_IPHONE_6P){tmp=a*1.1;}else if(IS_IPHONE_6){tmp=a;}else if(IS_IPHONE_5){tmp=a*0.85;}else{tmp=a*0.7;}tmp;})
#define Font(fontsize) [UIFont fontWithName:@"Montserrat-Regular" size:size_font(fontsize)] //英文默认
#define Font_bold(fontsize) [UIFont fontWithName:@"Montserrat-Bold" size:size_font(fontsize)] //英文粗体
#define Font_pingfang_SC(fontsize) [UIFont fontWithName:@"PingFangSC-Regular" size:size_font(fontsize)] //平方 默认
#define Font_pingfang_SC_Bold(fontsize) [UIFont fontWithName:@"PingFangSC-Semibold" size:size_font(fontsize)] //平方 中粗
#define Font_pingfang_SC_Medium(fontsize) [UIFont fontWithName:@"PingFangSC-Medium" size:size_font(fontsize)] //平方



/**********颜色和透明度设置***************/
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
//#define HexColor(value) [UIColor colorWithHexString:value]
//#define HexColorAlpha(value,al) ([UIColor colorWithHexString:value alpha:al])
#define float_Color_button_function @"#b4bdca" //键盘功能按钮背景色值
#define Color_background_kb   RGBA(210, 213, 219, 1.0) //键盘背景颜色
#define float_Color_button_hightlight  RGBA(75, 143, 252, 1)    //键盘按钮高亮颜色
#define float_Color_button_navigation  RGBA(44, 174, 231, 1)    //app导航按钮颜色


/**********定义手机型号/系统***************/
//设备类型
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) //项目支持iPhone、iPad时判断
#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) //项目支持iPhone、iPad时判断
#define IS_IPAD_ONLYIphone [[[UIDevice currentDevice] model] isEqualToString:@"iPad"] //项目仅支持iphone时，判断是否是ipad
//手机型号
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0) //320*568
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0) //与7、8同尺寸 375*667
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0) //与7p、8p同尺寸 414*736
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
//手机系统
#define iOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]





#endif /* Header_h */
