//
//  GZHomeViewController.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/3.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZHomeViewController.h"
//#import "GZSetHelpController.h"
//#import "GZAboutController.h"
//#import "GZOpinionFeedbackController.h"
//#import "GZUserPhrasesController.h"
//#import "GZKeyboardSettingController.h"
//#import "GZWrightSettingController.h"
//#import <StoreKit/StoreKit.h>


@interface GZHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation GZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";

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

}

//回复默认设置
- (void)resetAll:(UIButton*)sender {

}




#pragma mark -- alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

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
