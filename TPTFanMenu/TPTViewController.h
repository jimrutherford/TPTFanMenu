//
//  TPTViewController.h
//  FanMenu
//
//  Created by Jim Rutherford on 2012-11-03.
//  Copyright (c) 2012 Jim Rutherford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TPTViewController : UIViewController

@property int totalPins;

@property NSMutableArray * pins;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
