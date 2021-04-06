//
//  ZYBubblePopView.h
//  ZYDrawImage
//
//  Created by zhenyu on 2021/2/20.
//  Copyright © 2021 zhenyu. All rights reserved.
//  气泡控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 气泡箭头的方向
typedef NS_ENUM(NSInteger, ZYBubbleDirection){
    ZYBubbleDirectionUp,     // 上
    ZYBubbleDirectionRight,  // 右
    ZYBubbleDirectionDown,   // 下
    ZYBubbleDirectionLeft    // 左
};

@interface ZYBubblePopView : UIView
/// 气泡箭头的方向
@property (nonatomic, assign) ZYBubbleDirection direction;
/// 箭头高度
@property (nonatomic, assign) CGFloat triangleHeight;
/// 箭头宽度
@property (nonatomic, assign) CGFloat triangleWidth;

/// 圆角radius
@property (nonatomic, assign) CGFloat borderRadius;
/// 画笔颜色
@property (nonatomic, strong) UIColor *strokeColor;
/// 背景填充颜色
@property (nonatomic, strong) UIColor *fillColor;

- (instancetype)initWithFrame:(CGRect)frame triangleTopRatio:(CGFloat)triangleTopRatio;

/// 显示
- (void)showWithAnimation:(BOOL)animation completion:(void (^ __nullable)(BOOL finished))completion;

/// 隐藏
- (void)hideWithAnimation:(BOOL)animation completion:(void (^ __nullable)(BOOL finished))completion;


@end

NS_ASSUME_NONNULL_END
