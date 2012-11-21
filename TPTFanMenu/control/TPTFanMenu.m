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

#define DEGREES_0   [NSNumber numberWithFloat:( 0 / 180.0 * M_PI )]
#define DEGREES_45   [NSNumber numberWithFloat:( 45 / 180.0 * M_PI )]
#define DEGREES_NEG_45   [NSNumber numberWithFloat:(( 45 / 180.0 * M_PI ) * -1)]
#define DEGREES_90   [NSNumber numberWithFloat:( 90  / 180.0 * M_PI )]
#define DEGREES_NEG_90   [NSNumber numberWithFloat:(( 90 / 180.0 * M_PI ) * -1)]
#define DEGREES_180   [NSNumber numberWithFloat:( 180  / 180.0 * M_PI )]
#define DEGREES_270   [NSNumber numberWithFloat:( 270  / 180.0 * M_PI )]
#define DEGREES_360   [NSNumber numberWithFloat:( 360  / 180.0 * M_PI )]

@implementation TPTFanMenu

@synthesize pins;
@synthesize menuItemImages;
@synthesize delegate;

@synthesize isMenuVisible;

bool isMenuGrowing;

- (id)init
{
    self = [super init];
    if (self) {
        [self drawPins];
		
		self.userInteractionEnabled = YES;
		
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOffset = CGSizeMake(2, 2);
		self.layer.shadowRadius = 3;
		self.layer.shadowOpacity = 0.4f;
		
		self.clipsToBounds = NO;
		
		self.alpha = 0;
    }
    return self;
}


- (void) drawPins
{
	pins = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [menuItemImages count]; i++)
	{	
		UIButton *pin = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *pinImage = [menuItemImages objectAtIndex:i];
		
		pin.frame = CGRectMake(0,0, pinImage.size.width, pinImage.size.height);
        [pin setImage:[menuItemImages objectAtIndex:i] forState:UIControlStateNormal];
		[pin addTarget:self action:@selector(tapMenuItem:) forControlEvents:UIControlEventTouchUpInside];
		[pin setSelected:NO];
		pin.layer.position = CGPointMake(self.center.x, self.center.y);
		pin.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
		pin.layer.anchorPoint = CGPointMake(0.5,1);
		// lets tag this so we can inspect the index of the tapped menuItem from our delegate method
		pin.tag = i;
		
		[pins addObject:pin];
		[self addSubview:pin];
	}
	isMenuVisible = NO;
}

- (void)tapMenuItem:(id)sender
{
	NSLog(@"tapped from inside control");
	// fire off delegate method
	SEL didPressMenuItemSelector = @selector(didPressMenuItem:);
	if (self.delegate && [self.delegate respondsToSelector:didPressMenuItemSelector]) {
		[self.delegate didPressMenuItem:(UIButton*)sender];
	}
	
	[self hideMenu];
}

/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark -
#pragma mark Showing Menu

- (void) showMenu {
	isMenuGrowing = YES;
	self.alpha = 1;
	
	for (int i = 0; i < [menuItemImages count]; i++)
	{
		UIImageView * pin = [pins objectAtIndex:i];
		// reset the transform so they are ready to begin the animation from a known state
		pin.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 0, 0, 1.0f);
		pin.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
		
		[pin.layer addAnimation:[self growAnimationWithIndex:i] forKey:@"transform"];
	}
	isMenuVisible = YES;
}

// following two methods need to be refactored - mostly duplicate code
- (CAAnimationGroup *)growAnimationWithIndex:(int)index
{
	CGFloat startOffset = 0.1f;
	
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
	[animationgroup setValue:[NSNumber numberWithInt:index] forKey:@"TPTAnimationType"];
	return animationgroup;
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	int index = [[anim valueForKey:@"TPTAnimationType"] intValue];
	
	if (isMenuGrowing) {
		NSArray *keyframes = [self getKeyFramesForNumberOfMenuItems:[menuItemImages count] withIndex:index];
		
		if (keyframes != nil)
		{
			UIImageView * pin = [pins objectAtIndex:index];
			
			[CATransaction begin];
			[pin.layer addAnimation:[self rotationAnimationWithKeyFrames:keyframes] forKey:@"transform.rotation.z"];
			[CATransaction setCompletionBlock:^(void){pin.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(180), 0, 0, 1.0f);}];
			[CATransaction commit];
		}
	}
	else
	{
		if (index == 99999)
		{
			NSLog(@"here");
			self.alpha = 0;
			
		}
		else
		{
			for (int i = 0; i < [menuItemImages count]; i++)
			{
				UIImageView * pin = [pins objectAtIndex:i];
				[pin.layer addAnimation:[self shrinkAnimationWithIndex:i] forKey:@"transform"];
			}
		}
	}
	
	
	
}



#pragma mark -
#pragma mark Hiding Menu

- (void) hideMenu {
	isMenuGrowing = NO;
	isMenuVisible = NO;
	for (int i = 0; i < [menuItemImages count]; i++)
	{
		UIImageView * pin = [pins objectAtIndex:i];
		[pin.layer addAnimation:[self collapsePinsWithIndex:i] forKey:@"transform.rotation.z"];
	}
}

- (CAAnimationGroup *)shrinkAnimationWithIndex:(int)index
{
	CGFloat startOffset = 0.1f;
	CGFloat animDuration = 0.3f;
	
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, .1)];
	scaleAnimation.duration = animDuration + (abs(index - [menuItemImages count] + 1) * startOffset);
	scaleAnimation.removedOnCompletion = NO;
	scaleAnimation.fillMode = kCAFillModeForwards;
	
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:scaleAnimation, nil];
    animationgroup.duration = animDuration + ([menuItemImages count] * startOffset);
	animationgroup.removedOnCompletion = NO;
	animationgroup.fillMode = kCAFillModeForwards;
	if (index == 0) animationgroup.delegate = self;
	[animationgroup setValue:[NSNumber numberWithInt:99999] forKey:@"TPTAnimationType"];
	return animationgroup;
}

-(CAAnimationGroup*) collapsePinsWithIndex:(int)index
{
	NSArray *keyframes = [self getKeyFramesForNumberOfMenuItems:[menuItemImages count] withIndex:index];	
	NSLog(@"collapsing");
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



#pragma mark -
#pragma mark Animation Helper Methods

- (NSArray*) getKeyFramesForNumberOfMenuItems:(int)menuCount withIndex:(int)index
{
	NSArray * keyframes;
	
	if (menuCount == 4) {
		
		switch (index) {
			case 0:
				keyframes = @[DEGREES_0, DEGREES_90];
				break;
			case 1:
				keyframes = @[DEGREES_0, DEGREES_90, DEGREES_180];
				break;
			case 2:
				keyframes = @[DEGREES_0, DEGREES_90, DEGREES_180, DEGREES_270];
				break;
			case 3:
				keyframes = @[DEGREES_0, DEGREES_90, DEGREES_180, DEGREES_270, DEGREES_360];
				break;
			default:
				break;
		}
	}
	else if (menuCount == 3)
	{
		switch (index) {
			case 0:
				keyframes = nil;
				break;
			case 1:
				keyframes = @[DEGREES_0, DEGREES_90];
				break;
			case 2:
				keyframes = @[DEGREES_0, DEGREES_NEG_90];
				break;
			default:
				break;
		}
	}
	else if (menuCount == 2)
	{
		switch (index) {
			case 0:
				keyframes = @[DEGREES_0, DEGREES_45];
				break;
			case 1:
				keyframes = @[DEGREES_0, DEGREES_NEG_45 ];
				break;
			default:
				break;
		}
	}
	
	// if menu is closing let's reverse the array
	if (isMenuGrowing)
	{
		return keyframes;
	} else {
		NSArray* reversedArray = [[keyframes reverseObjectEnumerator] allObjects];
		return reversedArray;
	}
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


#pragma mark -
#pragma mark Setters/Getters

- (void) setMenuItemImages:(NSArray *)aMenuItemImages
{
	menuItemImages = aMenuItemImages;
	[self drawPins];
}

@end
