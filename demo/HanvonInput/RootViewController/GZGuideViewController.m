//
//  GZGuideViewController.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/3.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZGuideViewController.h"
#import "GZHomeViewController.h"
#import "GZRootNavigationController.h"

@interface GZGuideViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scroll;
    UIPageControl * pageCtr;
}

@end

@implementation GZGuideViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(238, 227, 204, 1);
    [self goGuide];
}

- (void)goGuide
{
    NSArray *arr = @[@"guide_1",@"guide_2",@"guide_3",@"guide_4"];
    int num = (int)arr.count;

    //计算图片宽高
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide_1"] ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    CGSize imageSize = image.size;
    double ratio = imageSize.height/imageSize.width;
    double width = SCREEN_WIDTH;
    double height = width*ratio;

    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-height)/2.0, width, height)];
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH*num,height);
    scroll.contentOffset = CGPointMake(0, 0);
    scroll.bounces = NO;
    scroll.showsHorizontalScrollIndicator = NO; //水平
    scroll.showsVerticalScrollIndicator = NO; //垂直
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    scroll.backgroundColor = RGBA(238, 227, 204, 1);
    [self.view addSubview:scroll];

    for (int i=0; i<num; i++){
        NSString * imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide_%d",i+1] ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
        [imageView setImage:image];
        if (i==num-1){
            imageView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goActionShow)];
            [imageView addGestureRecognizer:tap];
        }
        [scroll addSubview:imageView];
    }

    double pageHeight = coordinate_Y(20);
    pageCtr = [[UIPageControl alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT+height)/2.0-coordinate_Y(125)-pageHeight, SCREEN_WIDTH, pageHeight)];
    pageCtr.currentPage = 0;
    pageCtr.numberOfPages = arr.count;
    pageCtr.pageIndicatorTintColor = [UIColor cyanColor];
    pageCtr.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:pageCtr];
}

- (void)goActionShow
{
    GZHomeViewController *root = [[GZHomeViewController alloc] init];
    GZRootNavigationController *rnvc = [[GZRootNavigationController alloc] initWithRootViewController:root];
    self.view.window.rootViewController = rnvc;
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageCtr.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
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
