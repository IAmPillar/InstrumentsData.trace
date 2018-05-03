//
//  GZHomeViewController.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/3.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZHomeViewController.h"
#import "GZSetHelpController.h"
#import "GZAboutController.h"
#import "GZOpinionFeedbackController.h"
#import "GZUserPhrasesController.h"
//#import "GZKeyboardSettingController.h"
#import "GZWrightSettingController.h"
#import <StoreKit/StoreKit.h>


@interface GZHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SKStoreProductViewControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation GZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";

    NSNumber *penW = [[GZUserDefaults shareUserDefaults] getGroupValueForKey:@"penWidth"];
    if (penW == NULL) {
        //如果没有存储过设置，则先设置默认
        [self setDefault];
    }

//    _dataArray = @[@[@"手写设置",@"键盘设置"],@[@"键盘指导",@"使用帮助"],@[@"用户反馈",@"去评分",@"关于"]];
    _dataArray = @[@[@"手写设置"],@[@"快捷短语"],@[@"键盘指导",@"使用帮助"],@[@"用户反馈",@"去评分",@"关于"]];

    [self createTableUI];
}

#pragma mark -- UI
- (void)createTableUI {
    CGFloat h;
    if (IS_IPHONE_X) {
        h = 20;
    }else {
        h = 0;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-h) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [self createFooterUI];
    [self.view addSubview:_tableView];
}

- (UIView*)createFooterUI {
    UIView *superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 88)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 30, SCREEN_WIDTH, 44);
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [button setTitle:@"恢复默认设置" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(resetAll:) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:button];

    return superview;
}


#pragma mark -- 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:{
            if (row == 0) {
                //手写设置
                GZWrightSettingController *wright = [[GZWrightSettingController alloc] init];
                [self.navigationController pushViewController:wright animated:YES];
            }
//            else if (row == 1) {
//                //键盘设置
//                GZKeyboardSettingController *keyboard = [[GZKeyboardSettingController alloc] init];
//                [self.navigationController pushViewController:keyboard animated:YES];
//            }
            else {

            }
            break;
        }
        case 1:{
            //快捷短语
            GZUserPhrasesController *userPhrases = [[GZUserPhrasesController alloc] init];
            [self.navigationController pushViewController:userPhrases animated:YES];
            break;
        }
        case 2:{
            if (row == 0) {
                //键盘指导
                GZSetHelpController *help = [[GZSetHelpController alloc] init];
                help.naviTitle = @"键盘指导";
                help.URLstring = @"setting_keyboard_enable_guide";
                [self.navigationController pushViewController:help animated:YES];
            }else if (row == 1) {
                //使用帮助
                GZSetHelpController *help = [[GZSetHelpController alloc] init];
                help.naviTitle = @"使用帮助";
                help.URLstring = @"setting_help";
                [self.navigationController pushViewController:help animated:YES];
            }else {

            }
            break;
        }
        case 3:{
            if (row == 0) {
                //用户反馈
                GZOpinionFeedbackController *feedBack = [[GZOpinionFeedbackController alloc] init];
                [self.navigationController pushViewController:feedBack animated:YES];
            }else if (row == 1) {
                //去评分
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否打开评价页面？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开", nil];
                alertView.tag = 300;
                [alertView show];
            }else if (row == 2) {
                //关于
                GZAboutController *about = [[GZAboutController alloc] init];
                [self.navigationController pushViewController:about animated:YES];
            }else {

            }
            break;
        }

        default:
            break;
    }
}

//回复默认设置
- (void)resetAll:(UIButton*)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否恢复默认设置？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 200;
    [alertView show];
}




#pragma mark -- alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && alertView.tag == 300) {
        [self openAppWithIdentifier:@"952978988"];
    }

    if (buttonIndex == 1 && alertView.tag == 200) {
        [self setDefault];
    }
}


//默认的设置
- (void)setDefault {

    //初始化快捷短语plist
    GZUserDefaults *userdefaul = [GZUserDefaults shareUserDefaults];
    NSString *isFirstLogin = [userdefaul getValueForKey:@"isFirstLogin"];
    if([isFirstLogin isEqualToString:@"yes"]){
        //第一次启动
        [userdefaul saveValue:@"no" forKey:@"isFirstLogin"];
        GZUserPlist *plist = [GZUserPlist sharedUserPlist];
        [plist initUserPhases];
    }

    //手写设置
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    
    [share saveGroupValue:@1 forKey:@"wrightMode_Vertical"]; //竖屏
    [share saveGroupValue:@2 forKey:@"wrightMode_Horizontal"]; //横屏

    [share saveGroupValue:@1 forKey:@"penWidth"]; //笔画粗细
    [share saveGroupValue:@0 forKey:@"penColorRed"]; //红
    [share saveGroupValue:@0 forKey:@"penColorGreen"]; //绿
    [share saveGroupValue:@0 forKey:@"penColorBlue"]; //蓝
    [share saveGroupValue:@1 forKey:@"penColorAlpha"]; //透明

    [share saveGroupValue:@1 forKey:@"penStyle"]; //1铅笔 2钢笔 3毛笔
}




#pragma mark -- 评价
- (void)openAppWithIdentifier:(NSString *)appId {

    if ([SKStoreProductViewController class] != nil) {
        SKStoreProductViewController *skpvc = [[SKStoreProductViewController alloc] init];
        skpvc.delegate = self;
        NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey: SKStoreProductParameterITunesItemIdentifier];
        [skpvc loadProductWithParameters:dict completionBlock:nil];
        [self.navigationController presentViewController:skpvc animated:YES completion:nil];
    }
    else {
        static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
        static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
        NSString *url = [[NSString alloc] initWithFormat: ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) ? iOS7AppStoreURLFormat : iOSAppStoreURLFormat, appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    //    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    //    storeProductVC.delegate = self;
    //    __weak GZSettingViewController *weakSelf = self;
    //    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"940489630" forKey:SKStoreProductParameterITunesItemIdentifier];
    //    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
    //        if (error) {
    //            NSLog(@"%@",error.localizedDescription);
    //        }
    //        if (result) {
    //            [weakSelf presentViewController:storeProductVC animated:YES completion:nil];
    //        }
    //    }];
}
//按取消按钮Cancel返回所调用代理方法,此处返回到ViewController控制器
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)storeProductVC {
    [storeProductVC dismissViewControllerAnimated:YES completion:^{
        [storeProductVC removeFromParentViewController];
    }];
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
