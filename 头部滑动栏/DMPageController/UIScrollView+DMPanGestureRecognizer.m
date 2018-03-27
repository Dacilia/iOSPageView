//
//  UIScrollView+DMPanGestureRecognizer.m
//  头部滑动栏
//
//  Created by 李达志 on 2018/2/28.
//  Copyright © 2018年 LDZ. All rights reserved.
//

#import "UIScrollView+DMPanGestureRecognizer.h"

@implementation UIScrollView (DMPanGestureRecognizer)
#define IPHONE_H [UIScreen mainScreen].bounds.size.height //屏幕的高度
#define IPHONE_W [UIScreen mainScreen].bounds.size.width // 屏幕的宽度
//一句话总结就是此方法返回YES时，手势事件会一直往下传递，不论当前层次是否对该事件进行响应。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;

}

//这个是用来测试以及判断是否返回前一个页面的方法
- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer ==self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state ||UIGestureRecognizerStatePossible == state) {
            if (point.x > 0 && self.contentOffset.x <= 0) {
                return YES;
            }
        }
    }
    return NO;

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;

}

@end
