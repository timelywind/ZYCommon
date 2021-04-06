//
//  UIImage+zyImage.h
//  ZYCommon
//
//  Created by zhenyu on 2019/7/16.
//  Copyright © 2019 zhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (zyImage)

- (UIImage *)imageRotation:(UIImageOrientation)orientation;
- (UIImage*)rotate:(UIImageOrientation)orient;

@end

NS_ASSUME_NONNULL_END
