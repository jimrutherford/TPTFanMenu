//
//  TPTViewController.h
//  FanMenu
//
//  Created by Jim Rutherford on 2012-11-03.
//  Copyright (c) 2012 Jim Rutherford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"TPTFanMenu.h"
#import "TPTFanMenuDelegate.h"

@interface TPTViewController : UIViewController<UIGestureRecognizerDelegate>

@property TPTFanMenu *fanMenu;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
