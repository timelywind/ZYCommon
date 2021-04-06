//
//  ZYBubblePopView.m
//  ZYDrawImage
//
//  Created by zhenyu on 2021/2/20.
//  Copyright © 2021 zhenyu. All rights reserved.
//

#import "ZYBubblePopView.h"

@interface ZYBubblePopView ()
/// 箭头的位置 (宽度的百分比，取值为0-1)
@property (nonatomic, assign) CGFloat triangleTopRatio;

@end

@implementation ZYBubblePopView

- (instancetype)initWithFrame:(CGRect)frame triangleTopRatio:(CGFloat)triangleTopRatio {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        // 默认设置
        _triangleHeight = 10.f;  // 箭头高度
        _triangleWidth = 14.f;   // 箭头宽度
        _borderRadius = 5;       // 圆角
        _triangleTopRatio = triangleTopRatio > 0 ? triangleTopRatio : 0.2;
        _strokeColor = [UIColor grayColor];
        _fillColor = [UIColor whiteColor];
        _direction = ZYBubbleDirectionUp;
        [self configAnchorPoint];
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGRect bubbleRect = rect;
    if (_direction == ZYBubbleDirectionLeft || _direction == ZYBubbleDirectionRight) {
        bubbleRect = CGRectMake(0, 0, rect.size.height, rect.size.width);
    }
    
    CGFloat viewW = bubbleRect.size.width;
    CGFloat viewH = bubbleRect.size.height;
    
    CGFloat triangleHeight = _triangleHeight;  // 箭头高度
    CGFloat triangleWidth = _triangleWidth;   // 箭头宽度
    CGFloat borderRadius = _borderRadius;  // 圆角
    CGFloat strokeWidth = 1.f / [UIScreen mainScreen].scale;  // 线的宽度
    CGFloat triangleTopPointX = viewW * (_direction == ZYBubbleDirectionDown ? (1 - _triangleTopRatio) : _triangleTopRatio);  // 箭头的x
    CGFloat padding = 0.f;  // 四周边距
    CGFloat margin = strokeWidth + padding;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 做CTM变换
    [self contextChangeCTMWithDirection:_direction context:context];
    
    CGContextSetLineJoin(context, kCGLineJoinRound); //
    CGContextSetLineWidth(context, strokeWidth); // 设置画笔宽度
    CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor); // 设置画笔颜色
    CGContextSetFillColorWithColor(context, _fillColor.CGColor); // 设置填充颜色
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, borderRadius + margin, triangleHeight + margin);
    CGContextAddLineToPoint(context, triangleTopPointX - triangleWidth / 2.0 + margin, triangleHeight + margin);
    CGContextAddLineToPoint(context, triangleTopPointX + margin, margin);
    CGContextAddLineToPoint(context, triangleTopPointX + triangleWidth / 2.0 + margin, triangleHeight + margin);
    
    CGContextAddArcToPoint(context, viewW - margin, triangleHeight + margin, viewW - margin, triangleHeight + margin + borderRadius, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context, viewW - margin, viewH - margin, viewW - borderRadius - margin, viewH - margin, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context, margin, viewH - margin, margin, viewH - borderRadius - margin, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context, margin, triangleHeight + margin, viewW - borderRadius - margin, triangleHeight + margin, borderRadius - strokeWidth);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

/// 做CTM变换
- (void)contextChangeCTMWithDirection:(ZYBubbleDirection)direction context:(CGContextRef)context {
    if (direction == ZYBubbleDirectionUp) {
        return;
    }
    CGRect rect = self.bounds;
    long double rotate = 0.0;
    float translateX = 0;
    float translateY = 0;

    switch (direction) {
        case ZYBubbleDirectionRight:
            rotate = M_PI_2;
            translateX = 0;
            translateY = -rect.size.width;
            break;
        case ZYBubbleDirectionLeft:
            rotate = 3 * M_PI_2;
            translateX = -rect.size.height;
            translateY = 0;
            break;
        case ZYBubbleDirectionDown:
            rotate = M_PI;
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            translateX = 0;
            translateY = 0;
            break;
    }
    
    // 做CTM变换
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
}

- (void)setDirection:(ZYBubbleDirection)direction {
    _direction = direction;
    
    [self configAnchorPoint];
}

/// 设置锚点
- (void)configAnchorPoint {
    CGPoint anchorPoint = CGPointMake(self.triangleTopRatio, 0);
    switch (_direction) {
        case ZYBubbleDirectionRight:
            anchorPoint = CGPointMake(1, self.triangleTopRatio);
            break;
        case ZYBubbleDirectionLeft:
            anchorPoint = CGPointMake(0, 1 - self.triangleTopRatio);
            break;
        case ZYBubbleDirectionDown:
            anchorPoint = CGPointMake(self.triangleTopRatio, 1);
            break;
        default:
            break;
    }
    CGPoint lastAnchorPoint = self.layer.anchorPoint;
    self.layer.anchorPoint = anchorPoint;
    CGRect rect = self.frame;
    rect.origin.x -= (lastAnchorPoint.x - anchorPoint.x) * rect.size.width;
    rect.origin.y -= (lastAnchorPoint.y - anchorPoint.y) * rect.size.height;
    self.frame = rect;
}

/// 显示
- (void)showWithAnimation:(BOOL)animation completion:(void (^ __nullable)(BOOL finished))completion {
    self.hidden = NO;
    self.alpha = 0.1;
    if (!animation) {
        self.transform = CGAffineTransformMakeScale(1, 1);
    } else {
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 1.0;
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:completion];
}

/// 隐藏
- (void)hideWithAnimation:(BOOL)animation completion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 0.1;
        if (animation) {
            self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
    } completion:^(BOOL finish){
        self.hidden = YES;
        if (completion) {
            completion(finish);
        }
    }];
}

@end
