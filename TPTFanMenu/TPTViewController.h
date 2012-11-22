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

@interface TPTViewController : UIViewController<UIGestureRecognizerDelegate, TPTFanMenuDelegate>

@property (nonatomic) TPTFanMenu *fourFanMenu;
@property (nonatomic) TPTFanMenu *threeFanMenu;
@property (nonatomic) TPTFanMenu *twoFanMenu;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UIImageView *twoMenuItems;
@property (weak, nonatomic) IBOutlet UIImageView *threeMenuItems;
@property (weak, nonatomic) IBOutlet UIImageView *fourMenuItems;

@end
