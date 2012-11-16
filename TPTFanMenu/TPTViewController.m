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
@synthesize pin_2;
@synthesize pins;

- (void)viewDidLoad
{
    [super viewDidLoad];

	
    pin_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin_1"]];
    pin_1.layer.position = CGPointMake(self.view.center.x, self.view.center.y);
	pin_1.layer.transform = CATransform3DMakeScale(.01, .01, .1);
    pin_1.layer.anchorPoint = CGPointMake(0.5,1);

	pin_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin_2"]];
    pin_2.layer.position = CGPointMake(self.view.center.x, self.view.center.y);
	pin_2.layer.transform = CATransform3DMakeScale(.01, .01, .1);
    pin_2.layer.anchorPoint = CGPointMake(0.5,1);
	
	pins = [[NSArray alloc] initWithObjects:pin_1, pin_2, nil];
	
	for (UIImageView* pin in pins)
	{
		[self.view addSubview:pin];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)goButton:(id)sender {
	for (UIImageView* pin in pins)
	{
		[pin.layer addAnimation:[self shrinkAnimationWithDelay:1] forKey:@"transform"];
	}
	
}


- (CAAnimationGroup *)shrinkAnimationWithDelay:(int)delay
{
	CGFloat startOffset = 0.1f;
	
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, .1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];

    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:scaleAnimation, nil];
    animationgroup.duration = 0.3f;
	animationgroup.beginTime = CACurrentMediaTime() + ((delay - 1) * startOffset);
    animationgroup.fillMode = kCAFillModeForwards;
	animationgroup.removedOnCompletion = NO;
    return animationgroup;
}




@end
