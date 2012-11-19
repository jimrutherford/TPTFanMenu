//
//  TPTFanMenu.m
//  TPTFanMenu
//
//  Created by James Rutherford on 2012-11-18.
//  Copyright (c) 2012 Jim Rutherford. All rights reserved.
//

#import "TPTFanMenu.h"
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS( degrees ) ( ( degrees ) / 180.0 * M_PI )

@implementation TPTFanMenu

@synthesize pins;
@synthesize totalPins;
@synthesize isMenuVisible;

bool isMenuGrowing;

typedef enum 
{
	kForwards = 1,
	kBackwards = -1
} direction;


- (id)init
{
    self = [super init];
    if (self) {
        [self drawPins];
    }
    return self;
}

- (void) drawPins
{
	totalPins = 4;
	pins = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < totalPins; i++)
	{
		NSString* pinName = [NSString stringWithFormat:@"pin_%i", i+1];
		NSLog(@"%@", pinName);
		UIImageView * pin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:pinName]];
		pin.layer.position = CGPointMake(self.center.x, self.center.y);
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
		[self addSubview:pin];
	}
	isMenuVisible = NO;
}


/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) showMenu:(id)sender {
	isMenuGrowing = YES;
	
	for (int i = 0; i < totalPins; i++)
	{
		UIImageView * pin = [pins objectAtIndex:i];
		[pin.layer addAnimation:[self growAnimationWithIndex:i] forKey:@"transform"];
	}
	isMenuVisible = YES;
}

- (void) hideMenu:(id)sender {
	isMenuGrowing = NO;
	
	for (int i = 0; i < totalPins; i++)
	{
		UIImageView * pin = [pins objectAtIndex:i];
		[pin.layer addAnimation:[self collapsePinsWithIndex:i] forKey:@"transform.rotation.z"];
	}
	
	isMenuVisible = NO;
}

// following two methods need to be refactored - mostly duplicate code
- (CAAnimationGroup *)growAnimationWithIndex:(int)index
{
	CGFloat startOffset = 0.1f;
	
	NSString *animationKeyPath = [NSString stringWithFormat:@"transform%i", index];
	NSLog(@"animationKeyPath - %@", animationKeyPath);
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, .1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
	scaleAnimation.duration = 0.3f;
	scaleAnimation.beginTime = (index * startOffset);
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

- (CAAnimationGroup *)shrinkAnimationWithIndex:(int)index
{
	CGFloat startOffset = 0.1f;
	CGFloat animDuration = 0.3f;
	
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, .1)];
	scaleAnimation.duration = animDuration + (abs(index - totalPins + 1) * startOffset);
	scaleAnimation.removedOnCompletion = NO;
	scaleAnimation.fillMode = kCAFillModeForwards;
	
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:scaleAnimation, nil];
    animationgroup.duration = animDuration + (totalPins * startOffset);
	animationgroup.removedOnCompletion = NO;
	animationgroup.fillMode = kCAFillModeForwards;
	return animationgroup;
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	
	if (isMenuGrowing) {
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
	else
	{
		for (int i = 0; i < totalPins; i++)
		{
			NSLog(@"shrinking %i", i);
			UIImageView * pin = [pins objectAtIndex:i];
			[pin.layer addAnimation:[self shrinkAnimationWithIndex:i] forKey:@"transform"];
		}
	}
}


-(CAAnimationGroup*) collapsePinsWithIndex:(int)index
{
	NSArray *keyframes;
	
	if (index == 0)
	{
		
		keyframes = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(90)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(80)], nil];
	}
	else if (index == 1)
	{
		
		keyframes = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(90)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(60)], nil];
	}
	else if (index == 2)	{
		
		keyframes = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(270)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(90)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(40)], nil];
	}
	else if (index == 3)
	{
		
		keyframes = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(360)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(270)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(90)],
							  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(20)], nil];
	}
	
	CAAnimationGroup *rotationAnimation = [self rotationAnimationWithKeyFrames:keyframes];
	
	// we only need to be  notified of the animation ending from one pin
	// as they all end at the same time.  We only need to respond to one of these.
	// Need to find a better way to handle this
	if (index == 0)
	{
		rotationAnimation.delegate = self;
	}
	
	return rotationAnimation;
}




- (CAAnimationGroup*) rotationAnimationWithKeyFrames:(NSArray*)keyFrames
{
	CAKeyframeAnimation *rotationAnimation;
	rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
	
	rotationAnimation.values = keyFrames;
	rotationAnimation.calculationMode = kCAAnimationPaced;
	
	rotationAnimation.duration = 0.3f;
	rotationAnimation.removedOnCompletion = NO;
	rotationAnimation.fillMode = kCAFillModeForwards;
	
	rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
	animationgroup.animations = [NSArray arrayWithObjects:rotationAnimation, nil];
	animationgroup.duration = 0.3f;
	animationgroup.removedOnCompletion = NO;
	animationgroup.fillMode = kCAFillModeForwards;
	
	return animationgroup;
}


@end
