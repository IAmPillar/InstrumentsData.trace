//
//  GZQwertyKeyboard.m
//  HanvonKeyboard
//
//  Created by hanvon on 2017/11/4.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZQwertyKeyboard.h"
#import "GZButton+GZEnlargeEdge.h"

@interface GZQwertyKeyboard()
{
    int keyboardType; //中英文 1中文 2英文小写  3大写  4大写锁定
    NSTimer *timer; //定时器 删除按钮长按
    NSTimer *delay; //点击删除时 延时执行长按的循环
    BOOL isInput; //正在输入中
}

@end


@implementation GZQwertyKeyboard

- (instancetype)initWithFrame:(CGRect)frame andKeyboardType:(int)type {
    self = [super initWithFrame:frame];
    if (self) {
        //创建view
        keyboardType = type;
        isInput = NO;
        [self add];
        if (type != 1) {
            [self changeKeyboardType:type];
        }
    }
    return self;
}

- (void)changeViewFrame:(CGRect)newFrame {

    self.frame = newFrame;

    //键盘布局 水平间距5 垂直间距7
    //键盘布局 顶部间距3 底部间距3
    CGFloat spaceX = 5.0;
    CGFloat spaceY = 7.0;
    CGFloat top = 3.0;
    CGFloat bottom = 3.0;

    CGFloat width = (self.frame.size.width - 11*spaceX)/10.0; //字母按钮的宽度
    CGFloat aLeft = (self.frame.size.width - width*9 - 8*spaceX)/2.0; //字母按键第二行边距
    CGFloat zLeft = (self.frame.size.width - width*7 - 6*spaceX)/2.0; //字母按键第三行边距
    CGFloat height = (self.frame.size.height - top - bottom - 3*spaceY)/4.0; //字母按钮的高度


    //键盘按钮
    NSArray *buttonNames = [NSArray arrayWithObjects:
                            @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p"],
                            @[@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l"],
                            @[@"z",@"x",@"c",@"v",@"b",@"n",@"m"],
                            nil];
    for (int i=0; i<3; i++) {
        for (int j=0; j<[buttonNames[i] count]; j++) {
            if (i==0) {
                UIButton *button = (UIButton*)[self viewWithTag:11+j];
                button.frame = CGRectMake(spaceX + j*(width+spaceX), top, width, height);
            }else if (i==1) {
                UIButton *button = (UIButton*)[self viewWithTag:21+j];
                button.frame = CGRectMake(aLeft + j*(width+spaceX), top + height + spaceY, width, height);
            }else {
                UIButton *button = (UIButton*)[self viewWithTag:30+j];
                button.frame = CGRectMake(zLeft  + j*(width+spaceX), top + height*2 + 2*spaceY, width, height);
            }
        }
    }


    //功能按钮
    CGFloat funcButtonW = (self.frame.size.width - 7*spaceX)/(4+2*1.5); //width+spaceX*2.4; //功能按钮的宽度

    //分隔符
    UIButton *button1 = (UIButton*)[self viewWithTag:41];
    button1.frame = CGRectMake(spaceX, top + height*2 + 2*spaceY, funcButtonW, height);

    //删除键
    UIButton *button2 = (UIButton*)[self viewWithTag:42];
    button2.frame = CGRectMake(self.frame.size.width-funcButtonW-spaceX, top + height*2 + 2*spaceY, funcButtonW, height);

    //其余功能键
    CGFloat funcButtonT = top + height*3 + spaceY*3; //y坐标
    CGFloat konggeW;//width*3+spaceX*2; //空格按钮 宽度
    if (IS_IPHONE_X) {
        konggeW = self.frame.size.width-spaceX*6-funcButtonW*4;
    }else {
        konggeW = funcButtonW*1.5;//width*3+spaceX*2; //空格按钮 宽度
    }
    NSArray *names = @[@"#+=",@"",@"123",@"空格",@"中/英",@"回车"];
    for (int i=0; i<names.count; i++) {
        if (i == 1) {
            continue;
        }
        UIButton *button = (UIButton*)[self viewWithTag:51+i];
        //坐标
        if (IS_IPHONE_X) {
            if (i == 0) {
                button.frame = CGRectMake(spaceX , funcButtonT, funcButtonW, height);
            }else if (i == 1) {
                //小地球 不创建
            }else if (i == 2) {
                button.frame = CGRectMake(spaceX + 1*(spaceX+funcButtonW), funcButtonT, funcButtonW, height);
            }else if (i == 3) {
                //空格
                button.frame = CGRectMake(spaceX + 2*(spaceX+funcButtonW), funcButtonT, konggeW, height);
                button.backgroundColor = [UIColor whiteColor];
            }else if (i == 4) {
                //中英切换
                CGFloat changeX = spaceX*4 + funcButtonW*2 +konggeW; //中英切换 x坐标
                button.frame = CGRectMake(changeX, funcButtonT, funcButtonW, height);
            }else {
                //回车
                CGFloat sureX = spaceX*5 + funcButtonW*3 + konggeW;
                button.frame = CGRectMake(sureX, funcButtonT, self.frame.size.width-spaceX-sureX, height);
            }
        }else {
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
                button.frame = CGRectMake(sureX, funcButtonT, self.frame.size.width-spaceX-sureX, height);
            }
        }
    }
}

- (void)changeKeyboardType:(int)type {
    //1中文（大写）  2英文小写  3大写  4大写锁定
    if (type == 1) {
        keyboardType = 1;
        for (int i=0; i<26; i++) {
            UIButton *button = (UIButton*)[self viewWithTag:11+i];
            button.selected = NO;
        }

        UIButton *button1 = (UIButton*)[self viewWithTag:41];
        [button1 setTitle:@"分词" forState:UIControlStateNormal];
        [button1 setImage:nil forState:UIControlStateNormal];

        UIButton *button2 = (UIButton*)[self viewWithTag:55];
        [button2 setTitle:nil forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"keyboard_ch_en"] forState:UIControlStateNormal];

    }else if (type == 2) {
        keyboardType = 2;
        for (int i=0; i<26; i++) {
            UIButton *button = (UIButton*)[self viewWithTag:11+i];
            button.selected = YES;
        }

        UIButton *button1 = (UIButton*)[self viewWithTag:41];
        [button1 setTitle:nil forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"keyboard_letter_lower"] forState:UIControlStateNormal];

        UIButton *button2 = (UIButton*)[self viewWithTag:55];
        [button2 setTitle:nil forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"keyboard_en_ch"] forState:UIControlStateNormal];

    }else if (type == 3) {
        keyboardType = 3;
        for (int i=0; i<26; i++) {
            UIButton *button = (UIButton*)[self viewWithTag:11+i];
            button.selected = NO;
        }

        UIButton *button1 = (UIButton*)[self viewWithTag:41];
        [button1 setTitle:nil forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"keyboard_letter_capital"] forState:UIControlStateNormal];

        UIButton *button2 = (UIButton*)[self viewWithTag:55];
        [button2 setTitle:nil forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"keyboard_en_ch"] forState:UIControlStateNormal];

    }else if (type == 4) {
        keyboardType = 4;
        for (int i=0; i<26; i++) {
            UIButton *button = (UIButton*)[self viewWithTag:11+i];
            button.selected = NO;
        }

        UIButton *button1 = (UIButton*)[self viewWithTag:41];
        [button1 setTitle:nil forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"keyboard_letter_capital_l"] forState:UIControlStateNormal];

        UIButton *button2 = (UIButton*)[self viewWithTag:55];
        [button2 setTitle:nil forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"keyboard_en_ch"] forState:UIControlStateNormal];
    }
    else {
        return;
    }
}

- (void)changeBackgroudColor {
    //背景色
    self.backgroundColor = Color_background_kb;

    //按键
    for (int i=0; i<26; i++) {
        GZKeyButton *button = (GZKeyButton*)[self viewWithTag:11+i];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.cornerRadius = 5;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

    //分隔符
    GZFunctionButton *button1 = (GZFunctionButton*)[self viewWithTag:41];
    [button1 setBackgroundColor:[UIColor colorWithHexString:float_Color_button_function alpha:1]];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.layer.cornerRadius = 5;

    //删除键
    GZFunctionButton *button2 = (GZFunctionButton*)[self viewWithTag:42];
    [button2 setBackgroundColor:[UIColor colorWithHexString:float_Color_button_function alpha:1]];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.layer.cornerRadius = 5;

    //其余功能
    NSArray *names = @[@"#+=",@"",@"123",@"空格",@"中/英",@"回车"];
    for (int i=0; i<names.count; i++) {
        if (i == 1) {
            continue;
        }
        GZFunctionButton *button = (GZFunctionButton*)[self viewWithTag:51+i];
        [button setBackgroundColor:[UIColor colorWithHexString:float_Color_button_function alpha:1]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;

        if (i == 3) {
            //空格
            button.backgroundColor = [UIColor whiteColor];
        }
    }
}

//改变键盘的功能键 正在输入中
- (void)changeKeyboardStatusToInput:(BOOL)input {
    isInput = input;

    //NSArray *names = @[@"#+=",@"",@"123",@"空格",@"中/英",@"回车"];
    GZFunctionButton *button2 = (GZFunctionButton*)[self viewWithTag:51+2];
    GZFunctionButton *button3 = (GZFunctionButton*)[self viewWithTag:51+4];
    NSString *title2 = button2.titleLabel.text;

    if (input && [title2 isEqualToString:@"123"]) {
        button2.backgroundColor = [UIColor whiteColor];
        button3.backgroundColor = [UIColor whiteColor];

        [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button3 setImage:nil forState:UIControlStateNormal];

        [button2 setTitle:@"，" forState:UIControlStateNormal];
        [button3 setTitle:@"." forState:UIControlStateNormal];
    }

    if (!input && ![title2 isEqualToString:@"123"]) {
        [button2 setBackgroundColor:[UIColor colorWithHexString:float_Color_button_function alpha:1]];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [button3 setBackgroundColor:[UIColor colorWithHexString:float_Color_button_function alpha:1]];
        [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [button2 setTitle:@"123" forState:UIControlStateNormal];
        [button3 setTitle:nil forState:UIControlStateNormal];

        UIImage *image;
        if (keyboardType == 1) {
            image = [UIImage imageNamed:@"keyboard_ch_en"];
        }else {
            image = [UIImage imageNamed:@"keyboard_en_ch"];
        }
        [button3 setImage:image forState:UIControlStateNormal];
    }
}

//手动停止计时器
- (void)stopTimer {
    if (delay) {
        [delay invalidate];
        delay = nil;
    }
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark -- ui
//添加按钮
- (void)add {
    //键盘布局 水平间距5 垂直间距7
    //键盘布局 顶部间距3 底部间距3
    CGFloat spaceX = 5.0;
    CGFloat spaceY = 7.0;
    CGFloat top = 3.0;
    CGFloat bottom = 3.0;

    CGFloat width = (self.frame.size.width - 11*spaceX)/10.0; //字母按钮的宽度
    CGFloat aLeft = (self.frame.size.width - width*9 - 8*spaceX)/2.0; //字母按键第二行边距
    CGFloat zLeft = (self.frame.size.width - width*7 - 6*spaceX)/2.0; //字母按键第三行边距
    CGFloat height = (self.frame.size.height - top - bottom - 3*spaceY)/4.0; //字母按钮的高度

    //键盘按钮
    NSArray *buttonNames = [NSArray arrayWithObjects:
                            @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p"],
                            @[@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l"],
                            @[@"z",@"x",@"c",@"v",@"b",@"n",@"m"],
                            nil];
    NSArray *buttonNames_cap = [NSArray arrayWithObjects:
                                @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P"],
                                @[@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L"],
                                @[@"Z",@"X",@"C",@"V",@"B",@"N",@"M"],
                                nil];
    for (int i=0; i<3; i++) {
        for (int j=0; j<[buttonNames[i] count]; j++) {
            GZKeyButton *button = [GZKeyButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.layer.cornerRadius = 5;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            [button addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            //button.titleLabel.font = [UIFont systemFontOfSize:20];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            [button setTitle:buttonNames_cap[i][j] forState:UIControlStateNormal];
            [button setTitle:buttonNames[i][j] forState:UIControlStateSelected];
            [button setTitle:buttonNames[i][j] forState:UIControlStateSelected | UIControlStateHighlighted];

            button.exclusiveTouch = YES;

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
            [self addSubview:button];

            //扩大点击区域
            [button setEnlargeEdgeWithTop:5.0 right:5.0 bottom:5.0 left:5.0];
        }
    }


    //功能按钮
    CGFloat funcButtonW = (self.frame.size.width - 7*spaceX)/(4+2*1.5); //width+spaceX*2.4; //功能按钮的宽度

    //分隔符
    GZFunctionButton *button1 = [GZFunctionButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundColor:[UIColor colorWithHexString:float_Color_button_function alpha:1]];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.layer.cornerRadius = 5;
    [button1 addTarget:self action:@selector(didFuncTap:) forControlEvents:UIControlEventTouchUpInside];
    button1.titleLabel.font = [UIFont systemFontOfSize:16];
    [button1 setTitle:@"分词" forState:UIControlStateNormal];
    button1.frame = CGRectMake(spaceX, top + height*2 + 2*spaceY, funcButtonW, height);
    button1.tag = 41;
    button1.exclusiveTouch = YES;
    [self addSubview:button1];

    //删除键
    GZFunctionButton *button2 = [GZFunctionButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundColor:[UIColor colorWithHexString:float_Color_button_function alpha:1]];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.layer.cornerRadius = 5;

    [button2 addTarget:self action:@selector(didTouchDown) forControlEvents:UIControlEventTouchDown];
    [button2 addTarget:self action:@selector(didTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(didTouchUp) forControlEvents:UIControlEventTouchUpOutside]; //移动手指出按钮
    [button2 setImage:[UIImage imageNamed:@"keyboard_clear"] forState:UIControlStateNormal];
    button2.frame = CGRectMake(self.frame.size.width-funcButtonW-spaceX, top + height*2 + 2*spaceY, funcButtonW, height);
    button2.tag = 42;
    button2.exclusiveTouch = YES;
    [self addSubview:button2];

    //其余功能键
    CGFloat funcButtonT = top + height*3 + spaceY*3; //y坐标
    CGFloat konggeW; //空格按钮 宽度
    if (IS_IPHONE_X) {
        konggeW = self.frame.size.width-spaceX*6-funcButtonW*4;
    }else {
        konggeW = funcButtonW*1.5;//width*3+spaceX*2; //空格按钮 宽度
    }
    NSArray *names = @[@"#+=",@"",@"123",@"空格",@"中/英",@"回车"];
    for (int i=0; i<names.count; i++) {

        //排除next小地球按钮
        //小地球按钮不再创建
        if (i == 1) {
            continue;
        }

        GZFunctionButton *button = [GZFunctionButton buttonWithType:UIButtonTypeCustom];
        button.tag = 51+i;
        [button addTarget:self action:@selector(didFuncTap:) forControlEvents:UIControlEventTouchUpInside];

        [button setBackgroundColor:[UIColor colorWithHexString:float_Color_button_function alpha:1]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.exclusiveTouch = YES;

        //坐标
        if (IS_IPHONE_X) {
            if (i == 0) {
                button.frame = CGRectMake(spaceX , funcButtonT, funcButtonW, height);
            }else if (i == 1) {
                //小地球 不创建
            }else if (i == 2) {
                button.frame = CGRectMake(spaceX + 1*(spaceX+funcButtonW), funcButtonT, funcButtonW, height);
            }else if (i == 3) {
                //空格
                button.frame = CGRectMake(spaceX + 2*(spaceX+funcButtonW), funcButtonT, konggeW, height);
                button.backgroundColor = [UIColor whiteColor];
            }else if (i == 4) {
                //中英切换
                CGFloat changeX = spaceX*4 + funcButtonW*2 +konggeW; //中英切换 x坐标
                button.frame = CGRectMake(changeX, funcButtonT, funcButtonW, height);
            }else {
                //回车
                CGFloat sureX = spaceX*5 + funcButtonW*3 + konggeW;
                button.frame = CGRectMake(sureX, funcButtonT, self.frame.size.width-spaceX-sureX, height);
            }
        }else {
            if (i < 3) {
                button.frame = CGRectMake(spaceX + i*(spaceX+funcButtonW), funcButtonT, funcButtonW, height);
            }else if (i == 3) {
                //空格
                button.frame = CGRectMake(spaceX + 3*(spaceX+funcButtonW), funcButtonT, konggeW, height);
                button.backgroundColor = [UIColor whiteColor];
            }else if (i == 4) {
                //中英切换
                CGFloat changeX = spaceX*5 + funcButtonW*3 +konggeW; //中英切换 x坐标
                button.frame = CGRectMake(changeX, funcButtonT, funcButtonW, height);
            }else {
                //回车
                CGFloat sureX = spaceX*6 + funcButtonW*4 + konggeW;
                button.frame = CGRectMake(sureX, funcButtonT, self.frame.size.width-spaceX-sureX, height);
            }
        }

        //标题
        if (i == 0) {
            [button setTitle:@"#+=" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
        }else if (i == 1) {
            [button setImage:[UIImage imageNamed:@"keyboard_esrth"] forState:UIControlStateNormal];

        }else if (i == 2) {
            [button setTitle:@"123" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
        }else if (i == 3) {
            [button setImage:[UIImage imageNamed:@"keyboard_space"] forState:UIControlStateNormal];
            CGSize imageSize = button.imageView.bounds.size;
            button.imageEdgeInsets = UIEdgeInsetsMake(imageSize.height/2.5,0, -imageSize.height/2.5, 0);
        }else if (i == 4) {
            [button setImage:[UIImage imageNamed:@"keyboard_ch_en"] forState:UIControlStateNormal];

        }else {
            [button setImage:[UIImage imageNamed:@"keyboard_enter"] forState:UIControlStateNormal];
        }

        [self addSubview:button];
    }

}


#pragma mark -- button click action
//文本键 回调
- (void)didButtonTap:(UIButton*)tap {
    UIButton *button = (UIButton*)tap;
    [UIView animateWithDuration:0.05 animations:^{
        [button setBackgroundColor:float_Color_button_hightlight];
    } completion:^(BOOL finished) {
        [button setBackgroundColor:[UIColor whiteColor]];
    }];

    NSInteger tagN = button.tag;

    NSArray *buttonNames;
    if (keyboardType == 2) {
        buttonNames = [NSArray arrayWithObjects:
                       @"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",
                       @"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",
                       @"z",@"x",@"c",@"v",@"b",@"n",@"m",
                       nil];
    }else {
        buttonNames = [NSArray arrayWithObjects:
                       @"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",
                       @"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",
                       @"Z",@"X",@"C",@"V",@"B",@"N",@"M",
                       nil];
    }

    NSString *text = nil;
    switch (tagN) {
        case 11:
            text = buttonNames[0];
            break;
        case 12:
            text = buttonNames[1];
            break;
        case 13:
            text = buttonNames[2];
            break;
        case 14:
            text = buttonNames[3];
            break;
        case 15:
            text = buttonNames[4];
            break;
        case 16:
            text = buttonNames[5];
            break;
        case 17:
            text = buttonNames[6];
            break;
        case 18:
            text = buttonNames[7];
            break;
        case 19:
            text = buttonNames[8];
            break;
        case 20:
            text = buttonNames[9];
            break;
        case 21:
            text = buttonNames[10];
            break;
        case 22:
            text = buttonNames[11];
            break;
        case 23:
            text = buttonNames[12];
            break;
        case 24:
            text = buttonNames[13];
            break;
        case 25:
            text = buttonNames[14];
            break;
        case 26:
            text = buttonNames[15];
            break;
        case 27:
            text = buttonNames[16];
            break;
        case 28:
            text = buttonNames[17];
            break;
        case 29:
            text = buttonNames[18];
            break;
        case 30:
            text = buttonNames[19];
            break;
        case 31:
            text = buttonNames[20];
            break;
        case 32:
            text = buttonNames[21];
            break;
        case 33:
            text = buttonNames[22];
            break;
        case 34:
            text = buttonNames[23];
            break;
        case 35:
            text = buttonNames[24];
            break;
        case 36:
            text = buttonNames[25];
            break;

        default:
            break;
    }

    if (text.length != 0 && self.sendSelectedStr) {
        self.sendSelectedStr(text);
    }

    if (keyboardType == 3) {
        [self changeKeyboardType:2];
    }

    text = nil;
    buttonNames = nil;
}
//功能键回调 1分隔 2删除 3符号 4下一个输入法 5数字 6空格 7中英切换 8回车 10逗号 11点号
- (void)didFuncTap:(UIButton*)tap {
    UIButton *button = (UIButton*)tap;
    NSInteger tagN = button.tag;
    if ((tagN == 53 || tagN == 55) && isInput) {

    }else {
        UIColor *color = button.backgroundColor;
        [UIView animateWithDuration:0.05 animations:^{
            [button setBackgroundColor:float_Color_button_hightlight];
        } completion:^(BOOL finished) {
            [button setBackgroundColor:color];
        }];
        color = nil;
    }

    int type = 0;
    __weak GZQwertyKeyboard *weakSelf = self;
    switch (tagN) {
        case 41:{
            //1中文  2英文小写  3大写  4大写锁定
            if (keyboardType == 1) {
                type = 1;
                if (self.sendSelectedStr) {
                    self.sendSelectedStr(@"'");
                }
            }else if (keyboardType == 2) {
                keyboardType = 3;
                [weakSelf changeKeyboardType:3];
            }else if (keyboardType == 3) {
                keyboardType = 4;
                [weakSelf changeKeyboardType:4];
            }else if (keyboardType == 4) {
                keyboardType = 2;
                [weakSelf changeKeyboardType:2];
            }
            break;
        }
        case 42:{
            type = 2;
            //            if (self.sendSelectedStr) {
            //                self.sendSelectedStr(@"delete");
            //            }
            break;
        }
        case 51:
            type = 3;
            break;
        case 52:
            type = 4;
            break;
        case 53: {
            if (!isInput) {
                type = 5;
            }else {
                type = 10;
            }
            break;
        }
        case 54:
            type = 6;
            break;
        case 55:{
            if (!isInput) {
                type = 7;
            }else {
                type = 11;
            }
            break;
        }
        case 56:
            type = 8;
            break;
        default:
            break;
    }

    if (type != 0 && self.sendSelectedFunc) {
        self.sendSelectedFunc(type);
    }
}

//删除按钮---------------------------------
/*
 UIControlEventTouchDown即按钮按下时应触发的方法。
 实际使用过程中会出现延迟响应或间歇无响应，
 但是放开手指时会直接响应UIControlEventTouchDown、UIControlEventTouchUpInside两个方法
 touchesBegan不响应 不能用之获取按钮坐标
 */
- (void)didTouchDown {
    NSLog(@"didTouchDown");

    UIButton *button = (UIButton*)[self viewWithTag:42];
    UIColor *ori = button.backgroundColor;
    [UIView animateWithDuration:0.1 animations:^{
        [button setBackgroundColor:float_Color_button_hightlight];
    } completion:^(BOOL finished) {
        [button setBackgroundColor:ori];
    }];

    [self deleteActionStart];

    //延时执行 长按删除
    if (!delay) {
        delay = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(delayAction) userInfo:nil repeats:NO];
    }
}
- (void)didTouchUp {
    NSLog(@"didTouchUp");
    [delay invalidate];
    delay = nil;
    [timer invalidate];
    timer = nil;
    [self deleteActionStop];
}

//延时执行 长按删除
- (void)delayAction {
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(deleteActionStart) userInfo:nil repeats:YES];
    }
}

- (void)deleteActionStart {
    if (self.sendDeleteTap) {
        self.sendDeleteTap(YES);
    }
}
- (void)deleteActionStop {
    if (self.sendDeleteTap) {
        self.sendDeleteTap(NO);
    }
}



- (void)dealloc {
    NSLog(@"全键盘 销毁");
    if (delay) {
        [delay invalidate];
        delay = nil;
    }
    if (timer) {
        [timer invalidate];
        timer = nil;
    }

    for (UIView *view in self.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }


    for (int i=0; i<26; i++) {
        UIButton *button = (UIButton*)[self viewWithTag:11+i];
        if (button) {
            [button removeFromSuperview];
            button = nil;
        }
    }

    //分隔符
    UIButton *button1 = (UIButton*)[self viewWithTag:41];
    if (button1) {
        [button1 removeFromSuperview];
        button1 = nil;
    }

    //删除键
    UIButton *button2 = (UIButton*)[self viewWithTag:42];
    if (button2) {
        [button2 removeFromSuperview];
        button2 = nil;
    }

    //其余功能键
    //NSArray *names = @[@"#+=",@"",@"123",@"空格",@"中/英",@"回车"];
    for (int i=0; i<6; i++) {
        UIButton *button = (UIButton*)[self viewWithTag:51+i];
        if (button) {
            [button removeFromSuperview];
            button = nil;
        }
    }

    self.sendSelectedStr = nil;
    self.sendSelectedFunc = nil;
    self.sendDeleteTap = nil;

    [self removeFromSuperview];
}



#pragma mark -- 废弃
/*
 - (void)addButtons {
 qButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [qButton setTitle:@"Q" forState:UIControlStateNormal];
 qButton.backgroundColor = [UIColor whiteColor];
 [qButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 qButton.tag = 11;
 qButton.layer.cornerRadius = 5;
 qButton.clipsToBounds = YES;
 qButton.layer.shadowOpacity = 1.0;
 qButton.layer.shadowOffset = CGSizeMake(0, 4);
 qButton.layer.shadowRadius = 5;
 qButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [qButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 qButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:qButton];

 wButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [wButton setTitle:@"W" forState:UIControlStateNormal];
 wButton.backgroundColor = [UIColor whiteColor];
 [wButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 wButton.tag = 12;
 wButton.layer.cornerRadius = 5;
 wButton.clipsToBounds = YES;
 wButton.layer.shadowOpacity = 1.0;
 wButton.layer.shadowOffset = CGSizeMake(0, 4);
 wButton.layer.shadowRadius = 5;
 wButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [wButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 wButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:wButton];

 eButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [eButton setTitle:@"E" forState:UIControlStateNormal];
 eButton.backgroundColor = [UIColor whiteColor];
 [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 eButton.tag = 13;
 eButton.layer.cornerRadius = 5;
 eButton.clipsToBounds = YES;
 eButton.layer.shadowOpacity = 1.0;
 eButton.layer.shadowOffset = CGSizeMake(0, 4);
 eButton.layer.shadowRadius = 5;
 eButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [eButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 eButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:eButton];

 rButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [rButton setTitle:@"R" forState:UIControlStateNormal];
 rButton.backgroundColor = [UIColor whiteColor];
 [rButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 rButton.tag = 14;
 rButton.layer.cornerRadius = 5;
 rButton.clipsToBounds = YES;
 rButton.layer.shadowOpacity = 1.0;
 rButton.layer.shadowOffset = CGSizeMake(0, 4);
 rButton.layer.shadowRadius = 5;
 rButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [rButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 rButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:rButton];

 tButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [tButton setTitle:@"T" forState:UIControlStateNormal];
 tButton.backgroundColor = [UIColor whiteColor];
 [tButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 tButton.tag = 15;
 tButton.layer.cornerRadius = 5;
 tButton.clipsToBounds = YES;
 tButton.layer.shadowOpacity = 1.0;
 tButton.layer.shadowOffset = CGSizeMake(0, 4);
 tButton.layer.shadowRadius = 5;
 tButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [tButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 tButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:tButton];

 yButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [yButton setTitle:@"Y" forState:UIControlStateNormal];
 yButton.backgroundColor = [UIColor whiteColor];
 [yButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 yButton.tag = 16;
 yButton.layer.cornerRadius = 5;
 yButton.clipsToBounds = YES;
 yButton.layer.shadowOpacity = 1.0;
 yButton.layer.shadowOffset = CGSizeMake(0, 4);
 yButton.layer.shadowRadius = 5;
 yButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [yButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 yButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:yButton];

 uButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [uButton setTitle:@"U" forState:UIControlStateNormal];
 uButton.backgroundColor = [UIColor whiteColor];
 [uButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 uButton.tag = 17;
 uButton.layer.cornerRadius = 5;
 uButton.clipsToBounds = YES;
 uButton.layer.shadowOpacity = 1.0;
 uButton.layer.shadowOffset = CGSizeMake(0, 4);
 uButton.layer.shadowRadius = 5;
 uButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [uButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 uButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:uButton];

 iButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [iButton setTitle:@"I" forState:UIControlStateNormal];
 iButton.backgroundColor = [UIColor whiteColor];
 [iButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 iButton.tag = 18;
 iButton.layer.cornerRadius = 5;
 iButton.clipsToBounds = YES;
 iButton.layer.shadowOpacity = 1.0;
 iButton.layer.shadowOffset = CGSizeMake(0, 4);
 iButton.layer.shadowRadius = 5;
 iButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [iButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 iButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:iButton];

 oButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [oButton setTitle:@"O" forState:UIControlStateNormal];
 oButton.backgroundColor = [UIColor whiteColor];
 [oButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 oButton.tag = 19;
 oButton.layer.cornerRadius = 5;
 oButton.clipsToBounds = YES;
 oButton.layer.shadowOpacity = 1.0;
 oButton.layer.shadowOffset = CGSizeMake(0, 4);
 oButton.layer.shadowRadius = 5;
 oButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [oButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 oButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:oButton];

 pButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [pButton setTitle:@"P" forState:UIControlStateNormal];
 pButton.backgroundColor = [UIColor whiteColor];
 [pButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 pButton.tag = 20;
 pButton.layer.cornerRadius = 5;
 pButton.clipsToBounds = YES;
 pButton.layer.shadowOpacity = 1.0;
 pButton.layer.shadowOffset = CGSizeMake(0, 4);
 pButton.layer.shadowRadius = 5;
 pButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [pButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 pButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:pButton];

 aButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [aButton setTitle:@"A" forState:UIControlStateNormal];
 aButton.backgroundColor = [UIColor whiteColor];
 [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 aButton.tag = 21;
 aButton.layer.cornerRadius = 5;
 aButton.clipsToBounds = YES;
 aButton.layer.shadowOpacity = 1.0;
 aButton.layer.shadowOffset = CGSizeMake(0, 4);
 aButton.layer.shadowRadius = 5;
 aButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [aButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 aButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:aButton];

 sButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [sButton setTitle:@"S" forState:UIControlStateNormal];
 sButton.backgroundColor = [UIColor whiteColor];
 [sButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 sButton.tag = 22;
 sButton.layer.cornerRadius = 5;
 sButton.clipsToBounds = YES;
 sButton.layer.shadowOpacity = 1.0;
 sButton.layer.shadowOffset = CGSizeMake(0, 4);
 sButton.layer.shadowRadius = 5;
 sButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [sButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 sButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:sButton];

 dButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [dButton setTitle:@"D" forState:UIControlStateNormal];
 dButton.backgroundColor = [UIColor whiteColor];
 [dButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 dButton.tag = 23;
 dButton.layer.cornerRadius = 5;
 dButton.clipsToBounds = YES;
 dButton.layer.shadowOpacity = 1.0;
 dButton.layer.shadowOffset = CGSizeMake(0, 4);
 dButton.layer.shadowRadius = 5;
 dButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [dButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 dButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:dButton];

 fButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [fButton setTitle:@"F" forState:UIControlStateNormal];
 fButton.backgroundColor = [UIColor whiteColor];
 [fButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 fButton.tag = 24;
 fButton.layer.cornerRadius = 5;
 fButton.clipsToBounds = YES;
 fButton.layer.shadowOpacity = 1.0;
 fButton.layer.shadowOffset = CGSizeMake(0, 4);
 fButton.layer.shadowRadius = 5;
 fButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [fButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 fButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:fButton];

 gButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [gButton setTitle:@"G" forState:UIControlStateNormal];
 gButton.backgroundColor = [UIColor whiteColor];
 [gButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 gButton.tag = 25;
 gButton.layer.cornerRadius = 5;
 gButton.clipsToBounds = YES;
 gButton.layer.shadowOpacity = 1.0;
 gButton.layer.shadowOffset = CGSizeMake(0, 4);
 gButton.layer.shadowRadius = 5;
 gButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [gButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 gButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:gButton];

 hButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [hButton setTitle:@"H" forState:UIControlStateNormal];
 hButton.backgroundColor = [UIColor whiteColor];
 [hButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 hButton.tag = 26;
 hButton.layer.cornerRadius = 5;
 hButton.clipsToBounds = YES;
 hButton.layer.shadowOpacity = 1.0;
 hButton.layer.shadowOffset = CGSizeMake(0, 4);
 hButton.layer.shadowRadius = 5;
 hButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [hButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 hButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:hButton];

 jButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [jButton setTitle:@"J" forState:UIControlStateNormal];
 jButton.backgroundColor = [UIColor whiteColor];
 [jButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 jButton.tag = 27;
 jButton.layer.cornerRadius = 5;
 jButton.clipsToBounds = YES;
 jButton.layer.shadowOpacity = 1.0;
 jButton.layer.shadowOffset = CGSizeMake(0, 4);
 jButton.layer.shadowRadius = 5;
 jButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [jButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 jButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:jButton];

 kButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [kButton setTitle:@"K" forState:UIControlStateNormal];
 kButton.backgroundColor = [UIColor whiteColor];
 [kButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 kButton.tag = 28;
 kButton.layer.cornerRadius = 5;
 kButton.clipsToBounds = YES;
 kButton.layer.shadowOpacity = 1.0;
 kButton.layer.shadowOffset = CGSizeMake(0, 4);
 kButton.layer.shadowRadius = 5;
 kButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [kButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 kButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:kButton];

 lButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [lButton setTitle:@"L" forState:UIControlStateNormal];
 lButton.backgroundColor = [UIColor whiteColor];
 [lButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 lButton.tag = 29;
 lButton.layer.cornerRadius = 5;
 lButton.clipsToBounds = YES;
 lButton.layer.shadowOpacity = 1.0;
 lButton.layer.shadowOffset = CGSizeMake(0, 4);
 lButton.layer.shadowRadius = 5;
 lButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [lButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 lButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:lButton];

 zButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [zButton setTitle:@"Z" forState:UIControlStateNormal];
 zButton.backgroundColor = [UIColor whiteColor];
 [zButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 zButton.tag = 30;
 zButton.layer.cornerRadius = 5;
 zButton.clipsToBounds = YES;
 zButton.layer.shadowOpacity = 1.0;
 zButton.layer.shadowOffset = CGSizeMake(0, 4);
 zButton.layer.shadowRadius = 5;
 zButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [zButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 zButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:zButton];

 xButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [xButton setTitle:@"X" forState:UIControlStateNormal];
 xButton.backgroundColor = [UIColor whiteColor];
 [xButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 xButton.tag = 31;
 xButton.layer.cornerRadius = 5;
 xButton.clipsToBounds = YES;
 xButton.layer.shadowOpacity = 1.0;
 xButton.layer.shadowOffset = CGSizeMake(0, 4);
 xButton.layer.shadowRadius = 5;
 xButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [xButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 xButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:xButton];

 cButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [cButton setTitle:@"C" forState:UIControlStateNormal];
 cButton.backgroundColor = [UIColor whiteColor];
 [cButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 cButton.tag = 32;
 cButton.layer.cornerRadius = 5;
 cButton.clipsToBounds = YES;
 cButton.layer.shadowOpacity = 1.0;
 cButton.layer.shadowOffset = CGSizeMake(0, 4);
 cButton.layer.shadowRadius = 5;
 cButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [cButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 cButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:cButton];

 vButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [vButton setTitle:@"V" forState:UIControlStateNormal];
 vButton.backgroundColor = [UIColor whiteColor];
 [vButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 vButton.tag = 33;
 vButton.layer.cornerRadius = 5;
 vButton.clipsToBounds = YES;
 vButton.layer.shadowOpacity = 1.0;
 vButton.layer.shadowOffset = CGSizeMake(0, 4);
 vButton.layer.shadowRadius = 5;
 vButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [vButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 vButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:vButton];

 bButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [bButton setTitle:@"B" forState:UIControlStateNormal];
 bButton.backgroundColor = [UIColor whiteColor];
 [bButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 bButton.tag = 34;
 bButton.layer.cornerRadius = 5;
 bButton.clipsToBounds = YES;
 bButton.layer.shadowOpacity = 1.0;
 bButton.layer.shadowOffset = CGSizeMake(0, 4);
 bButton.layer.shadowRadius = 5;
 bButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [bButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 bButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:bButton];

 nButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [nButton setTitle:@"N" forState:UIControlStateNormal];
 nButton.backgroundColor = [UIColor whiteColor];
 [nButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 nButton.tag = 35;
 nButton.layer.cornerRadius = 5;
 nButton.clipsToBounds = YES;
 nButton.layer.shadowOpacity = 1.0;
 nButton.layer.shadowOffset = CGSizeMake(0, 4);
 nButton.layer.shadowRadius = 5;
 nButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [nButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 nButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:nButton];

 mButton = [UIButton buttonWithType:UIButtonTypeSystem];
 [mButton setTitle:@"M" forState:UIControlStateNormal];
 mButton.backgroundColor = [UIColor whiteColor];
 [mButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 mButton.tag = 36;
 mButton.layer.cornerRadius = 5;
 mButton.clipsToBounds = YES;
 mButton.layer.shadowOpacity = 1.0;
 mButton.layer.shadowOffset = CGSizeMake(0, 4);
 mButton.layer.shadowRadius = 5;
 mButton.layer.shadowColor = [UIColor blackColor].CGColor;
 [mButton addTarget:self action:@selector(didButtonTap:) forControlEvents:UIControlEventTouchUpInside];
 mButton.translatesAutoresizingMaskIntoConstraints = NO;
 [self addSubview:mButton];
 }

 - (void)addLayout {

 CGFloat width = (self.frame.size.width - 11*7)/10.0; //字母按钮的宽度
 CGFloat aLeft = (self.frame.size.width - width*9 - 8*7)/2.0; //字母按键第二行边距
 CGFloat zLeft = (self.frame.size.width - width*7 - 6*7)/2.0; //字母按键第三行边距

 NSDictionary *views = NSDictionaryOfVariableBindings(self,qButton,wButton,eButton,rButton,tButton,yButton,uButton,iButton,oButton,pButton,aButton,sButton,dButton,fButton,gButton,hButton,jButton,kButton,lButton,zButton,xButton,cButton,vButton,bButton,nButton,mButton);

 NSString *qLayoutStr = [NSString stringWithFormat:@"H:|-7-[qButton(==wButton)]-7-[wButton(==eButton)]-7-[eButton(==rButton)]-7-[rButton(==tButton)]-7-[tButton(==yButton)]-7-[yButton(==uButton)]-7-[uButton(==iButton)]-7-[iButton(==oButton)]-7-[oButton(==pButton)]-7-[pButton]-7-|"];
 NSString *aLayoutStr = [NSString stringWithFormat:@"H:|-%f-[aButton(==sButton)]-7-[sButton(==dButton)]-7-[dButton(==fButton)]-7-[fButton(==gButton)]-7-[gButton(==hButton)]-7-[hButton(==jButton)]-7-[jButton(==kButton)]-7-[kButton(==lButton)]-7-[lButton(==pButton)]-%f-|",aLeft,aLeft];
 NSString *zLayoutStr = [NSString stringWithFormat:@"H:|-%f-[zButton(==xButton)]-7-[xButton(==cButton)]-7-[cButton(==vButton)]-7-[vButton(==bButton)]-7-[bButton(==nButton)]-7-[nButton(==mButton)]-7-[mButton(==lButton)]-%f-|",zLeft,zLeft];

 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:qLayoutStr options:0 metrics:0 views:views]];
 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:aLayoutStr options:0 metrics:0 views:views]];
 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:zLayoutStr options:0 metrics:0 views:views]];


 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[qButton(==aButton)]-10-[aButton(==zButton)]-10-[zButton]-|" options:0 metrics:0 views:views]];
 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[wButton(==sButton)]-10-[sButton(==xButton)]-10-[xButton]-|" options:0 metrics:0 views:views]];
 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[eButton(==dButton)]-10-[dButton(==cButton)]-10-[cButton]-|" options:0 metrics:0 views:views]];
 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[rButton(==fButton)]-10-[fButton(==vButton)]-10-[vButton]-|" options:0 metrics:0 views:views]];
 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[tButton(==gButton)]-10-[gButton(==bButton)]-10-[bButton]-|" options:0 metrics:0 views:views]];
 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[yButton(==hButton)]-10-[hButton(==nButton)]-10-[nButton]-|" options:0 metrics:0 views:views]];
 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[uButton(==jButton)]-10-[jButton(==mButton)]-10-[mButton]-|" options:0 metrics:0 views:views]];
 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[iButton(==kButton)]-10-[kButton(==mButton)]-10-[mButton]-|" options:0 metrics:0 views:views]];
 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[oButton(==lButton)]-10-[lButton(==mButton)]-10-[mButton]-|" options:0 metrics:0 views:views]];
 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[pButton(==lButton)]-10-[lButton(==mButton)]-10-[mButton]-|" options:0 metrics:0 views:views]];

 }
 */



@end
