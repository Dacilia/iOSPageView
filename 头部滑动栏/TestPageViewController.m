//
//  TestPageViewController.m
//  头部滑动栏
//
//  Created by 李达志 on 2018/2/28.
//  Copyright © 2018年 LDZ. All rights reserved.
//

#import "TestPageViewController.h"
#import "DMPageContainController.h"
#import "TestController.h"
@interface TestPageViewController ()
@property (nonatomic,strong) DMPageContainController*pageVc;
@end

@implementation TestPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    TestController*vc1=[TestController new];
    TestController*vc2=[TestController new];
    TestController*vc3=[TestController new];
    TestController*vc4=[TestController new];
    TestController*vc5=[TestController new];
    TestController*vc6=[TestController new];
    TestController*vc7=[TestController new];
    TestController*vc8=[TestController new];
    self.pageVc=[DMPageContainController dmPageContainControllerWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) dmPageControlViewHeight:40 dmTopSpace:0 titles:@[@"iOS开发工程师",@"JAVA开发",@"安卓开发工程师",@"PHP开发源",@"高级开发工程师",@"无敌厉害开发工程师",@"小程序开发",@"HTML5开发"] dmPageControlViewStyle:DMPageControlViewStyle_TitleBox];
    self.pageVc.viewControllers=@[vc1,vc2,vc3,vc4,vc5,vc6,vc7,vc8];
    [self addSegmentController:self.pageVc];
    [self.pageVc setSelectedAtIndex:0];
}



@end
