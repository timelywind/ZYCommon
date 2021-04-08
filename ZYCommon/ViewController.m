//
//  ViewController.m
//  ZYCommon
//
//  Created by zhenyu on 2019/7/16.
//  Copyright © 2019 zhenyu. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+zyImage.h"
#import "ZYRuntime.h"
#import "ZYTestView.h"

@interface ViewController ()
{
//    UIViewController *_tempView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _tempView = [[ZYTestView alloc] init];
//
//    [self test1];
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [_tempView navigationController];
    
//    NSLog(@"\n%s\n%s", _cmd, __func__);
}

- (void)test1 {
    
    UIImage *image1 = [UIImage imageNamed:@"zy_test1"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, image1.size.width, image1.size.height)];
    [self.view addSubview:imageView1];
    imageView1.image = image1;
//    imageView1.transform = CGAffineTransformMakeRotation(<#CGFloat angle#>);
    
    UIImage *image2 = [image1 rotate:UIImageOrientationDownMirrored];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(imageView1.frame) + 1, image2.size.width, image2.size.height)];
    [self.view addSubview:imageView2];
    imageView2.image = image2;
    
}


@end
