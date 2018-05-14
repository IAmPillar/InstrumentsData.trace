//
//  GZAboutController.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/14.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZAboutController.h"
#import "GZSetHelpController.h"

@interface GZAboutController ()

@end

@implementation GZAboutController

- (void)dealloc {
    NSLog(@"关于页面 销毁");
    for (UIView *view in self.view.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"关于";

    [self createUI];
}

- (void)createUI {

    CGFloat h;
    if (IS_IPHONE_X) {
        h = 20;
    }else {
        h = 0;
    }

    //创建scrollView
    UIScrollView *aboutScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-h)];
    aboutScroll.scrollEnabled = YES;
    aboutScroll.userInteractionEnabled = YES;
    aboutScroll.backgroundColor = RGBA(244, 244, 244, 1);
    aboutScroll.contentSize = CGSizeMake(0, SCREEN_HEIGHT-h-63);
    aboutScroll.bounces = YES;
    [self.view addSubview:aboutScroll];

    //创建Logo图片
    UIView *LogoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.3 * SCREEN_HEIGHT)];
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 72, 72)];
    logoImageView.center = LogoView.center;
    logoImageView.image = [UIImage imageNamed:@"appIcon"];
    [LogoView addSubview:logoImageView];

    //创建输入法名称
    CGFloat labelY = CGRectGetMaxY(logoImageView.frame);
    UILabel *hanvonLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, labelY, SCREEN_WIDTH, 30)];
    [hanvonLabel setFont:[UIFont systemFontOfSize:15.0]];
    [hanvonLabel setTextAlignment:NSTextAlignmentCenter];
    [hanvonLabel setText:@"汉王输入法"];
    [LogoView addSubview:hanvonLabel];

    //创建版本label
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    //NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    //NSString *bundle = infoDic[@"CFBundleIdentifier"]; //版本
    NSString *build = infoDic[@"CFBundleVersion"]; //build
    labelY = CGRectGetMaxY(LogoView.frame);
    UILabel *VersionLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, labelY, SCREEN_WIDTH, 30)];
    [VersionLabel setFont:[UIFont systemFontOfSize:15.0]];
    [VersionLabel setTextAlignment:NSTextAlignmentCenter];
    [VersionLabel setText:[NSString stringWithFormat:@"版本%@ @2017",build]];

    //创建隐私button
    labelY = CGRectGetMaxY(VersionLabel.frame);
    UIButton *AgreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    AgreementBtn.frame = CGRectMake(0, labelY, SCREEN_WIDTH, 30);
    [AgreementBtn setTitle:@"用户协议" forState:UIControlStateNormal];
    [AgreementBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [AgreementBtn addTarget:self action:@selector(toAgreenController) forControlEvents:UIControlEventTouchUpInside];


    [aboutScroll addSubview:AgreementBtn];
    [aboutScroll addSubview:LogoView];
    [aboutScroll addSubview:VersionLabel];
}

- (void)toAgreenController{
    GZSetHelpController *help = [[GZSetHelpController alloc] init];
    help.naviTitle = @"用户协议";
    help.URLstring = @"setting_user_agreement";
    [self.navigationController pushViewController:help animated:YES];
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
