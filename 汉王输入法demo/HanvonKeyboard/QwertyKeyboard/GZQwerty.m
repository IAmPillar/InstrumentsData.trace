//
//  GZQwerty.m
//  HanvonKeyboard
//
//  Created by hanvon on 2017/11/4.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZQwerty.h"
#import "GZChineseKeyboardCore.h"


/* 结果缓存大小 */
#define kBufferSize 1024
#define kUnicharBufferSize (kBufferSize>>1)
#define kUnicharComposingSize 100


@interface GZQwerty() {
    unsigned short imBuffer[kUnicharBufferSize];
    unsigned short composingBuffer[kUnicharComposingSize];
    int dictionaryType; //初始化的字典类型 //0中文 1英文
    unsigned int start; //获取已选音节在转换串的开始位置
    unsigned int end; //获取已选音节在转换串的结束位置
}
@end




@implementation GZQwerty

static GZQwerty *share;
static dispatch_once_t onceToken;

+ (id)defaultQwerty{
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}
- (id)init {
    self = [super init];
    if (self) {
        dictionaryType = -1;
        [self initKeyboardWorkSpace];
    }
    return self;
}

// 初始化工作空间
- (BOOL)initKeyboardWorkSpace {
    NSLog(@"全键盘 初始化工作空间");
    [GZChineseKeyboardCore shareChineseKeyboardCore];
    return YES;
}

//修改词典 -1重新初始化 0中文 1英文
- (void)changeDictionary:(int)type {
    NSLog(@"################# type = %d",type);
    if (type == dictionaryType) {
        return;
    }
    dictionaryType = type;
    if (type == -1) {
        return;
    }

    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    [chineseK changeDictionary:type];

    HWIM_HANDLE *imHandle = [chineseK getHandle];

    if (type == 0) {
        if (0 != HWKIM_SetInputMode(imHandle,HWIM_MODE_PINYIN)) {
            NSLog(@"SetInputMode");
        }
        if (0 != HWKIM_SetKeyboardMode(imHandle, HWIM_KEYBOARD_NOTREDUCE)) { //全键盘
            NSLog(@"SetKeyboardMode");
        }

        GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
        NSNumber *fuzzy = [share getValueForKey:@"fuzzy"];
        if ([fuzzy isEqualToNumber:@1]) {
            if (0 != HWKIM_SetPinyinFuzzy(imHandle, 0xFFF)) {
                NSLog(@"SetPinyinFuzzy");
            }
        }else {
            if (0 != HWKIM_SetPinyinFuzzy(imHandle, 0)) {
                NSLog(@"SetPinyinFuzzy");
            }
        }

    }else if (type == 1){
        if (0 != HWKIM_SetKeyboardMode(imHandle, HWIM_KEYBOARD_NOTREDUCE)) { //全键盘
            NSLog(@"SetKeyboardMode");
        }
    }else {}
}

#pragma mark -- 输入输出操作
//直接输入
- (void)sendInput:(int)inputCode complation:(SuccesInputBlock)data {
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    HWIM_HANDLE *imHandle = [chineseK getHandle];
    dispatch_queue_t queue = dispatch_queue_create("qwerty.input",DISPATCH_QUEUE_SERIAL); //异步线程 串行队列
    dispatch_async(queue, ^{
        unsigned short code = (unsigned short)inputCode;
        int num = HWKIM_AddChar(imHandle, code);
        if (0 != num) {
            NSLog(@"AddChar %d",num);
        }
        NSArray *arr = [self doShowIntermediateResult:-1];
        NSArray *a1 = arr[1];
        NSString *s1 = arr[0];
        data(arr[0],arr[1]);
        arr = nil;
        a1 = nil;
        s1 = nil;
        NSLog(@"arr释放 %@",arr);
    });
}

//点击候选按钮 带联想
- (void)sendSelectedIndex:(int)index andStr:(NSString*)str selectComplation:(SuccesSelectBlock)selectdata predicComplation:(SuccesPredictBlock)predicdata {

    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    HWIM_HANDLE *imHandle = [chineseK getHandle];

    if (0 != HWKIM_ChooseCandWord(imHandle, index)) {
        NSLog(@"ChooseCandWord");
    }
    int isFinish = HWKIM_IsFinish(imHandle); //0否 1是
    if (isFinish == 0) {
        //未结束输入 修改
        [self selectComplation:selectdata];
    }else {
        //结束输入 联想
        [self predicInput:str complation:predicdata];
    }
}

//选择候选 没有联想
- (void)selectIndex:(int)index complation:(SuccesSelectBlock)selectdata {
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    HWIM_HANDLE *imHandle = [chineseK getHandle];

    if (0 != HWKIM_ChooseCandWord(imHandle, index)) {
        NSLog(@"ChooseCandWord");
    }

    int isFinish = HWKIM_IsFinish(imHandle); //0否 1是
    if (isFinish == 0) {
        //未结束输入 修改
        [self selectComplation:selectdata];
    }else {
        //结束输入 联想
        selectdata(nil,nil);
    }

}

//带候选拼音 键盘输入
- (void)sendPinyinCompontInput:(int)inputCode complation:(SuccesPinyinBlock)data {
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    HWIM_HANDLE *imHandle = [chineseK getHandle];
    dispatch_queue_t queue = dispatch_queue_create("qwerty.input",DISPATCH_QUEUE_SERIAL); //异步线程 串行队列
    dispatch_async(queue, ^{
        unsigned short code = (unsigned short)inputCode;
        int num = HWKIM_AddChar(imHandle, code);
        if (0 != num) {
            NSLog(@"AddChar %d",num);
        }
        NSArray *arr = [self doShowIntermediateResult:-1];
        NSString *compontText = arr[0];
        NSArray *candiateArray = arr[1] ;
        NSArray *pinyinCandidates = [self getCompontArr] ;
        data(compontText,candiateArray,pinyinCandidates);
        arr = nil;
        compontText = nil;
        candiateArray = nil;
        pinyinCandidates = nil;
    });
}

//选择某一 拼音候选
- (void)sendSelectedPinyinIndex:(int)index andStr:(NSString*)str complation:(SuccesPinyinBlock)data {
    dispatch_queue_t queue = dispatch_queue_create("qwerty.input",DISPATCH_QUEUE_SERIAL); //异步线程 串行队列
    dispatch_async(queue, ^{
        NSArray *arr = [self doShowIntermediateResult:index];
        NSString *compontText = arr[0] ;
        NSArray *candiateArray = arr[1] ;
        NSArray *pinyinCandidates = [self getCompontArr] ;
        data(compontText,candiateArray,pinyinCandidates);
        arr = nil;
        compontText = nil;
        candiateArray = nil;
        pinyinCandidates = nil;
    });
}

//选择候选index是否结束
- (BOOL)isSelectFinish {
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    HWIM_HANDLE *imHandle = [chineseK getHandle];

    int isFinish = HWKIM_IsFinish(imHandle);
    if (isFinish == 0) {
        return NO;
    }else if (isFinish == 1) {
        return YES;
    }else {
        //错误
        return YES;
    }
}

//候选结束，获取之前的选择 比如“好ren”
- (NSString*)getResultStr {
    // 显示中间结果  拼音
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    HWIM_HANDLE *imHandle = [chineseK getHandle];
    NSString *result = @"";
    int composingLength = HWKIM_GetInputTransResult(imHandle, composingBuffer);
    if (composingLength > 0) {
        for(int i = 0; i < composingLength ;i++){
            int temp = composingBuffer[i];
            NSString *str = [NSString stringWithFormat:@"%C",(unichar)temp];
            result = [result stringByAppendingString:str];
            str = nil;
        }
    }
    return result;
}

//获取拼音候选
- (NSArray*)getCompontArr {
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    HWIM_HANDLE *imHandle = [chineseK getHandle];

    NSInteger numbers = HWKIM_GetPhoneticGroup(imHandle, imBuffer);
    if (numbers <= 0) {
        return nil;
    }

    NSMutableArray *candidates = [NSMutableArray arrayWithCapacity:0];

    int count = 0;
    int start, end;
    for (start = 0; start < kUnicharBufferSize && count < numbers;) {
        for (end = start; end < kUnicharBufferSize && imBuffer[end] != 0; ++end);

        if (end >= kUnicharBufferSize) {
            break;
        }

        NSString *tempStr = @"";
        for(int i = start; i < end ; i++){
            int temp = imBuffer[i];
            NSString *str = [NSString stringWithFormat:@"%C",(unichar)temp];
            tempStr = [tempStr stringByAppendingString:str];
            str = nil;
        }

        //NSString *tempStr = [NSString stringWithCharacters:(imBuffer+start) length:end-start];
        [candidates addObject:tempStr];
        ++count;
        start = end + 1;

        tempStr = nil;
    }

    return candidates;
}

//获取拼音高亮的数据
- (NSInteger)getSelectedCompont {
    return end;
}

//修改模糊音设置
- (void)changeFuzzy {
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    HWIM_HANDLE *imHandle = [chineseK getHandle];

    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    NSNumber *fuzzy = [share getValueForKey:@"fuzzy"];
    if ([fuzzy isEqualToNumber:@1]) {
        if (0 != HWKIM_SetPinyinFuzzy(imHandle, 0xFFF)) {
            NSLog(@"SetPinyinFuzzy");
        }
    }else {
        if (0 != HWKIM_SetPinyinFuzzy(imHandle, 0)) {
            NSLog(@"SetPinyinFuzzy");
        }
    }
}

//修改纠错设置
- (void)changeRecovery {

}

// 重置
- (void)keyboardReset {
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    [chineseK cleanData];
}
//释放单例
- (void)releaseShare {
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    [chineseK cleanData];

    onceToken = 0;
    share = nil;
}
//释放字典
- (void)releaseDictionary {
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    [chineseK releaseDictionary];

    onceToken = 0;
    share = nil;
}
// 释放工作空间
- (void)releaseWorkspace {
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    [chineseK releaseWorkspace];

    onceToken = 0;
    share = nil;
}

#pragma mark -- 核心识别操作
//选择候选
- (void)selectComplation:(SuccesSelectBlock)selectdata {
    dispatch_queue_t global_queue = dispatch_get_global_queue(0, 0); //异步线程 全局并发队列
    dispatch_async(global_queue, ^{
        NSArray *arr = [self doShowIntermediateResult:-1] ;
        NSString *compontText = arr[0] ;
        NSArray *candiateArray = arr[1] ;
        selectdata(compontText,candiateArray);
        arr = nil;
        compontText = nil;
        candiateArray = nil;
    });

    selectdata = nil;
}

//联想输入
- (void)predicInput:(NSString*)text complation:(SuccesPredictBlock)data {
    dispatch_queue_t global_queue = dispatch_get_global_queue(0, 0); //异步线程 全局并发队列
    dispatch_async(global_queue, ^{
        NSArray *result = [self doPrediction:text];
        if (result.count == 0) {
            data(nil);
            result = nil;
            return ;
        }
        data(result);
        result = nil;
    });

    text = nil;
     data = nil;
}

// 显示结果 输入结果最多接收100个（展开更多候选最多100个）
- (NSArray*)doShowIntermediateResult:(NSInteger)phoneIndex {
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    HWIM_HANDLE *imHandle = [chineseK getHandle];

    //候选数量
    NSInteger candidateIndex = HWKIM_GetWordCandidates(imHandle, (int)phoneIndex, imBuffer, kBufferSize);
    if (candidateIndex > 100) {
        candidateIndex = 100;
    }

    //获取已选择的拼音的下划线
    if (0 != HWKIM_GetSelSylPos(imHandle,&(start),&(end))) {
        NSLog(@"GetSelSylPos");
    }else {
        //NSLog(@"start == %d,end == %d",start,end);
    }

    NSMutableArray *candidates = [NSMutableArray arrayWithCapacity:0];
    NSString *_composingText = [NSString stringWithFormat:@""];

    // 显示中间结果  拼音
    int composingLength = HWKIM_GetInputTransResult(imHandle, composingBuffer);
    if (composingLength > 0) {
        for(int i = 0; i < composingLength ;i++){
            int temp = composingBuffer[i];
            NSString *str = [NSString stringWithFormat:@"%C",(unichar)temp];
            _composingText = [_composingText stringByAppendingString:str];
            str = nil;
        }
    }

    // 显示候选
    if (candidateIndex <= 0) {
        if (_composingText.length != 0) {
            NSUInteger length = [_composingText length];
            unichar data[length];
            [_composingText getCharacters:data];
            _composingText = [NSString stringWithCharacters:data length:length];
            [candidates addObject:@""];
        }

        NSArray *resultArr = [NSArray arrayWithObjects:_composingText, candidates ,nil];
        _composingText = nil;
        candidates = nil;
        return resultArr;
    }

    int count = 0;
    int end;
    for (int start = 0; start < kUnicharBufferSize && count < candidateIndex;) {
        for (end = start; end < kUnicharBufferSize && imBuffer[end] != 0; ++end);

        if (end >= kUnicharBufferSize) {
            break;
        }

        //            NSString *tempStr = cvt_ustr(imBuffer + start, end - start);
        NSString *tempStr = @"";
        for(int i = start; i < end; i++){
            int temp = imBuffer[i];
            NSString *str = [NSString stringWithFormat:@"%C",(unichar)temp];
            tempStr = [tempStr stringByAppendingString:str];
            str = nil;
        }
        [candidates addObject:tempStr];
        ++count;
        start = end + 1;
    }

    NSArray *resultArr = [NSArray arrayWithObjects:_composingText, candidates ,nil];
    _composingText = nil;
    candidates = nil;
    return resultArr;
    //    }
}

//联想 联想的结果最多接收30个（候选框最多30个）
- (NSArray*)doPrediction:(NSString*)data {
    GZChineseKeyboardCore *chineseK = [GZChineseKeyboardCore shareChineseKeyboardCore];
    HWIM_HANDLE *imHandle = [chineseK getHandle];

    NSInteger length = [data length];
    unsigned short root[length + 1];
    //    NSRange range;
    //    int result;
    NSMutableArray *predicts = [[NSMutableArray alloc] init];
    BOOL hasPredics = NO; //是否有联想结果了

    for (int i = 0; i < length; ++i) {
        if (hasPredics) {
            break;
        }

        NSRange range;
        range.location = i;
        range.length = length - i;
        [data getCharacters:root range:range];

        root[length - i] = 0;
        int result = HWKIM_GetPredictResult(imHandle, root, NULL, imBuffer, kBufferSize);
        if (result > 30) {
            result = 30;
        }

        if (result < 1) {
            continue;
        }else {
            hasPredics = YES;
        }

        int count = 0;
        int start, end;

        for (start = 0; start < kUnicharBufferSize && count < result;) {
            while (imBuffer[start] == 0) {
                start++;
            }
            for (end = start; end < kUnicharBufferSize && imBuffer[end] != 0; ++end);
            if (end >= kUnicharBufferSize) {
                break;
            }

            NSString *tempStr = @"";
            for(int i = start; i < end; i++){
                int temp = imBuffer[i];
                NSString *str = [NSString stringWithFormat:@"%C",(unichar)temp];
                tempStr = [tempStr stringByAppendingString:str];
                str = nil;
            }
            [predicts addObject:tempStr];
            ++count;
            start = end + 1;
        }
    }

    return predicts;
}




//#pragma mark -- 转换成UTF8并直接返回汉字
//const unsigned char abPrefix[] = {0, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC};
//const unsigned int adwCodeUp[] = {
//    0x80,           // U+00000000 - U+0000007F
//    0x800,          // U+00000080 - U+000007FF
//    0x10000,        // U+00000800 - U+0000FFFF
//    0x200000,       // U+00010000 - U+001FFFFF
//    0x4000000,      // U+00200000 - U+03FFFFFF
//    0x80000000      // U+04000000 - U+7FFFFFFF
//};
//int cvt_char_UCS4_To_UTF8(unsigned short dwUCS4, char* pbUTF8)
//{
//    int i, iLen;
//    iLen = sizeof(adwCodeUp) / sizeof(unsigned int);
//    for( i = 0; i < iLen; i++ )
//    {
//        if( dwUCS4 < adwCodeUp[i] ) break;
//    }
//    if( i == iLen )return 0;//invalid encoding
//    iLen = i + 1;
//    if( pbUTF8 != NULL )
//    {
//        for( ; i > 0; i-- )
//        {
//            pbUTF8[i] = ((dwUCS4 & 0x3F) | 0x80);
//            dwUCS4 >>= 6;
//        }
//        pbUTF8[0] = (unsigned char)(dwUCS4 |= abPrefix[iLen - 1]);
//    }
//    return iLen;
//}
//NSString *cvt_ustr(const unsigned short *wstr, int wlen)
//{
//    char *tmp = (char *)malloc((wlen + 1) * 4);
//    char *cur = tmp;
//    const unsigned short *end = wstr + wlen;
//    while(wstr < end)
//        cur += cvt_char_UCS4_To_UTF8(*wstr++, cur);
//    cur[0] = 0;
//    NSString *ret = [[NSString alloc] initWithUTF8String:tmp];
//    free(tmp);
//    return ret;
//}




@end
