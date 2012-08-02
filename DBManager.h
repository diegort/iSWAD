//
//  DBManager.h
//  iSWAD
//
//  Created by Diego Montesinos on 03/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iSWADAppDelegate.h"
#import "User.h"

@interface DBManager : NSObject{
    iSWADAppDelegate *app;
    NSManagedObjectContext *context;
}

- (NSArray *) getNotifications;
- (BOOL) saveNotifications:(NSArray *)notifcations;
- (BOOL) markNotificationAsRead:(int)notCode;

@end
