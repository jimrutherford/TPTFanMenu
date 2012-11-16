//
//  TPTViewController.m
//  FanMenu
//
//  Created by Jim Rutherford on 2012-11-03.
//  Copyright (c) 2012 Jim Rutherford. All rights reserved.
//

#import "TPTViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TPTViewController ()

@end

@implementation TPTViewController

@synthesize pin_1;

- (void)viewDidLoad
{
    [super viewDidLoad];


    pin_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin_1"]];
    [self.view addSubview:pin_1];
    pin_1.layer.position = CGPointMake(self.view.center.x, self.view.center.y);
    pin_1.layer.anchorPoint = CGPointMake(0.5,1);
    pin_1.layer.opacity = 0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)goButton:(id)sender {

    pin_1.layer.opacity = 1;
    [pin_1.layer addAnimation:[self shrinkAnimation] forKey:@"idunno"];

}


- (CAAnimationGroup *)shrinkAnimation
{

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, .1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];

    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:scaleAnimation, nil];
    animationgroup.duration = 0.2f;
    animationgroup.fillMode = kCAFillModeForwards;

    return animationgroup;
}




@end
