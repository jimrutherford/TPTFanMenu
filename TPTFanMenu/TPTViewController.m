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
	NSLog(@"here");
	UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
																										action:@selector(handleLongPress:)];
    [longPressRecognizer setMinimumPressDuration:2];
    [longPressRecognizer setDelegate:self];
    [self.view addGestureRecognizer:longPressRecognizer];
	
	fanMenu = [[TPTFanMenu alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	
	[self.view addSubview:fanMenu];
	
	
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long press Ended .................");
		
    }
    else {
        NSLog(@"Long press detected .....................");
		[fanMenu showMenu:recognizer.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
