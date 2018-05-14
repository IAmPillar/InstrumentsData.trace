//
//  GZAlertInputView.m
//  HanvonInput
//
//  Created by hanvon on 2017/12/21.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZAlertInputView.h"


@interface GZAlertInputView ()<UITextViewDelegate>

@end


@implementation GZAlertInputView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title detail:(NSString*)detail{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self createUIWithTitle:title detail:detail];
    }
    return self;
}

- (void)createUIWithTitle:(NSString*)title detail:(NSString*)detail {

    CGFloat left = 17; //视图左边距
    CGFloat titleH = 15; //标题label高度
    CGFloat spaceY = 7;
    CGFloat buttonH = 35; //按钮高度

    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    superView.tag = 101;
    superView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self addSubview:superView];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-left*4, SCREEN_HEIGHT/4)];
    view.center = CGPointMake(superView.center.x, superView.center.y-64);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 15;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[UIColor grayColor] CGColor];
    view.clipsToBounds = YES;
    view.tag = 102;
    [superView addSubview:view];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, spaceY, view.frame.size.width, titleH)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.tag = 103;
    [view addSubview:titleLabel];

    CGFloat inputY = spaceY + titleH + spaceY;
    CGFloat inputW = view.frame.size.width-left*2;
    CGFloat inputH = view.frame.size.height-inputY-spaceY-buttonH;
    UITextView *inputText = [[UITextView alloc] init];
    inputText.frame = CGRectMake(left, inputY, inputW, inputH);
    inputText.backgroundColor = [UIColor whiteColor];
    inputText.layer.borderWidth = 0.5;
    inputText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    inputText.delegate = self;
    inputText.tag = 104;
    [view addSubview:inputText];


    if (detail.length != 0 && detail != nil) {
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.frame = CGRectMake(0, 0, inputW, 15);
        detailLabel.backgroundColor = [UIColor whiteColor];
        detailLabel.text = detail;
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.textColor = [UIColor lightGrayColor];
        detailLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.tag = 105;
        [inputText addSubview:detailLabel];
    }

    NSArray *titles = @[@"取消",@"确认"];
    CGFloat buttonW = view.frame.size.width/2.0;
    CGFloat buttonY = inputY+inputH+spaceY;
    for (int i=0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*buttonW, buttonY, buttonW, buttonH);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 201+i;
        [view addSubview:button];
        if (i == 0) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else {
            [button setTitleColor:float_Color_button_navigation forState:UIControlStateNormal];
        }
    }
}

//设置文本框内容 可以为nil
- (void)setInputTextDetail:(NSString*)detailStr {
    UITextView *inputText =(UITextView*)[self viewWithTag:104];
    if (detailStr.length != 0 && detailStr != nil) {
        inputText.text = detailStr;
        UILabel *detailLabel = (UILabel*)[self viewWithTag:105];
        detailLabel.hidden = YES;
    }
}


#pragma mark -- 交互
//按钮
- (void)buttonClickAction:(UIButton*)sender {
    if (sender.tag == 201) {
        //取消
        if (self.sendInputString) {
            self.sendInputString(nil);
        }
    }else {
        //确认
        UITextView *inputText = (UITextView*)[self viewWithTag:104];
        NSString *string = inputText.text;
        if (string.length != 0 && string != nil) {
            if (self.sendInputString) {
                self.sendInputString(inputText.text);
            }
        }else {
            if (self.sendInputString) {
                self.sendInputString(nil);
            }
        }
    }
}
//输入框
- (void)textViewDidBeginEditing:(UITextView *)textView {
    UILabel *detailLabel = (UILabel*)[self viewWithTag:105];
    if (detailLabel) {
        detailLabel.hidden = YES;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    UITextView *inputText = (UITextView*)[self viewWithTag:104];
    NSString *string = inputText.text;
    if (string.length == 0 || string == nil) {
        UILabel *detailLabel = (UILabel*)[self viewWithTag:105];
        if (detailLabel) {
            detailLabel.hidden = NO;
        }
    }
}


#pragma mark -- dealloc
-(void)dealloc {
    NSLog(@"alert输入框销毁");
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }

    UIView *superView = (UIView*)[self viewWithTag:101];
    if (superView) {
        [superView removeFromSuperview];
        superView = nil;
    }
    UIView *view = (UIView*)[self viewWithTag:102];
    if (view) {
        [view removeFromSuperview];
        view = nil;
    }
    UILabel *titleLabel = (UILabel*)[self viewWithTag:103];
    if (titleLabel) {
        [titleLabel removeFromSuperview];
        titleLabel = nil;
    }
    UITextView *inputText = (UITextView*)[self viewWithTag:104];
    if (inputText) {
        [inputText removeFromSuperview];
        inputText = nil;
    }
    UILabel *detailLabel = (UILabel*)[self viewWithTag:105];
    if (detailLabel) {
        [detailLabel removeFromSuperview];
        detailLabel = nil;
    }
}
@end
