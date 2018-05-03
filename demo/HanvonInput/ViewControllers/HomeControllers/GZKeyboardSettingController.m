//
//  GZKeyboardSettingController.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/14.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZKeyboardSettingController.h"
#import "GZSwitchCell.h"


@interface GZKeyboardSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSMutableArray *switchStatus; //开关状态
@end

@implementation GZKeyboardSettingController

- (void)dealloc {
    NSLog(@"键盘设置 销毁");
    if (_tableView) {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    if (_switchStatus) {
        [_switchStatus removeAllObjects];
        _switchStatus = nil;
    }
    if (_dataArr) {
        _dataArr = nil;
    }
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //重新存储新的设置
//    NSArray *key = [NSArray arrayWithObjects:@"chineseAssociation",@"nightMode",@"sound",@"shock", nil];
//    for (int i=0; i<_switchStatus.count; i++) {
//        [GZUserDefaults saveGroupValue:[_switchStatus objectAtIndex:i] forKey:key[i]];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"键盘设置";

    [self getSwitchesStatus];
    _dataArr = [NSArray arrayWithObjects:@"中文联想",@"夜间模式",@"声音",@"震动", nil];

    [self createUI];
}

//获取设置
- (void)getSwitchesStatus {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];

    NSNumber *chineseAssociation = [share getGroupValueForKey:@"chineseAssociation"]; //中文联想
    NSNumber *nightMode = [share getGroupValueForKey:@"nightMode"]; //0日间模式 1夜间模式
    NSNumber *sound = [share getGroupValueForKey:@"sound"]; //声音
    NSNumber *shock = [share getGroupValueForKey:@"shock"]; //震动
    _switchStatus = [[NSArray arrayWithObjects:chineseAssociation,nightMode,sound,shock, nil] mutableCopy];
}
//创建UI
- (void)createUI {
    CGFloat h;
    if (IS_IPHONE_X) {
        h = 20;
    }else {
        h = 0;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-h) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"switchSettingCell";
    GZSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GZSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

    cell.title.text = [_dataArr objectAtIndex:indexPath.row];
    NSNumber *status = [_switchStatus objectAtIndex:indexPath.row];
    if ([status isEqualToNumber:@0]) {
        [cell.switchButton setOn:NO];
    }else if ([status isEqualToNumber:@1]) {
        [cell.switchButton setOn:YES];
    }else {

    }

    __weak GZKeyboardSettingController *weakSelf = self;
    cell.sendSwitch = ^(BOOL isOpen) {
        NSNumber *new;
        if (isOpen) {
            new = @1;
        }else {
            new = @0;
        }

        [weakSelf.switchStatus replaceObjectAtIndex:indexPath.row withObject:new]; //更改数组
        //存储设置
        NSArray *key = [NSArray arrayWithObjects:@"chineseAssociation",@"nightMode",@"sound",@"shock", nil];
        [[GZUserDefaults shareUserDefaults] saveGroupValue:[_switchStatus objectAtIndex:indexPath.row] forKey:key[indexPath.row]];
    };

    return cell;
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
