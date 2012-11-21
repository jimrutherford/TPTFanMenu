//
//  TPTViewController.m
//  FanMenu
//
//  Created by Jim Rutherford on 2012-11-03.
//  Copyright (c) 2012 Jim Rutherford. All rights reserved.
//

#import "TPTViewController.h"

@interface TPTViewController ()

@end

@implementation TPTViewController

@synthesize backgroundImage;
@synthesize fourFanMenu;
@synthesize threeFanMenu;
@synthesize twoFanMenu;

@synthesize twoMenuItems;
@synthesize threeMenuItems;
@synthesize fourMenuItems;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSArray *twoItems = @[[UIImage imageNamed:@"pin_star"], [UIImage imageNamed:@"pin_config"]];
	NSArray *threeItems = @[[UIImage imageNamed:@"pin_star"], [UIImage imageNamed:@"pin_config"], [UIImage imageNamed:@"pin_tag"]];
	NSArray *fourItems = @[[UIImage imageNamed:@"pin_tag"], [UIImage imageNamed:@"pin_dash"], [UIImage imageNamed:@"pin_star"], [UIImage imageNamed:@"pin_config"]];
	
	fourFanMenu = [[TPTFanMenu alloc] init];
	fourFanMenu.delegate = self;
	[fourFanMenu setMenuItemImages:fourItems];
	[self.view addSubview:fourFanMenu];

	threeFanMenu = [[TPTFanMenu alloc] init];
	threeFanMenu.delegate = self;
	[threeFanMenu setMenuItemImages:threeItems];
	[self.view addSubview:threeFanMenu];
	
	twoFanMenu = [[TPTFanMenu alloc] init];
	twoFanMenu.delegate = self;
	[twoFanMenu setMenuItemImages:twoItems];
	[self.view addSubview:twoFanMenu];

	// setup gesture to hide the menu - in this example we'll use a simple tap
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[tapRecognizer setDelegate:self];
	[self.view addGestureRecognizer:tapRecognizer];
	
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint coords = [gestureRecognizer locationInView:gestureRecognizer.view];
	
	UIView *theView = [self.view hitTest:coords withEvent:nil];
	NSLog(@"menu items - %i", theView.tag);

	if (fourFanMenu.isMenuVisible)
	{
		[fourFanMenu hideMenu];
	}
	
	if (twoFanMenu.isMenuVisible)
	{
		[twoFanMenu hideMenu];
	}
	
	if (threeFanMenu.isMenuVisible)
	{
		[threeFanMenu hideMenu];
	}
	
	if (!fourFanMenu.isMenuVisible && theView.tag == 44)
	{
		[fourFanMenu setCenter:coords];
		[fourFanMenu showMenu];
	}

	if (!threeFanMenu.isMenuVisible && theView.tag == 33)
	{
		[threeFanMenu setCenter:coords];
		[threeFanMenu showMenu];
	}

	if (!twoFanMenu.isMenuVisible && theView.tag == 22)
	{
		[twoFanMenu setCenter:coords];
		[twoFanMenu showMenu];
	}

}

- (void) didPressMenuItem:(UIButton*)menuItem {
	NSLog(@"tap detected in VC - %i", menuItem.tag);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
