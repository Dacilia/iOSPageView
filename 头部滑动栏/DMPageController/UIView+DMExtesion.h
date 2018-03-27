//
//  UIView+DMExtesion.h
//  头部滑动栏
//
//  Created by 李达志 on 2018/2/12.
//  Copyright © 2018年 LDZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DMExtesion)
#pragma mark - UIView原有
@property (nonatomic,assign) CGFloat ng_x;
@property (nonatomic,assign) CGFloat ng_y;
@property (nonatomic,assign) CGFloat ng_width;
@property (nonatomic,assign) CGFloat ng_height;
@property (nonatomic,assign) CGPoint ng_origin;
@property (nonatomic,assign) CGSize  ng_size;

#pragma mark - UIView扩展
@property (nonatomic,assign) CGFloat ng_left;
@property (nonatomic,assign) CGFloat ng_top;
@property (nonatomic,assign) CGFloat ng_right;
@property (nonatomic,assign) CGFloat ng_bottom;
@property (nonatomic,assign) CGFloat ng_centerX;
@property (nonatomic,assign) CGFloat ng_centerY;
@end
