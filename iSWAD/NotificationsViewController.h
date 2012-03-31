//
//  NotificationsViewController.h
//  iSWAD
//
//  Created by Diego Montesinos on 01/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface NotificationsViewController : UITableViewController{
    UITableViewCell *tvCell;
    NSArray *notifications;
    DBManager *myDB;
    UIActivityIndicatorView *activityIndicatorView;
    UIApplication* app;
    time_t currentTime;
    UIView *noNotif;
    
    NSInteger selectedIndex;
}

@property (nonatomic, assign) IBOutlet UITableViewCell *tvCell;
@end
