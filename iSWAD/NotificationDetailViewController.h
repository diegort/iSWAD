//
//  NotificationDetailViewController.h
//  iSWAD
//
//  Created by Diego Montesinos on 10/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationDetailViewController : UIViewController

@property (retain, nonatomic) NSString *Type;
@property (nonatomic) int Code;
@property (retain, nonatomic) NSString *Subject;

@property (retain, nonatomic) IBOutlet UIWebView *wvDetails;

@end
