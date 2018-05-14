//
//  KeyboardViewController.m
//  HanvonKeyboard
//
//  Created by hanvon on 2017/11/4.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "KeyboardViewController.h"
#import "GZCandidateBarView.h"
//#import "GZCandidateMoreView.h"
#import "GZQwertyKeyboard.h"
//#import "GZWrightKeyboard.h"
//#import "GZSquaredKeyboard.h"
//#import "GZStrokeKeyboard.h"
//#import "GZNumberKeyboard.h"
//#import "GZSymbolKeyboard.h"
//#import "GZSettingBoard.h"
//#import "GZKeyboardSelect.h"
//#import "GZExpressionKeyboard.h"
//#import "GZUserPhrasesView.h"

#import "GZQwerty.h"
//#import "GZWright.h"
//#import "GZSquared.h"
//#import "GZStroke.h"

//#import "GZSoundPlay.h"
//#import "GZRequest.h"


#define navigaitonHeight 60 //导航栏的高度
#define navigationButtonBottom 10 //导航上按钮距离底端距离
#define keyboardWidth [self getKeyboardViewWidth] //键盘输入部分宽度
/**
 *KeyboardType 输入框设置的键盘类型
 *ReturnType 输入框设置的return键类型
 ***/
typedef NS_ENUM(NSInteger, KeyboardType) {
    Default = 0, //正常
    NumbersAndPunctuation, //数字
    URL, //地址
    EmailAddress, //邮箱
    WebSearch, //浏览器地址
    ASCLLCapable //英文 正常
};
typedef NS_ENUM(NSInteger, ReturnType) {
    DefaultReturn = 0,
    SendReturn, //发送
};


@interface KeyboardViewController () {
    //    clock_t clt0;
    //    clock_t clt1;
}
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint; //键盘整体高度约束
@property (nonatomic, assign) KeyboardType keyboard_type_last; //上一次 输入框设置的键盘类型
@property (nonatomic, assign) KeyboardType keyboard_type; //输入框设置的键盘类型
@property (nonatomic, assign) ReturnType return_type; //输入框设置的return键类型
@property (nonatomic, assign) BOOL isQuitOutApp; //是否点击了隐藏键盘
@property (nonatomic, assign) BOOL isInput; //全键盘 是否是正在输入中
@property (nonatomic, assign) BOOL canChange; //全键盘 是否小地球可以改变

//@property (nonatomic, assign) BOOL isWrightTimeout; //手写 间隔时间超时
////@property (nonatomic,strong) NSString *wrightFirst; //手写 超时时 第一个候选
//@property (nonatomic, assign) BOOL isWrightPreciate; //手写 是否联想状态
//@property (nonatomic, assign) int wrightNum; //手写中 上屏文字的个数

@property (nonatomic, strong) GZCandidateBarView *tabBar; //候选框
//@property (nonatomic, strong) GZCandidateMoreView *tabBarMore; //候选框 展示更多
@property (nonatomic, strong) GZQwertyKeyboard *textKeyboard; //全键盘
//@property (nonatomic, strong) GZWrightKeyboard *wrightKeyboard; //手写键盘
//@property (nonatomic, strong) GZSquaredKeyboard *squaredKeyboard; //九宫格键盘
//@property (nonatomic, strong) GZStrokeKeyboard *strokeKeyboard; //笔画键盘
//@property (nonatomic, strong) GZNumberKeyboard *numberKeyboard; //数字键盘
//@property (nonatomic, strong) GZSymbolKeyboard *symbolKeyboard; //符号键盘
//@property (nonatomic, strong) GZSettingBoard *settingBoard; //设置
//@property (nonatomic, strong) GZKeyboardSelect *selectBoard; //选择键盘
//@property (nonatomic, strong) GZExpressionKeyboard *expressionBoard; //表情键盘
//@property (nonatomic, strong) GZUserPhrasesView *userPhrasesBoard; //快捷短语
@end



@implementation KeyboardViewController

#pragma mark -- memorry waring
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"******* ******* ******* ******* ");
    NSLog(@"Warning!!!!!!didReceiveMemoryWarning!!!!!!");
    [[GZUserPlist sharedUserPlist] releaseUserPlist];
    [[GZPublicMethod sharedPublicMethod] releasePublicMethod];
}

#pragma mark -- life cycle
/**
 *Host App在调用Extension的时候会首先调用
 *如果实现了的话，会先执行里面的函数再viewDidLoad
 */
- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
    [super beginRequestWithExtensionContext:context];
    NSLog(@"开始启动Extension");
    _isQuitOutApp = NO;
    //存储字典到沙盒
    [self saveDictioryToDoc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"启动viewDidload");
    //夜间模式 0日间模式 1夜间模式
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    NSNumber *nightMode = [share getValueForKey:@"nightMode"];
    if ([nightMode isEqualToNumber:@1]) {
        self.view.backgroundColor = [UIColor blackColor];
        self.view.alpha = 0.5;
    }else {
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.alpha = 1;
    }
    //添加导航
    [self addNavigationBarView];
    //识别并添加键盘
    [self recognizeAndAddKeyboard];
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    NSLog(@"updateViewConstraints");
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews");
}
- (void)textWillChange:(id<UITextInput>)textInput {
    NSLog(@"textWillChange");
    if (_isQuitOutApp) {
        return;
    }
    [self setNavigationStatus];
}
- (void)textDidChange:(id<UITextInput>)textInput {
    NSLog(@"textDidChange");

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    //约束键盘高度
    CGFloat height = [self getKeyboardViewHeight];
    [self setKeyboardViewHeight:height+navigaitonHeight]; //整体高度=键盘+导航的高度
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    [self resetCoreData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
    [self removeAllSelfViews];
    [self resetCoreData];
}
- (void)dealloc {
    NSLog(@"main主页面 调起dealloc");
    [[GZUserPlist sharedUserPlist] releaseUserPlist];
    [[GZPublicMethod sharedPublicMethod] releasePublicMethod];
}


#pragma mark -- 数据
//存储字典到沙盒
- (void)saveDictioryToDoc {
    NSLog(@"keyboard存储字典到沙盒");

    NSFileManager *manager = [NSFileManager defaultManager];
    GZUserPlist *plist = [GZUserPlist sharedUserPlist];

    //中文全键盘、中文九键盘、中文笔画键盘
    NSString *userDict_chinese = [plist getUserDictionaryPath:@"ml-user.dic"];
    if (![manager fileExistsAtPath:userDict_chinese]) {
        NSLog(@"开启线程1——中文用户词典");
        dispatch_queue_t global_queue = dispatch_get_global_queue(0, 0);
        dispatch_async(global_queue, ^{
            [plist saveUserDictionary:@"ml-user.dic"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"线程1——中文用户词典成功");
                return;
            });
        });
    }else {
        NSLog(@"saved中文用户词典");
    }

    //英文
    NSString *userDict_english = [plist getUserDictionaryPath:@"en-user.dic"];
    if (![manager fileExistsAtPath:userDict_english]) {
        NSLog(@"开启线程2——英文用户词典");
        dispatch_queue_t global_queue = dispatch_get_global_queue(0, 0);
        dispatch_async(global_queue, ^{
            [plist saveUserDictionary:@"en-user.dic"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"线程2——英文用户词典成功");
                return;
            });
        });
    }else {
        NSLog(@"saved英文用户词典");
    }
}


//识别并添加键盘
- (void)recognizeAndAddKeyboard {
    //键盘类型
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    [share saveValue:@"qwerty_pinyin" forKey:@"keyboardType"];
    [share saveValue:@"qwerty_pinyin" forKey:@"lastKeyboard"];
    [self addKeyboardView:1];
}


#pragma mark -- PrepareUI
//导航
- (void)addNavigationBarView {
    GZKeyboardNavigationView *navigationBarView = [[GZKeyboardNavigationView alloc] init];
    navigationBarView.backgroundColor = [UIColor whiteColor];

    navigationBarView.layer.borderWidth = 0.5;
    navigationBarView.layer.borderColor = [Color_background_kb CGColor];
    navigationBarView.tag = 101;
    [self.view addSubview:navigationBarView];

    navigationBarView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top =
    [NSLayoutConstraint constraintWithItem: navigationBarView
                                 attribute: NSLayoutAttributeTop
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: self.view
                                 attribute: NSLayoutAttributeTop
                                multiplier: 1.0
                                  constant: 0.0];
    NSLayoutConstraint *left =
    [NSLayoutConstraint constraintWithItem: navigationBarView
                                 attribute: NSLayoutAttributeLeft
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: self.view
                                 attribute: NSLayoutAttributeLeft
                                multiplier: 1.0
                                  constant: 0.0];
    //导航高度固定
    NSLayoutConstraint *height =
    [NSLayoutConstraint constraintWithItem: navigationBarView
                                 attribute: NSLayoutAttributeHeight
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: nil
                                 attribute: NSLayoutAttributeNotAnAttribute
                                multiplier: 1.0
                                  constant: navigaitonHeight];
    NSLayoutConstraint *width =
    [NSLayoutConstraint constraintWithItem: navigationBarView
                                 attribute: NSLayoutAttributeWidth
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: self.view
                                 attribute: NSLayoutAttributeWidth
                                multiplier: 1.0
                                  constant: 0.0];
    [self.view addConstraints:@[top,left,height,width]];

    //按钮
    CGFloat buttonW = 25; //按钮的宽高
    CGFloat space = (keyboardWidth - buttonW*5)/5.4; //左右边距相当于0.7个
    CGFloat y = navigaitonHeight-buttonW-navigationButtonBottom;

    NSArray *images = [NSArray arrayWithObjects:@"navigation_logo",@"navigation_qwerty",@"navigation_writing",@"navigation_expression",@"navigation_hidden", nil];
    NSArray *images_select = [NSArray arrayWithObjects:@"navigation_logo-select",@"navigation_qwerty-select",@"navigation_writing-select",@"navigation_expression-select",@"navigation_hidden", nil];
    for (int i=0; i<5; i++) {
        GZFunctionButton *button = [GZFunctionButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(space*0.7 + i*(buttonW+space), y, buttonW, buttonW); //导航高度固定
        button.tag = 102+i;
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images_select[i]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(didNavigationButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [navigationBarView addSubview:button];
    }
}

//键盘  1全键盘拼音 2全键盘英文 3手写键盘 4九宫格 5笔画
- (void)addKeyboardView:(int)type {
    if (type == 1 || type == 2) {
        //导航的选择状态
        [self setNavigationSelectedIndex:2];

        if (_textKeyboard) {
            NSLog(@"已经有全键盘了，直接退出创建");
            return;
        }

        [self addQwertyKeyboardView:type];

        GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
        [share saveValue:@"qwerty_pinyin" forKey:@"lastKeyboard"];
    }
}

#pragma mark -- FormalUI
//候选框
//高度 与导航等高
- (void)addCandidateBarView {
    if (!_tabBar) {
        _tabBar = [[GZCandidateBarView alloc] initWithFrame:CGRectMake(0, 0, keyboardWidth, navigaitonHeight)];
        _tabBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tabBar];
    }

    __weak KeyboardViewController *weakSelf = self;
    _tabBar.sendSelectedStr = ^(NSString *text, int selectIndex) {
        if (weakSelf.textKeyboard) {
            [weakSelf.textKeyboard changeKeyboardStatusToInput:NO];
            [weakSelf changeGlobleToInput:NO];
        }
        if (text.length == 0) {
            [weakSelf removeAllCadidateContent];
            return ;
        }
        [weakSelf clickTabbarIndex:selectIndex byText:text]; //联想
    };

    _tabBar.sendRemoveTabbar = ^(BOOL remove) {
        if (remove) {
            [weakSelf.tabBar removeFromSuperview];
            weakSelf.tabBar = nil;
        }
    };

    //展示更多候选
    _tabBar.sendShowMoreFunc = ^(BOOL isShowMore, NSArray *data) {
        //有没有候选
        if (isShowMore && data.count > 5) {

        }else if (!isShowMore && !data) {
            if (weakSelf.textKeyboard) {
                [weakSelf.textKeyboard changeKeyboardStatusToInput:NO];
                [weakSelf changeGlobleToInput:NO];
            }
        }
    };
}


//全键盘
- (void)addQwertyKeyboardView:(int)type {
    //1中文 2英文
    if (type == 2) {
        _canChange = NO;
    }else {
        _canChange = YES;
    }

    __weak GZUserDefaults *share = [GZUserDefaults shareUserDefaults];

    NSString *keyboardStr = [share getValueForKey:@"keyboardType"];
    if (![keyboardStr isEqualToString:@"qwerty_english"] && ![keyboardStr isEqualToString:@"qwerty_pinyin"]) {
        return;
    }

    CGFloat height = [self getKeyboardViewHeight];

    if (!_textKeyboard) {
        _textKeyboard = [[GZQwertyKeyboard alloc] initWithFrame:CGRectMake(0, navigaitonHeight, keyboardWidth, height) andKeyboardType:type];
        _textKeyboard.backgroundColor = Color_background_kb;
        [self.view addSubview:_textKeyboard];

        if (!IS_IPHONE_X) {
            [self changeTheGlobeFrameUnderKeyboard:2 withScreenDirection:height]; //小地球
        }
    }

    __weak KeyboardViewController *weakSelf = self;
    __weak GZQwerty *getdata = [GZQwerty defaultQwerty]; //初始化全键盘 只初始化空间
    //初始化中英模式、模糊音等
    if (type == 2) {
        NSLog(@"初始化英文模式");
        [getdata changeDictionary:1];
    }else {
        NSLog(@"初始化中文模式");
        [getdata changeDictionary:0];
    }
    //文本按键
    _textKeyboard.sendSelectedStr = ^(NSString *text) {
        if ([text isEqualToString:@"'"] && ![weakSelf.tabBar isTabBarHasData]) {
            //没有输入内容 只点击分隔符
            text = nil;
            return;
        }
        if (!weakSelf.tabBar) {
            [weakSelf addCandidateBarView];
        }

        [weakSelf.textKeyboard changeKeyboardStatusToInput:YES];
        [weakSelf changeGlobleToInput:YES];

        int asciiCode;
        if ([[share getValueForKey:@"keyboardType"] isEqualToString:@"qwerty_english"]) {
            asciiCode = [text characterAtIndex:0];
        }else {
            if ([text isEqualToString:@"'"]) {
                asciiCode = [text characterAtIndex:0];
            }else {
                asciiCode = [text characterAtIndex:0] + 32; //a97 A65
            }
        }
        text = nil;

        //候选结果
        [getdata sendInput:asciiCode complation:^(NSString *compontText, NSArray *candiateArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (candiateArray.count != 0) {
                    [weakSelf.tabBar changeShowText:candiateArray];
                }
                if (compontText.length != 0) {
                    [weakSelf.tabBar changeShowPinyin:compontText andRange:NSMakeRange(0, 0)];
                }
                //1添加删除 0移除删除并移除tabbar
                [weakSelf changeTabbarShowMoreButton];
            });
            compontText = nil;
            candiateArray = nil;
        }];
    };

    //功能按钮  删除按钮
    _textKeyboard.sendDeleteTap = ^(BOOL isDelete) {
        if (isDelete) {
            if (weakSelf.tabBar && [weakSelf.tabBar isTabBarHasData]) {
                [getdata sendInput:0x08 complation:^(NSString *compontText, NSArray *candiateArray) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (candiateArray.count != 0) {
                            [weakSelf.tabBar changeShowText:candiateArray];
                        }
                        if (compontText.length != 0) {
                            NSString *keyboardtypeStr = [share getValueForKey:@"keyboardType"];
                            if ([keyboardtypeStr isEqualToString:@"qwerty_pinyin"]) { //qwerty_english
                                NSInteger end = [[GZQwerty defaultQwerty] getSelectedCompont];
                                [weakSelf.tabBar changeShowPinyin:compontText andRange:NSMakeRange(0, end)];
                            }else {
                                [weakSelf.tabBar changeShowPinyin:compontText andRange:NSMakeRange(0, 0)];
                            }

                        }
                        if (compontText.length == 0 || candiateArray.count == 0) {
                            [getdata keyboardReset];
                            [weakSelf removeAllCadidateContent];
                            [weakSelf.textKeyboard changeKeyboardStatusToInput:NO];
                            [weakSelf changeGlobleToInput:NO];
                        }
                    });
                }];

            }else {
                [weakSelf.textDocumentProxy deleteBackward];
                [weakSelf.textKeyboard changeKeyboardStatusToInput:NO];
                [weakSelf changeGlobleToInput:NO];
            }
        }else {
            [weakSelf.textKeyboard stopTimer];
        }
        return ;
    };

    //功能按键
    _textKeyboard.sendSelectedFunc = ^(int funcType) {
        if (funcType > 0 && funcType) {
            //1分隔 2删除 3符号 4下一个输入法 5数字  6空格 7中英切换 8回车 10逗号 11点号
            switch (funcType) {
                case 1:{
                    NSLog(@"分隔符");
                    //分隔符不作处理 特殊情况 直接在文本中
                    break;
                }
                case 2:{
                    NSLog(@"删除");
                    //删除按钮的调用属于特殊 有长按操作 不在这个方法中返回
                    break;
                }
                case 3:{
                    NSLog(@"符号");

                    break;
                }
                case 4:{
                    NSLog(@"下一个输入法");
                    BOOL isHavePinyin = [weakSelf.tabBar isTabBarHasPinyin];
                    if (isHavePinyin) {
                        NSString *candidateStr = [weakSelf.tabBar getFirstCandidate];
                        [weakSelf.textDocumentProxy insertText:candidateStr];
                    }
                    [weakSelf removeAllCoreWorkplace];
                    [weakSelf advanceToNextInputMode];
                    break;
                }
                case 5:{
                    NSLog(@"数字");

                    break;
                }
                case 6:{
                    NSLog(@"空格");
                    NSString *inserStr;
                    BOOL isHavePinyin = [weakSelf.tabBar isTabBarHasPinyin];
                    if (isHavePinyin) {
                        NSString *candidateStr = [weakSelf.tabBar getFirstCandidate];
                        if (candidateStr.length != 0 && candidateStr != nil) {
                            [weakSelf clickTabbarIndex:0 byText:candidateStr];
                            [weakSelf.textKeyboard changeKeyboardStatusToInput:NO];
                            [weakSelf changeGlobleToInput:NO];
                            return ;
                        }else {
                            inserStr = [NSString stringWithFormat:@" "];
                        }
                    }else {
                        inserStr = [NSString stringWithFormat:@" "];
                    }
                    [weakSelf.textDocumentProxy insertText:inserStr];

                    [weakSelf.textKeyboard changeKeyboardStatusToInput:NO];
                    [weakSelf changeGlobleToInput:NO];

                    [weakSelf removeAllCadidateContent];
                    [getdata keyboardReset];
                    break;
                }
                case 7:{
                    NSLog(@"中英切换");
                    [getdata keyboardReset];

                    NSString *keyboardtypeStr = [share getValueForKey:@"keyboardType"];
                    [weakSelf setNavigationSelectedIndex:2];
                    if ([keyboardtypeStr isEqualToString:@"qwerty_pinyin"]) {
                        //上次是中文
                        [weakSelf.textKeyboard changeKeyboardType:2];
                        [share saveValue:@"qwerty_english" forKey:@"keyboardType"];
                        [getdata changeDictionary:1];
                        _canChange = NO;
                    }else {
                        //上次是英文
                        [weakSelf.textKeyboard changeKeyboardType:1];
                        [share saveValue:@"qwerty_pinyin" forKey:@"keyboardType"];
                        [getdata changeDictionary:0];
                        _canChange = YES;
                    }
                    if (weakSelf.tabBar) {
                        [weakSelf.tabBar removeFromSuperview];
                        weakSelf.tabBar = nil;
                    }
                    break;
                }
                case 8:{
                    NSLog(@"回车");
                    NSString *compontText = [weakSelf.tabBar getPinyin];
                    if (compontText.length != 0 && compontText != nil) {
                        [weakSelf.textDocumentProxy insertText:compontText];
                    }else {
                        [weakSelf.textDocumentProxy insertText:@"\n"];
                    }

                    [weakSelf.textKeyboard changeKeyboardStatusToInput:NO];
                    [weakSelf changeGlobleToInput:NO];

                    [weakSelf removeAllCadidateContent];
                    [getdata keyboardReset];
                    break;
                }
                case 10: {
                    NSString *candidateStr = [weakSelf.tabBar getFirstCandidate];
                    NSString *inserStr;
                    if (candidateStr.length != 0 && candidateStr) {
                        inserStr = [NSString stringWithFormat:@"%@，",candidateStr];
                    }else {
                        inserStr = @"，";
                    }
                    [weakSelf.textDocumentProxy insertText:inserStr];
                    [weakSelf removeAllCadidateContent];
                    [getdata keyboardReset];
                    [weakSelf.textKeyboard changeKeyboardStatusToInput:NO];
                    [weakSelf changeGlobleToInput:NO];
                    candidateStr = nil;
                    inserStr = nil;
                    break;
                }
                case 11: {
                    NSString *candidateStr = [weakSelf.tabBar getPinyin];
                    NSString *inserStr;
                    if (candidateStr.length != 0 && candidateStr) {
                        inserStr = [NSString stringWithFormat:@"%@.",candidateStr];
                    }else {
                        inserStr = @".";
                    }
                    [weakSelf.textDocumentProxy insertText:inserStr];
                    [weakSelf removeAllCadidateContent];
                    [getdata keyboardReset];
                    [weakSelf.textKeyboard changeKeyboardStatusToInput:NO];
                    [weakSelf changeGlobleToInput:NO];
                    candidateStr = nil;
                    inserStr = nil;
                    break;
                }
                default:
                    break;
            }
        }
        return;
    };
}



#pragma mark -- 地球按钮
//改变地球的坐标
- (void)changeTheGlobeFrameUnderKeyboard:(int)keyboardType withScreenDirection:(CGFloat)direction {
    //direction  150横屏  210竖屏
    //keyboardType 1手写 2全键 3九键 4笔画
    if (direction == 210.0 || direction == 260.0) {
        [self addTheGlobe_bByKeyboard:keyboardType];
    }else {
        if (keyboardType == 1) {
            [self addTheGlobe_lByKeyboard:keyboardType];
        }else {
            [self addTheGlobe_bByKeyboard:keyboardType];
        }
    }
}
//添加地球
- (void)addTheGlobe_bByKeyboard:(int)type {
    //键盘布局 水平间距5 垂直间距7
    //键盘布局 顶部间距3 底部间距3
    CGFloat spaceX = 5.0;
    CGFloat spaceY = 7.0;
    CGFloat top = 3.0;
    CGFloat bottom = 3.0;

    CGFloat height = [self getKeyboardViewHeight];
    CGFloat buttonH = (height - top - bottom - spaceY*3)/4.0; //按钮高度
    CGFloat buttonW = (keyboardWidth - 7*spaceX)/(4+2*1.5); //按钮宽度
    CGFloat buttonY = navigaitonHeight + height - bottom - buttonH; //按钮y

    GZFunctionButton *button = (GZFunctionButton*)[self.view viewWithTag:666];
    if (!button) {
        GZFunctionButton *button = [GZFunctionButton buttonWithType:UIButtonTypeCustom];
        //[button setBackgroundImage:[UIImage imageNamed:@"key_hightlight"] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor colorWithHexString:float_Color_button_function alpha:1]];
        button.layer.cornerRadius = 5;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [button addTarget:self action:@selector(handleInputModeListFromView:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
        button.frame = CGRectMake(spaceX + 1*(spaceX+buttonW), buttonY, buttonW, buttonH);
        [button setImage:[UIImage imageNamed:@"keyboard_esrth"] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button.tag = 666;
    }else {
        button.frame = CGRectMake(spaceX + 1*(spaceX+buttonW), buttonY, buttonW, buttonH);
    }

    [self.view bringSubviewToFront:button];
}
- (void)addTheGlobe_lByKeyboard:(int)type {
    //键盘布局 水平间距5 垂直间距7
    //键盘布局 顶部间距3 底部间距3
    CGFloat spaceX = 5.0;
    CGFloat spaceY = 7.0;
    CGFloat top = 3.0;
    CGFloat bottom = 3.0;

    CGFloat height = [self getKeyboardViewHeight];
    CGFloat buttonH = (height - top - bottom - spaceY*3)/4.0; //按钮的高度
    CGFloat buttonW = (keyboardWidth - 7*spaceX)/(4+2*1.5); //功能按钮宽度
    CGFloat buttonY = navigaitonHeight + height - bottom - buttonH; //按钮y top + 3*(buttonH+spaceY)

    GZFunctionButton *button = (GZFunctionButton*)[self.view viewWithTag:666];
    if (!button) {
        GZFunctionButton *button = [GZFunctionButton buttonWithType:UIButtonTypeCustom];
        //[button setBackgroundImage:[UIImage imageNamed:@"key_hightlight"] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor colorWithHexString:float_Color_button_function alpha:1]];
        button.layer.cornerRadius = 5;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [button addTarget:self action:@selector(handleInputModeListFromView:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
        button.frame = CGRectMake(spaceX, buttonY, buttonW, buttonH);
        [button setImage:[UIImage imageNamed:@"keyboard_esrth"] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button.tag = 666;
    }else {
        button.frame = CGRectMake(spaceX, buttonY, buttonW, buttonH);
    }

    [self.view bringSubviewToFront:button];
}

//全键盘时 改变地球的按钮功能
- (void)changeGlobleToInput:(BOOL)changeToInput {
    if (!_canChange) {
        return;
    }
    _isInput = changeToInput;
    UIButton *ju = (UIButton*)[self.view viewWithTag:777];
    if (changeToInput) {
        GZFunctionButton *button = (GZFunctionButton*)[self.view viewWithTag:666];
        CGSize size = button.frame.size;
        if (!ju) {
            ju = [UIButton buttonWithType:UIButtonTypeCustom];
            ju.frame = CGRectMake(0, 0, size.width, size.height);
            ju.layer.cornerRadius = button.layer.cornerRadius;
            ju.backgroundColor = [UIColor whiteColor];
            [ju setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            ju.titleLabel.font = [UIFont systemFontOfSize:18];
            ju.titleLabel.textAlignment = NSTextAlignmentCenter;
            [ju setTitle:@"。" forState:UIControlStateNormal];
            [ju addTarget:self action:@selector(clickJuButton:) forControlEvents:UIControlEventTouchUpInside];
            ju.tag = 777;
            [button addSubview:ju];
            NSLog(@"添加句号");
        }else {
            NSLog(@"修改句号");
            ju.frame = CGRectMake(0, 0, size.width, size.height);
        }
    }else {
        if (ju) {
            NSLog(@"移除句号");
            [ju removeFromSuperview];
        }
    }
}
- (void)clickJuButton:(UIButton*)sender {
    NSString *candidateStr = [self.tabBar getFirstCandidate];
    NSString *inserStr;
    if (candidateStr.length != 0 && candidateStr) {
        inserStr = [NSString stringWithFormat:@"%@。",candidateStr];
    }else {
        inserStr = @"。";
    }
    [self.textDocumentProxy insertText:inserStr];

    [self.textKeyboard changeKeyboardStatusToInput:NO];
    [self changeGlobleToInput:NO];

    [self removeAllCadidateContent];
    [[GZQwerty defaultQwerty] keyboardReset];
}

#pragma mark -- 键盘核心相关
//点击候选按钮的操作
- (void)clickTabbarIndex:(int)selectIndex byText:(NSString*)text {
    NSString *keyboardtypeStr = [[GZUserDefaults shareUserDefaults] getValueForKey:@"keyboardType"];
    if ([keyboardtypeStr isEqualToString:@"qwerty_english"]) {
        //全键盘 英文
        [self selectIndex:selectIndex predicOperation:text keyboardType:1];
    }
    else if ([keyboardtypeStr isEqualToString:@"qwerty_pinyin"]) {
        //全键盘 拼音
        [self selectIndex:selectIndex predicOperation:text keyboardType:1];
    }
}
//type = 1全键盘  2九宫格  3笔画  4手写
- (void)selectIndex:(int)index predicOperation:(NSString*)text keyboardType:(int)type{
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    __weak GZQwerty *getdata = [GZQwerty defaultQwerty];
    __weak KeyboardViewController *weakSelf = self;

    //没有中文联想
    NSNumber *lianxiang = [share getValueForKey:@"chineseAssociation"];
    if ([lianxiang isEqualToNumber:@0]) {
        //全键盘 笔画键盘
        [getdata selectIndex:index complation:^(NSString *compontText, NSArray *candiateArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (compontText == nil && candiateArray == nil) {
                    //输入结束 直接输入到文本框
                    //英文时 加空格
                    NSString *result;
                    NSString *keyboardtypeStr = [share getValueForKey:@"keyboardType"];
                    if ([keyboardtypeStr isEqualToString:@"qwerty_english"]) {
                        if (weakSelf.keyboard_type == URL || weakSelf.keyboard_type == EmailAddress || weakSelf.keyboard_type == WebSearch) {
                            //不作为单词使用 不添加空格
                            result = [NSString stringWithFormat:@"%@",text];
                        }else {
                            result = [NSString stringWithFormat:@"%@ ",text];
                        }
                    }else {
                        result = [getdata getResultStr];
                    }
                    [weakSelf.textDocumentProxy insertText:result];
                    [weakSelf removeAllCadidateContent];
                    [getdata keyboardReset];
                }else {
                    //输入未结束 修改候选的拼音、候选
                    if (compontText.length != 0) {
                        if (type == 1) {
                            NSInteger end = [[GZQwerty defaultQwerty] getSelectedCompont];
                            [weakSelf.tabBar changeShowPinyin:compontText andRange:NSMakeRange(0, end)];
                        }else {
                            [weakSelf.tabBar changeShowPinyin:compontText andRange:NSMakeRange(0, 0)];
                        }
                    }
                    if (candiateArray.count != 0) {
                        [weakSelf.tabBar changeShowText:candiateArray];
                    }
                    if (compontText.length == 0 && candiateArray.count == 0) {
                        //英文时 加空格
                        NSString *result;
                        NSString *keyboardtypeStr = [share getValueForKey:@"keyboardType"];
                        if ([keyboardtypeStr isEqualToString:@"qwerty_english"]) {
                            if (weakSelf.keyboard_type == URL || weakSelf.keyboard_type == EmailAddress || weakSelf.keyboard_type == WebSearch) {
                                //不作为单词使用 不添加空格
                                result = [NSString stringWithFormat:@"%@",text];
                            }else {
                                result = [NSString stringWithFormat:@"%@ ",text];
                            }
                        }else {
                            result = [getdata getResultStr];
                        }
                        [weakSelf.textDocumentProxy insertText:result];
                        [weakSelf removeAllCadidateContent];
                    }
                }
            });
        }];
        return;
    }


    //有中文联想
    BOOL pre = [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
    if (pre) { //是否空串
        [getdata keyboardReset];
        [self removeAllCadidateContent];
        return ;
    }

    self.view.userInteractionEnabled = NO;
    [getdata sendSelectedIndex:index andStr:text selectComplation:^(NSString *compontText, NSArray *candiateArray) {
        //输入未完成 点击修改候选拼音
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;

            if (compontText != nil) {
                if (type == 1) {
                    NSInteger end = [[GZQwerty defaultQwerty] getSelectedCompont];
                    [weakSelf.tabBar changeShowPinyin:compontText andRange:NSMakeRange(0, end)];
                }else {
                    [weakSelf.tabBar changeShowPinyin:compontText andRange:NSMakeRange(0, 0)];
                }
            }
            if (candiateArray != nil) {
                [weakSelf.tabBar changeShowText:candiateArray];
            }
        });
    } predicComplation:^(NSArray *candiateArray) {
        //输入完成 点击 联想输入
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;

            //英文时 加空格
            NSString *result;
            NSString *keyboardtypeStr = [share getValueForKey:@"keyboardType"];
            if ([keyboardtypeStr isEqualToString:@"qwerty_english"]) {
                //英文状态下，判断是否加空格
                if (weakSelf.keyboard_type == URL || weakSelf.keyboard_type == EmailAddress || weakSelf.keyboard_type == WebSearch) {
                    //不作为单词使用 不添加空格
                    result = [NSString stringWithFormat:@"%@",text];
                }else {
                    if ([weakSelf.tabBar isTabBarHasPinyin]) {
                        //直接输入 不加空格
                        result = [NSString stringWithFormat:@"%@",text];
                    }else {
                        //联想 加空格
                        result = [NSString stringWithFormat:@" %@",text];
                    }
                }
            }else {
                result = [getdata getResultStr];
            }
            [weakSelf.textDocumentProxy insertText:result];

            if (candiateArray == nil) {
                [weakSelf removeAllCadidateContent];
            }else {
                [weakSelf.tabBar changeShowPinyin:nil andRange:NSMakeRange(0, 0)]; //候选时，移除拼音view

                //1添加删除 0移除删除并移除tabbar
                [weakSelf changeTabbarShowMoreButton];

                if (candiateArray.count != 0 && candiateArray) {
                    [weakSelf.tabBar changeShowText:candiateArray];
                }else{
                    [weakSelf removeAllCadidateContent];
                }
            }
        });
    }];
}


//判断输入框是否有值
- (BOOL)hasTextDocumentProxy {
    NSString *str = self.textDocumentProxy.documentContextBeforeInput;
    if (str.length == 0 || str == nil) {
        return NO;
    }
    return YES;
}

#pragma mark -- 按钮点击事件
//长按地球选择输入法
- (void)handleInputModeListFromView:(nonnull UIView *)view withEvent:(nonnull UIEvent *)event {
    [super handleInputModeListFromView:view withEvent:event];
}

//导航按钮点击
- (void)didNavigationButtonTap:(UIButton*)sender {
    if (_tabBar) {
        [self removeAllCadidateContent];
    }

    NSInteger tag = sender.tag;
    switch (tag) {
        case 102:{
            NSLog(@"设置");

            break;
        }
        case 103:{
            NSLog(@"选择键盘");

            break;
        }
        case 104:{
            NSLog(@"手写");

            break;
        }
        case 105:{
            NSLog(@"表情");

            break;
        }
        case 106:{
            NSLog(@"隐藏");
            _isQuitOutApp = YES;
            [self dismissKeyboard];
            break;
        }
        default:
            break;
    }

}

//导航按钮的选择状态 1设置 2键盘 3手写 4表情
- (void)setNavigationSelectedIndex:(int)index {
    //导航的选择状态
    for (int i=0; i<5; i++) {
        UIButton *button = (UIButton*)[self.view viewWithTag:102+i];
        if (i == index-1) {
            button.selected = YES;
        }else {
            button.selected = NO;
        }
    }
}

//判断导航的选择状态
- (void)setNavigationStatus {
    if (_textKeyboard) {
        [self setNavigationSelectedIndex:2];
    }
}

//改变候选框更多候选的功能 1添加删除 0移除删除并移除tabbar
- (void)changeTabbarShowMoreButton {
    BOOL hasCompontText = [_tabBar isTabBarHasPinyin];
    if (!hasCompontText) {
        [_tabBar changeShowMoreToDelete:YES];
    }else {
        [_tabBar changeShowMoreToDelete:NO];
    }
}

//清除候选框的内容
- (void)removeAllCadidateContent {
    if (_tabBar && [_tabBar isTabBarHasData]) {
        [_tabBar removeFromSuperview];
        _tabBar = nil;
    }
}


//清除大键盘的view
- (void)removeBigKeyboardsView {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    NSString *keyboardStr = [share getValueForKey:@"keyboardType"];
    if ([keyboardStr isEqualToString:@"qwerty_pinyin"] || [keyboardStr isEqualToString:@"qwerty_english"]) {
        [_textKeyboard stopTimer];
        [_textKeyboard removeFromSuperview];
        _textKeyboard = nil;
        [[GZQwerty defaultQwerty] changeDictionary:-1]; //词典的类型重新初始化
        NSLog(@"main-全键盘  销毁");
    }
}

//清除大键盘、核心
- (void)removeAllKeyboards {
    [self removeBigKeyboardsView];
    [self removeAllCoreWorkplace];
}

//释放核心数据
- (void)resetCoreData {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    NSString *keyboardStr = [share getValueForKey:@"keyboardType"];
    if ([keyboardStr isEqualToString:@"qwerty_pinyin"]) {
        GZQwerty *qwerty = [GZQwerty defaultQwerty];
        [qwerty keyboardReset];
    }else if ([keyboardStr isEqualToString:@"qwerty_english"]) {
        GZQwerty *qwerty = [GZQwerty defaultQwerty];
        [qwerty keyboardReset];
    }
}
//清除核心使用的词典
- (void)removeAllCoreDictionary {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    NSString *keyboardStr = [share getValueForKey:@"keyboardType"];
    if ([keyboardStr isEqualToString:@"qwerty_pinyin"]) {
        GZQwerty *qwerty = [GZQwerty defaultQwerty];
        [qwerty releaseDictionary];
    }else if ([keyboardStr isEqualToString:@"qwerty_english"]) {
        GZQwerty *qwerty = [GZQwerty defaultQwerty];
        [qwerty releaseDictionary];
    }
}
//清空所有核心使用开辟的内存
- (void)removeAllCoreWorkplace {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    NSString *keyboardStr = [share getValueForKey:@"keyboardType"];
    if ([keyboardStr isEqualToString:@"qwerty_pinyin"]) {
        GZQwerty *qwerty = [GZQwerty defaultQwerty];
        [qwerty releaseWorkspace];
    }else if ([keyboardStr isEqualToString:@"qwerty_english"]) {
        GZQwerty *qwerty = [GZQwerty defaultQwerty];
        [qwerty releaseWorkspace];
    }
}

//清除所有的视图控件
- (void)removeAllSelfViews {
    if (_heightConstraint) {
        NSLog(@"键盘全局约束  销毁");
        [self.view removeConstraint:_heightConstraint];
        _heightConstraint = nil;
    }

    [self removeAllCadidateContent];
    [self removeBigKeyboardsView];

    //导航父视图
    UIView *navigationBarView = (UIView*)[self.view viewWithTag:101];
    if (navigationBarView) {
        [navigationBarView removeFromSuperview];
        navigationBarView = nil;
    }
    //导航按钮
    for (int i=0; i<5; i++) {
        UIButton *button = (UIButton*)[self.view viewWithTag:102+i];
        if (button) {
            [button removeFromSuperview];
            button = nil;
        }
    }
    //地球
    GZFunctionButton *button = (GZFunctionButton*)[self.view viewWithTag:666];
    if (button) {
        [button removeFromSuperview];
        button = nil;
    }
}



#pragma mark -- 横竖屏切换
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    NSLog(@"viewWillTransitionToSize");
    [self performSelector:@selector(resetKeyboardView) withObject:nil afterDelay:0.1];
}
- (void)resetKeyboardView {
    CGFloat height = [self getKeyboardViewHeight];
    [self setKeyboardViewHeight:height+navigaitonHeight]; //整体高度=键盘+导航的高度
    [self setNavigationBarViewType];
    [self setCadidateViewType];

    if (_textKeyboard) {
        [self setNavigationSelectedIndex:2];
        [_textKeyboard changeViewFrame:CGRectMake(0, navigaitonHeight, keyboardWidth, height)];
        if (!IS_IPHONE_X) {
            [self changeTheGlobeFrameUnderKeyboard:2 withScreenDirection:height]; //小地球
        }
        [self changeGlobleToInput:_isInput ];
    }
}


#pragma mark -- 设置键盘高度
//获取键盘输入部分的高度  除去导航部分
- (CGFloat)getKeyboardViewHeight {
    CGFloat newHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat newWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat _keyboardHeight; //键盘的整体高度
    if (newHeight > newWidth) {
        //竖屏
        if (IS_IPAD_ONLYIphone) {
            _keyboardHeight = 260+navigaitonHeight;
        }else {
            _keyboardHeight = 210+navigaitonHeight;
        }
    }else {
        //横屏
        if (IS_IPAD_ONLYIphone) {
            _keyboardHeight = 200+navigaitonHeight;
        }else {
            _keyboardHeight = 150+navigaitonHeight;
        }
    }
    return _keyboardHeight - navigaitonHeight; //输入部分的高度
}
//获取键盘输入部分宽度 iPhoneX宽度特殊
- (CGFloat)getKeyboardViewWidth {
    CGFloat newHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat newWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat _keyboardWidth; //键盘的整体高度
    if (newHeight < newWidth && IS_IPHONE_X) {
        //横屏 iphoneX
        _keyboardWidth = SCREEN_WIDTH-150; //左右间距
    }else {
        //竖屏
        _keyboardWidth = SCREEN_WIDTH;
    }
    return _keyboardWidth;
}
//设置键盘全局高度
//1竖屏 2横屏
- (void)setKeyboardViewHeight:(CGFloat)keyboardHeight {
    if (!_heightConstraint) {
        _heightConstraint =
        [NSLayoutConstraint constraintWithItem: self.view
                                     attribute: NSLayoutAttributeHeight
                                     relatedBy: NSLayoutRelationEqual
                                        toItem: nil
                                     attribute: NSLayoutAttributeNotAnAttribute
                                    multiplier: 0.0
                                      constant: keyboardHeight];
    }else {
        [self.view removeConstraint:_heightConstraint];
        _heightConstraint.constant = keyboardHeight;
    }

    //inputView和view不能同时都添加约束，会频繁崩溃
    [self.view addConstraint:_heightConstraint];
    //    [self.inputView addConstraint:_heightConstraint];
}
//设置键盘导航布局
- (void)setNavigationBarViewType {
    CGFloat buttonW = 25; //按钮的宽高
    CGFloat space = (keyboardWidth - buttonW*5)/5.4; //左右边距相当于0.7个
    CGFloat y = navigaitonHeight-buttonW-navigationButtonBottom;
    for (int i=0; i<5; i++) {
        UIButton *button = (UIButton*)[self.view viewWithTag:102+i];
        button.frame = CGRectMake(space*0.7 + i*(buttonW+space), y, buttonW, buttonW); //导航高度固定
    }
}
//设置候选框的布局
- (void)setCadidateViewType {
    [_tabBar changeViewFrame:CGRectMake(0, 0, keyboardWidth, navigaitonHeight)];
}










@end
