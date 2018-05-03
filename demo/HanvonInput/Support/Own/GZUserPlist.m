//
//  GZUserPlist.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/20.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZUserPlist.h"

@interface GZUserPlist()
{
@private
    NSFileManager *fileManager;
    dispatch_queue_t ioQueue;
}
@end

static GZUserPlist *_sharedManager;
static dispatch_once_t onceToken;

@implementation GZUserPlist
+ (GZUserPlist *)sharedUserPlist {
    dispatch_once(&onceToken, ^{
        _sharedManager = [[GZUserPlist alloc] init];
    });
    return _sharedManager;
}
- (id)init{
    self = [super init];
    if (self) {
//        dispatch_queue_t global_queue = dispatch_get_global_queue(0, 0);
        ioQueue = dispatch_queue_create("com.hanvon.symbol", DISPATCH_QUEUE_SERIAL);
        fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (void)releaseUserPlist {
    onceToken = 0;
    _sharedManager = nil;
    fileManager = nil;
    ioQueue = nil;
}



#pragma mark -- 符号键盘存储使用频率
- (void)saveSymbol:(NSString*)symbol withName:(NSString*)name isNeedSort:(BOOL)isNeed {
    NSString *name1 = [NSString stringWithFormat:@"symbol_%@",name];
    NSString *plistPath = [CACHESPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name1]];
    NSMutableArray *originArr = [NSMutableArray arrayWithContentsOfFile:plistPath];

    int amount = 0; //记录循环次数
    for (int i=0; i<originArr.count; i++) {
        NSDictionary *dic = [originArr objectAtIndex:i];
        NSString *dicKey = [dic allKeys].firstObject;
        //原本有这个符号 则增加符号使用频次
        if ([symbol isEqualToString:dicKey]) {
            NSNumber *dicValue = [dic valueForKey:dicKey];
            int num = [dicValue intValue] + 1;
            NSDictionary *new = [NSDictionary dictionaryWithObject:@(num) forKey:dicKey];
            [originArr replaceObjectAtIndex:i withObject:new];
            break;
        }else {
            amount ++;
            continue;
        }
    }
    //符号是新添加的
    if (amount == (int)originArr.count - 1 || originArr.count == 0) {
        NSDictionary *new = [NSDictionary dictionaryWithObject:@1 forKey:name];
        [originArr addObject:new];
    }

    //保存
    if (!isNeed) {
        BOOL isok = [originArr writeToFile:plistPath atomically:YES];
        if (isok) {
            [originArr removeAllObjects];
            originArr = nil;
        }
    }else {
        //NSArray *arr = [originArr copy];
        [self saveSymbols:originArr withName:name];

//        [originArr removeAllObjects];
//        originArr = nil;
    }
}

- (void)saveSymbols:(NSArray*)symbols withName:(NSString*)name {

    NSString *name1 = [NSString stringWithFormat:@"symbol_%@",name];
    NSString *plistPath = [CACHESPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name1]];

    dispatch_async(ioQueue, ^{
        //根据新数组元素键 进行降序排列
        NSArray *result = [symbols sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            NSNumber *new1 = [obj1 allValues].firstObject;
            NSNumber *new2 = [obj2 allValues].firstObject;
            return [new2 compare:new1]; //降序排列的 键
        }];

        //保存
        if (![fileManager fileExistsAtPath:plistPath]) {
            NSLog(@"不存在");
            NSMutableArray *dictplist = [[NSMutableArray alloc] initWithArray:result];
            [dictplist writeToFile:plistPath atomically:YES];
        }else {
            [result writeToFile:plistPath atomically:YES];
            //NSLog(@"%d",isok);
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
            return;
        });
    });
}

- (void)sortDataArrayByName:(NSString*)name {

    NSString *name1 = [NSString stringWithFormat:@"symbol_%@",name];
    NSString *plistPath = [CACHESPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name1]];
    NSArray *symbols = [NSArray arrayWithContentsOfFile:plistPath];

    dispatch_async(ioQueue, ^{
        //根据新数组元素键 进行降序排列
        NSArray *result = [symbols sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            NSNumber *new1 = [obj1 allValues].firstObject;
            NSNumber *new2 = [obj2 allValues].firstObject;
            return [new2 compare:new1]; //降序排列的 键
        }];

        //保存
        if (![fileManager fileExistsAtPath:plistPath]) {
            NSLog(@"不存在");
            NSMutableArray *dictplist = [[NSMutableArray alloc] initWithArray:result];
            [dictplist writeToFile:plistPath atomically:YES];
        }else {
            [result writeToFile:plistPath atomically:YES];
            //NSLog(@"%d",isok);
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
            return;
        });
    });
}

- (NSArray*)getSymbolsByName:(NSString*)name {
    NSString *name1 = [NSString stringWithFormat:@"symbol_%@",name];
    NSString *plistPath = [CACHESPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name1]];

    NSArray *arr = [NSArray arrayWithContentsOfFile:plistPath];

    return arr;
}

- (NSArray*)getSymbolsAllKeysByName:(NSString*)name {
    NSArray *arr = [self getSymbolsByName:name];
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:arr.count];

    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        NSString *key = [dic allKeys].firstObject;
        [result addObject:key];
    }
    return result;
}



#pragma mark -- 常用短语存储
//初始化常用短语plist
- (void)initUserPhases {
    NSURL *containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.com.hanwang.hanvonInput"];
    containerURL = [containerURL URLByAppendingPathComponent:@"UsefulPhrases.plist"];

    NSArray *oringArr = [NSArray arrayWithObjects:@"欢迎使用汉王输入法",@"专注手写，行云流水般的体验",@"常用短语可在这里保存，便于发送。",@"您好，现在不方便，稍后给您回电话", @"我现在有点忙，稍后联系你。", @"我的电话是__,常联系。",nil];
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:oringArr];
    BOOL result = [dataArray writeToURL:containerURL atomically:YES];
    NSLog(@"%d",result);
//    NSString *plistPath = [CACHESPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UsefulPhrases.plist"]];
//    if (![fileManager fileExistsAtPath:plistPath]) {
//        NSLog(@"不存在");
//        dispatch_async(ioQueue, ^{
//            NSArray *oringArr = [NSArray arrayWithObjects:@"欢迎使用汉王输入法",@"专注手写，行云流水般的体验",@"常用短语可在这里保存",@"您好，现在不方便，稍后给您回电话", nil];
//            NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:oringArr];
//            [dataArray writeToFile:plistPath atomically:YES];
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                return;
//            });
//        });
//    }else {
//        return;
//    }
}
//存储短语
- (void)saveUsefulPhrases:(NSString*)phrases {
    NSURL *containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.com.hanwang.hanvonInput"];
    containerURL = [containerURL URLByAppendingPathComponent:@"UsefulPhrases.plist"];

    NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfURL:containerURL];
    [dataArray addObject:phrases];
    BOOL result = [dataArray writeToURL:containerURL atomically:YES];
    NSLog(@"%d",result);

//    NSString *plistPath = [CACHESPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UsefulPhrases.plist"]];
//    if (![fileManager fileExistsAtPath:plistPath]) {
//        NSLog(@"不存在");
//        NSArray *oringArr = [NSArray arrayWithObjects:@"欢迎使用汉王输入法",@"专注手写，行云流水般的体验",@"常用短语可在这里保存",@"您好，现在不方便，稍后给您回电话", nil];
//        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:oringArr];
//        [dataArray addObject:phrases];
//        [dataArray writeToFile:plistPath atomically:YES];
//    }else {
//        NSMutableArray *dataArray = [[NSMutableArray arrayWithContentsOfFile:plistPath] mutableCopy];
//        [dataArray addObject:phrases];
//        [dataArray writeToFile:plistPath atomically:YES];
//    }
}
//替换某一条短语
- (void)replaceUsefullPhrases:(NSString*)phrases atIndex:(int)index {
    NSURL *containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.com.hanwang.hanvonInput"];
    containerURL = [containerURL URLByAppendingPathComponent:@"UsefulPhrases.plist"];

    NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfURL:containerURL] ;
    [dataArray replaceObjectAtIndex:index withObject:phrases];
    BOOL result = [dataArray writeToURL:containerURL atomically:YES];
    NSLog(@"%d",result);
}
//获取短语
- (NSArray*)getAllUsefulPhrases {
    NSURL *containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.com.hanwang.hanvonInput"];
    containerURL = [containerURL URLByAppendingPathComponent:@"UsefulPhrases.plist"];

    NSArray *dataArray = [NSArray arrayWithContentsOfURL:containerURL];
    return dataArray;

//    NSString *plistPath = [CACHESPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UsefulPhrases.plist"]];
//    NSArray *arr = [NSArray arrayWithContentsOfFile:plistPath];
//    return arr;
}
//获取短语 当未初始化时
- (NSArray*)getAllUsefulPhrases_noInnit {
    NSArray *oringArr = [NSArray arrayWithObjects:@"欢迎使用汉王输入法",@"专注手写，行云流水般的体验",@"常用短语可在这里保存，便于发送。",@"您好，现在不方便，稍后给您回电话", @"我现在有点忙，稍后联系你。", @"我的电话是__,常联系。",nil];
    return oringArr;
}
//删除某一短语
- (void)deleteUserPhrases:(NSInteger)index {
    NSURL *containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.com.hanwang.hanvonInput"];
    containerURL = [containerURL URLByAppendingPathComponent:@"UsefulPhrases.plist"];

    dispatch_async(ioQueue, ^{
        NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfURL:containerURL] ;
        [dataArray removeObjectAtIndex:index];
        BOOL result = [dataArray writeToURL:containerURL atomically:YES];
        NSLog(@"%d",result);
    });

//    NSString *plistPath = [CACHESPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UsefulPhrases.plist"]];
//    if (![fileManager fileExistsAtPath:plistPath]) {
//        NSLog(@"不存在");
//        return;
//    }else {
//        dispatch_async(ioQueue, ^{
//            NSMutableArray *dataArray = [[NSMutableArray arrayWithContentsOfFile:plistPath] mutableCopy];
//            [dataArray removeObjectAtIndex:index];
//            [dataArray writeToFile:plistPath atomically:YES];
//        });
//    }
}



#pragma mark -- 用户词典存读
//拷贝工厂目录中的用户词典，并存入沙盒中
- (void)saveUserDictionary:(NSString*)dicName {
    NSString *systemDict = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath], dicName];
    NSString *plistPath = [CACHESPath stringByAppendingPathComponent:dicName];

    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:plistPath]) {
        [manager copyItemAtPath:systemDict toPath:plistPath error:NULL];
//        dispatch_queue_t global_queue = dispatch_get_global_queue(0, 0);
//        dispatch_async(global_queue, ^{
//            [manager copyItemAtPath:systemDict toPath:plistPath error:NULL];
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                NSLog(@"线程存储用户词典成功");
//                return;
//            });
//        });
    }
}
//获取沙盒中的用户词典路径
- (NSString*)getUserDictionaryPath:(NSString*)dicName {
    return [CACHESPath stringByAppendingPathComponent:dicName];
}
//判断沙盒中是否存在用户词典
- (BOOL)isHaveUserDictionary:(NSString*)dicName {
    NSString *plistPath = [CACHESPath stringByAppendingPathComponent:dicName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:plistPath]) {
        return NO;
    }
    return YES;
}




#pragma mark -- 测试字典读写
/*测试字典读写*/
- (BOOL)test_input:(NSString*)dicName withData:(NSString*)dataStr{
    NSString *plistPath = [CACHESPath stringByAppendingPathComponent:dicName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:plistPath]) {
        NSData *result = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        [result writeToFile:plistPath atomically:YES];

        NSData *resultData = [NSData dataWithContentsOfFile:plistPath];
        NSLog(@"%@",resultData);
        return YES;
    }
    return NO;
}
- (BOOL)test_output:(NSString*)dicName {
    NSString *plistPath = [CACHESPath stringByAppendingPathComponent:dicName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:plistPath]) {
        NSData *resultData = [NSData dataWithContentsOfFile:plistPath];
        NSLog(@"%@",resultData);
        return YES;
    }
    return NO;
}
@end
