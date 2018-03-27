//
//  ViewController.m
//  头部滑动栏
//
//  Created by 李达志 on 2018/2/11.
//  Copyright © 2018年 LDZ. All rights reserved.
//

#import "ViewController.h"
#import "TestController.h"
#import "TestPageViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel*label=[[UILabel alloc]init];
    label.text=@"该Demo集合了全屏返回手势，以及暂时解决UIScrollView和全屏返回手势冲突的问题，支持高度自定义，希望大家提出意见";
    label.numberOfLines=0;
    label.textColor=[UIColor lightGrayColor];
    label.font=[UIFont systemFontOfSize:20];
    label.frame=CGRectMake(0, 50, 200, 200);
    label.center=self.view.center;
    [self.view addSubview:label];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController pushViewController:[TestPageViewController new] animated:YES];
}




@end
