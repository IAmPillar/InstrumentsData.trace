//
//  GZUserPlist.h
//  HanvonInput
//
//  Created by hanvon on 2017/11/20.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZUserPlist : NSObject
+ (GZUserPlist *)sharedUserPlist;
- (void)releaseUserPlist;

#pragma mark -- 符号键盘存储使用频率
/**直接存储符号到plist表中
 *symbol符号 key表的名
 *isNeed 是否需要进行排序操作
 **/
- (void)saveSymbol:(NSString*)symbol withName:(NSString*)name isNeedSort:(BOOL)isNeed;
/** 存储常用符号
 * symbols数组中每个元素为 健值对 如：@"@"：@18（@符号使用18次）
 ***/
- (void)saveSymbols:(NSArray*)symbols withName:(NSString*)name;
/**重新排序plist表的数据
 *key 某个plist表的名
 * 每个元素为健值对 如：@"@"：@18（@符号使用18次）
 * 1、将数组中的健值对，对换位置，赋值给新的字典 2、获取到所有的频次（value）并存到数组中
 * 3、对频次数组进行降序排列 4、根据排序后的频次数组元素，作为键，获取对应的值，并重新存储到新的数组
 * 5、新数组是最终结果 6、存储到plist
 **/
- (void)sortDataArrayByName:(NSString*)name;
/**获取plist中所以健值对
 *key 某个plist表的名
 ***/
- (NSArray*)getSymbolsByName:(NSString*)name;
/**获取plist中的所有键
 *key 某个plist表的名
 ***/
- (NSArray*)getSymbolsAllKeysByName:(NSString*)name;


#pragma mark -- 常用短语存储
/**
 *初始化常用短语plist
 **/
 - (void)initUserPhases;
/**
 *存储短语
 ***/
- (void)saveUsefulPhrases:(NSString*)phrases;
/**
 *替换某一条短语
 ***/
- (void)replaceUsefullPhrases:(NSString*)phrases atIndex:(int)index;
/**
 *获取所有短语
 ***/
- (NSArray*)getAllUsefulPhrases;
/**
 *获取短语 当未初始化时 键盘首次调用快捷短语
 ***/
- (NSArray*)getAllUsefulPhrases_noInnit;
/**
 *删除某一短语
 ***/
- (void)deleteUserPhrases:(NSInteger)index;


#pragma mark -- 用户词典存读
/**
 *拷贝工厂目录中的用户词典，并存入沙盒中
 ***/
- (void)saveUserDictionary:(NSString*)dicName;
/**
 *获取沙盒中的用户词典路径
 **/
- (NSString*)getUserDictionaryPath:(NSString*)dicName;
/**
 *判断沙盒中是否存在用户词典
 ***/
- (BOOL)isHaveUserDictionary:(NSString*)dicName;



#pragma mark -- 测试字典读写
/*测试字典读写*/
- (BOOL)test_input:(NSString*)dicName withData:(NSString*)dataStr;
- (BOOL)test_output:(NSString*)dicName;



@end
