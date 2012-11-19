//
//  TPTFanMenu.h
//  TPTFanMenu
//
//  Created by James Rutherford on 2012-11-18.
//  Copyright (c) 2012 Jim Rutherford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TPTFanMenu : UIView

@property bool isMenuVisible;
@property int totalPins;

@property NSMutableArray * pins;

- (void) showMenu:(id)sender;
- (void) hideMenu:(id)sender;

@end
