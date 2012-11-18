//
//  TPTViewController.m
//  FanMenu
//
//  Created by Jim Rutherford on 2012-11-03.
//  Copyright (c) 2012 Jim Rutherford. All rights reserved.
//

#define DEGREES_TO_RADIANS( degrees ) ( ( degrees ) / 180.0 * M_PI )

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
		// lets tag this in case we need to inspect it later
		pin.tag = i;
		
		pin.layer.shadowColor = [UIColor blackColor].CGColor;
		pin.layer.shadowOffset = CGSizeMake(2, 2);
		pin.layer.shadowRadius = 3;
		pin.layer.shadowOpacity = 0.4f;

		pin.clipsToBounds = NO;
		
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
		UIImageView * pin = [pins objectAtIndex:i];
		[pin.layer addAnimation:[self shrinkAnimationWithDelay:i] forKey:@"transform"];
	}
	
}


- (CAAnimationGroup *)shrinkAnimationWithDelay:(int)delay
{
	CGFloat startOffset = 0.1f;
	
	NSString *animationKeyPath = [NSString stringWithFormat:@"transform%i", delay];
	NSLog(@"animationKeyPath - %@", animationKeyPath);
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, .1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
	scaleAnimation.duration = 0.3f;
	scaleAnimation.beginTime = (delay * startOffset);
	//scaleAnimation.delegate = self;
	scaleAnimation.removedOnCompletion = NO;
	scaleAnimation.fillMode = kCAFillModeForwards;
	
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:scaleAnimation, nil];
    animationgroup.duration = 0.7f;
	animationgroup.removedOnCompletion = NO;
	animationgroup.fillMode = kCAFillModeForwards;
	animationgroup.delegate = self;
	[animationgroup setValue:animationKeyPath forKey:@"TPTAnimationType"];
	return animationgroup;
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	NSString* value = [anim valueForKey:@"TPTAnimationType"];

	if ([value isEqualToString:@"transform0"])
	{
		
		NSArray *keyframes = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(0)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(90)], nil];		
		
		UIImageView * pin = [pins objectAtIndex:0];
		[pin.layer addAnimation:[self rotationAnimationWithKeyFrames:keyframes] forKey:@"transform.rotation.z"];
	}
	
	if ([value isEqualToString:@"transform1"])
	{
		
		NSArray *keyframes = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(0)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(90)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180)], nil];

		UIImageView * pin = [pins objectAtIndex:1];
		[pin.layer addAnimation:[self rotationAnimationWithKeyFrames:keyframes] forKey:@"transform.rotation.z"];
	}

	
	if ([value isEqualToString:@"transform2"])
	{
		
		NSArray *keyframes = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(0)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(90)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(270)], nil];
		
		UIImageView * pin = [pins objectAtIndex:2];
		[pin.layer addAnimation:[self rotationAnimationWithKeyFrames:keyframes] forKey:@"transform.rotation.z"];
	}
	
	if ([value isEqualToString:@"transform3"])
	{
		
		NSArray *keyframes = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(0)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(90)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(270)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(360)], nil];

		UIImageView * pin = [pins objectAtIndex:3];
		[pin.layer addAnimation:[self rotationAnimationWithKeyFrames:keyframes] forKey:@"transform.rotation.z"];
	}
}

- (CAAnimationGroup*) rotationAnimationWithKeyFrames:(NSArray*)keyFrames
{
	CAKeyframeAnimation *rotationAnimation;
	rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
	
	rotationAnimation.values = keyFrames;
	rotationAnimation.calculationMode = kCAAnimationPaced;
	
	rotationAnimation.duration = 0.3f;
	//rotationAnimation.beginTime = 1.0f;
	rotationAnimation.removedOnCompletion = NO;
	rotationAnimation.fillMode = kCAFillModeForwards;
	
	rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
	animationgroup.animations = [NSArray arrayWithObjects:rotationAnimation, nil];
	animationgroup.duration = 1.3f;
	animationgroup.removedOnCompletion = NO;
	animationgroup.fillMode = kCAFillModeForwards;
	
	return animationgroup;
}

@end
