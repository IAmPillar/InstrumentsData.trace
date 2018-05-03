//
//  GZOpinionFeedbackController.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/14.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZOpinionFeedbackController.h"

@interface GZOpinionFeedbackController ()<UITextViewDelegate,UITextFieldDelegate>

@end

@implementation GZOpinionFeedbackController

- (void)dealloc {
    NSLog(@"意见反馈页面 销毁");
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"意见反馈";

    self.navigationItem.rightBarButtonItem = [[GZPublicMethod sharedPublicMethod] barButtonTitle:@"提交" Image:nil Target:self Sel:@selector(commitFun)];
    [self createUI];
}

- (void)createNavi {
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitFun) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.frame = CGRectMake(0, 0, 60, 25);
    [commitBtn setTitleColor:float_Color_button_hightlight forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:commitBtn];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)createUI {

    CGFloat h;
    if (IS_IPHONE_X) {
        h = 20;
    }else {
        h = 0;
    }

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-h)];
    scroll.scrollEnabled = YES;
    scroll.userInteractionEnabled = YES;
    scroll.backgroundColor = [UIColor whiteColor];
    scroll.contentSize = CGSizeMake(0, SCREEN_HEIGHT-h-63);
    scroll.bounces=YES;
    [self.view addSubview:scroll];

    /** 设置意见label */
    UILabel *opinionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50)];
    [opinionLabel setFont:[UIFont systemFontOfSize:13.0]];
    [opinionLabel setText:@"意见反馈(不超过500字)"];
    [opinionLabel setTextAlignment:NSTextAlignmentLeft];
    [scroll addSubview:opinionLabel];

    /** 设置意见内容栏 */
    UITextView *opinionText = [[UITextView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(opinionLabel.frame), SCREEN_WIDTH-20, 150)];
    opinionText.layer.borderWidth = 0.5;
    opinionText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [opinionText setFont:[UIFont systemFontOfSize:14.0]];
    [opinionText setTextColor:[UIColor blackColor]];
    opinionText.returnKeyType = UIReturnKeyDefault;
    opinionText.scrollEnabled=YES;
    opinionText.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    opinionText.delegate = self;
    [scroll addSubview:opinionText];

    //创建联系label
    UILabel *contactLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(opinionText.frame), SCREEN_WIDTH-20, 50)];
    [contactLabel setFont:[UIFont systemFontOfSize:13.0]];
    [contactLabel setText:@"联系方式(可选，不超过50字)"];
    [contactLabel setTextAlignment:NSTextAlignmentLeft];
    [scroll addSubview:contactLabel];

    //创建联系TextField
    UITextField *contactText=[[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(contactLabel.frame), SCREEN_WIDTH-20, 30)];
    contactText.layer.borderWidth = 0.5;
    contactText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [contactText setPlaceholder:@"如邮箱、QQ、手机号码"];
    contactText.font = [UIFont systemFontOfSize:14];
    contactText.backgroundColor=[UIColor whiteColor];
    [scroll addSubview:contactText];
}


#pragma mark -- 点击交互
//提交按钮
- (void)commitFun{
    NSLog(@"提交意见");
}

//文本框输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return YES;
    }
    NSString *opinionString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (opinionString.length > 500) {
        textView.text = [opinionString substringToIndex:500];
        return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString *contactString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (contactString.length > 50) {
        textField.text = [contactString substringToIndex:50];
        return NO;
    }
    return YES;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
