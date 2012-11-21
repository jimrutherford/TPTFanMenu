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
@synthesize fanMenu;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSArray *menuItems = @[[UIImage imageNamed:@"pin_1"], [UIImage imageNamed:@"pin_2"]];
	//NSArray *menuItems = @[[UIImage imageNamed:@"pin_1"], [UIImage imageNamed:@"pin_2"], [UIImage imageNamed:@"pin_3"]];
	//NSArray *menuItems = @[[UIImage imageNamed:@"pin_1"], [UIImage imageNamed:@"pin_2"], [UIImage imageNamed:@"pin_3"], [UIImage imageNamed:@"pin_4"]];
	
	fanMenu = [[TPTFanMenu alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	fanMenu.delegate = self;
	[fanMenu setMenuItemImages:menuItems];
	[self.view addSubview:fanMenu];

	
	// setup gesture to show the menu - in this example we'll use a longpress
	UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
																										action:@selector(handleLongPress:)];
    [longPressRecognizer setMinimumPressDuration:1];
	longPressRecognizer.cancelsTouchesInView = NO;
    [longPressRecognizer setDelegate:self];
    [self.view addGestureRecognizer:longPressRecognizer];

	// setup gesture to hide the menu - in this example we'll use a simple tap
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[tapRecognizer setDelegate:self];
	[self.view addGestureRecognizer:tapRecognizer];
	
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		CGPoint coords = [gestureRecognizer locationInView:gestureRecognizer.view];
		[fanMenu setCenter:coords];
		[fanMenu showMenu:gestureRecognizer.view];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if (fanMenu.isMenuVisible)
	{
		[fanMenu hideMenu:gestureRecognizer.view];
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
