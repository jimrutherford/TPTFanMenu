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

@synthesize pins;
@synthesize totalPins;

- (void)viewDidLoad
{
    [super viewDidLoad];

	totalPins = 4;
	pins = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < totalPins; i++)
	{
		NSString* pinName = [NSString stringWithFormat:@"pin_%i", i+1];
		NSLog(@"%@", pinName);
		UIImageView * pin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:pinName]];
		pin.layer.position = CGPointMake(self.view.center.x, self.view.center.y);
		pin.layer.transform = CATransform3DMakeScale(.01, .01, .1);
		pin.layer.anchorPoint = CGPointMake(0.5,1);
		[pins addObject:pin];
		[self.view addSubview:pin];
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)goButton:(id)sender {
	for (int i = 0; i < totalPins; i++)
	{
		NSLog(@"%i", i);
		UIImageView * pin = [pins objectAtIndex:i];
		[pin.layer addAnimation:[self shrinkAnimationWithDelay:i] forKey:@"transform"];
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
	animationgroup.beginTime = CACurrentMediaTime() + (delay * startOffset);
    animationgroup.fillMode = kCAFillModeForwards;
	animationgroup.removedOnCompletion = NO;
    return animationgroup;
}




@end
