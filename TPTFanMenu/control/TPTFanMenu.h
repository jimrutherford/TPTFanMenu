//
//  TPTFanMenu.h
//  TPTFanMenu
//
//  Created by James Rutherford on 2012-11-18.
//  Copyright (c) 2012 Jim Rutherford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TPTFanMenuDelegate.h"

@interface TPTFanMenu : UIView

@property (nonatomic) BOOL isMenuVisible;
@property BOOL isMenuGrowing;
@property (nonatomic) NSArray *menuItemImages;
@property NSMutableArray * pins;
@property (nonatomic, assign) id<TPTFanMenuDelegate> delegate;

- (void) showMenu;
- (void) hideMenu;

@end
