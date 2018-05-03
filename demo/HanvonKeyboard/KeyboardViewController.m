//
//  KeyboardViewController.m
//  HanvonKeyboard
//
//  Created by hanvon on 2017/11/4.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "KeyboardViewController.h"
#import "GZCandidateBarView.h"


#define navigaitonHeight 60 //导航栏的高度
#define navigationButtonBottom 10 //导航上按钮距离底端距离

@interface KeyboardViewController ()
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint; //键盘整体高度约束
@property (nonatomic, strong) GZCandidateBarView *tabBar; //候选框
@end



@implementation KeyboardViewController

#pragma mark -- memorry waring
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"******* ******* ******* ******* ");
    NSLog(@"Warning!!!!!!didReceiveMemoryWarning!!!!!!");
}

#pragma mark -- life cycle
- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
    [super beginRequestWithExtensionContext:context];
    NSLog(@"开始启动Extension");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"启动viewDidload");
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 1;

    [self addNavigationBarView]; //添加导航
    [self createKeyboardView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    //约束键盘高度
    CGFloat height = [self getKeyboardViewHeight];
    [self setKeyboardViewHeight:height+navigaitonHeight]; //整体高度=键盘+导航的高度
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}
- (void)dealloc {
    NSLog(@"main主页面 销毁");
}


#pragma mark -- PrepareUI
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
}

#pragma mark -- 键盘
//UI
- (void)createKeyboardView {
    //创建view
    CGFloat spaceX = 5.0;
    CGFloat spaceY = 7.0;
    CGFloat top = navigaitonHeight + 3.0 ;
    CGFloat bottom = 3.0;

    CGFloat HH = [self getKeyboardViewHeight];

    CGFloat width = (SCREEN_WIDTH - 11*spaceX)/10.0; //字母按钮的宽度
    CGFloat aLeft = (SCREEN_WIDTH - width*9 - 8*spaceX)/2.0; //字母按键第二行边距
    CGFloat zLeft = (SCREEN_WIDTH - width*7 - 6*spaceX)/2.0; //字母按键第三行边距
    CGFloat height = (HH - bottom - 3*spaceY)/4.0; //字母按钮的高度

    //键盘按钮
    NSArray *buttonNames = [NSArray arrayWithObjects:
                            @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p"],
                            @[@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l"],
                            @[@"z",@"x",@"c",@"v",@"b",@"n",@"m"],
                            nil];
    for (int i=0; i<3; i++) {
        for (int j=0; j<[buttonNames[i] count]; j++) {
            GZKeyButton *button = [GZKeyButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor lightGrayColor]];
            button.layer.cornerRadius = 5;
            [button addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:20];
            [button setTitle:buttonNames[i][j] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            if (i==0) {
                button.frame = CGRectMake(spaceX + j*(width+spaceX), top, width, height);
                button.tag = 11+j;
            }else if (i==1) {
                button.frame = CGRectMake(aLeft + j*(width+spaceX), top + height + spaceY, width, height);
                button.tag = 21+j;
            }else {
                button.frame = CGRectMake(zLeft  + j*(width+spaceX), top + height*2 + 2*spaceY, width, height);
                button.tag = 30+j;
            }
            [self.view addSubview:button];
        }
    }

    //功能按钮
    CGFloat funcButtonW = (SCREEN_WIDTH - 7*spaceX)/(4+2*1.5); //width+spaceX*2.4; //功能按钮的宽度

    //删除键
    GZFunctionButton *button2 = [GZFunctionButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor = [UIColor colorWithHexString:float_Color_button_function alpha:1];
    button2.layer.cornerRadius = 5;
    [button2 addTarget:self action:@selector(didTouchUp) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(SCREEN_WIDTH-funcButtonW-spaceX, top + height*2 + 2*spaceY, funcButtonW, height);
    button2.tag = 42;
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setTitle:@"删除" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:button2];

    //其余功能键
    CGFloat funcButtonT = top + height*3 + spaceY*3; //y坐标
    CGFloat konggeW = funcButtonW*1.5;//width*3+spaceX*2; //空格按钮 宽度

    NSArray *names = @[@"#+=",@"",@"123",@"空格",@"中/英",@"回车"];
    for (int i=0; i<names.count; i++) {

        //排除next小地球按钮
        //小地球按钮不再创建
        if (i == 1 || i == 2 || i == 4 || i == 5) {
            continue;
        }

        GZFunctionButton *button = [GZFunctionButton buttonWithType:UIButtonTypeCustom];
        button.tag = 51+i;
        [button addTarget:self action:@selector(didFuncTap:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor colorWithHexString:float_Color_button_function alpha:1]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;

        //坐标
        if (i < 3) {
            button.frame = CGRectMake(spaceX + i*(spaceX+funcButtonW), funcButtonT, funcButtonW, height);
        }else if (i == 3) {
            //空格
            button.frame = CGRectMake(spaceX + 3*(spaceX+funcButtonW), funcButtonT, konggeW, height);
        }else if (i == 4) {
            //中英切换
            CGFloat changeX = spaceX*5 + funcButtonW*3 +konggeW; //中英切换 x坐标
            button.frame = CGRectMake(changeX, funcButtonT, funcButtonW, height);
        }else {
            //回车
            CGFloat sureX = spaceX*6 + funcButtonW*4 + konggeW;
            button.frame = CGRectMake(sureX, funcButtonT, SCREEN_WIDTH-spaceX-sureX, height);
        }

        //标题
        if (i == 0) {
            [button setTitle:@"选择" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
        }else if (i == 1) {
            [button setImage:[UIImage imageNamed:@"keyboard_esrth"] forState:UIControlStateNormal];

        }else if (i == 2) {
            [button setTitle:@"123" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
        }else if (i == 3) {
            [button setTitle:@"联想" forState:UIControlStateNormal];
            CGSize imageSize = button.imageView.bounds.size;
            button.imageEdgeInsets = UIEdgeInsetsMake(imageSize.height/2.5,0, -imageSize.height/2.5, 0);
        }else if (i == 4) {
            [button setImage:[UIImage imageNamed:@"keyboard_ch_en"] forState:UIControlStateNormal];

        }else {
            [button setImage:[UIImage imageNamed:@"keyboard_enter"] forState:UIControlStateNormal];
        }

        [self.view addSubview:button];
    }
}

//文本键 回调
- (void)didButtonTap:(UIButton*)tap {
    if (!self.tabBar) {
        [self addCandidateBarView];
    }

    UIButton *button = (UIButton*)tap;
    NSString *text = [NSString stringWithFormat:@"%@",button.titleLabel.text];
    NSString *first = [_tabBar getFirstCandidate];
    if (first.length > 0) {
        text = [first stringByAppendingFormat:@"%@",text];
    }

    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:30];
    for (int i=0; i<30; i++) {
        [arr addObject:text];
    }
    [_tabBar changeShowText:arr];
    [_tabBar changeShowPinyin:text andRange:NSMakeRange(0, 0)];
    [self changeTabbarShowMoreButton];
}
//功能键回调 1选择
- (void)didFuncTap:(UIButton*)tap {
    switch (tap.tag) {
        case 51: {
            //选择
            NSString *candidateStr = [_tabBar getFirstCandidate];
            [self.textDocumentProxy insertText:candidateStr];
            candidateStr = nil;

            [self removeAllCadidateContent];
            break;
        }
        case 54:{
            //联想
            NSString *inserStr;
            BOOL isHavePinyin = [_tabBar isTabBarHasPinyin];
            if (isHavePinyin) {
                NSString *candidateStr = [_tabBar getFirstCandidate];
                if (candidateStr.length != 0 && candidateStr != nil) {
                    [self clickTabbarIndex:0 byText:candidateStr];
                    candidateStr = nil;
                    inserStr = nil;
                    return ;
                }else {
                    inserStr = [NSString stringWithFormat:@" "];
                }
            }else {
                inserStr = [NSString stringWithFormat:@" "];
            }
            [self.textDocumentProxy insertText:inserStr];

            [self removeAllCadidateContent];
            inserStr = nil;
            break;
        }
        default:
            break;
    }
}
//删除按钮
- (void)didTouchUp {
    NSLog(@"didTouchUp");
    if (_tabBar && [_tabBar isTabBarHasData]) {
        NSString *first = [_tabBar getFirstCandidate];
        NSInteger num = first.length;
        if (num > 0) {
            first = [first substringToIndex:num-2];
        }

        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:30];
        for (int i=0; i<30; i++) {
            [arr addObject:first];
        }
        [_tabBar changeShowText:arr];
        [_tabBar changeShowPinyin:first andRange:NSMakeRange(0, 0)];
    }else {
        [self.textDocumentProxy deleteBackward];
    }
}

#pragma mark -- 候选栏
//UI
- (void)addCandidateBarView {
    if (!_tabBar) {
        _tabBar = [[GZCandidateBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, navigaitonHeight)];
        _tabBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tabBar];
    }

    __weak KeyboardViewController *weakSelf = self;
    _tabBar.sendSelectedStr = ^(NSString *text, int selectIndex) {
        if (text.length == 0) {
            [weakSelf removeAllCadidateContent];
            text = nil;
            return ;
        }
        [weakSelf clickTabbarIndex:selectIndex byText:text]; //联想
        text = nil;
    };

    _tabBar.sendRemoveTabbar = ^(BOOL remove) {
        if (remove) {
            [weakSelf.tabBar removeFromSuperview];
            weakSelf.tabBar = nil;
        }
    };
    weakSelf = nil;
}

//点击候选按钮的操作
- (void)clickTabbarIndex:(int)selectIndex byText:(NSString*)text {
    //全键盘 拼音
    NSString *first = [_tabBar getFirstCandidate];
    NSInteger num = first.length;
    if (num > 0) {
        [self.textDocumentProxy insertText:first];
        [self removeAllCadidateContent];
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
//设置键盘全局高度  1竖屏 2横屏
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

    [self.view addConstraint:_heightConstraint];
}









@end
