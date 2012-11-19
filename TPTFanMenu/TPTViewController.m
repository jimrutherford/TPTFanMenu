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
	UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
																										action:@selector(handleLongPress:)];
    [longPressRecognizer setMinimumPressDuration:1];
    [longPressRecognizer setDelegate:self];
    [self.view addGestureRecognizer:longPressRecognizer];
	
	fanMenu = [[TPTFanMenu alloc] init];
	[self.view addSubview:fanMenu];
	
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
