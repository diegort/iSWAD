//
//  DBManager.h
//  iSWAD
//
//  Created by Diego Montesinos on 03/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iSWADAppDelegate.h"
#import "getTestConfigOutput.h"
#import "getTestOutput.h"

@interface DBManager : NSObject{
    iSWADAppDelegate *app;
    NSManagedObjectContext *context;
}

- (NSArray *) getNotifications;
- (BOOL) saveNotifications:(NSArray *)notifcations;
- (BOOL) markNotificationAsRead:(int)notCode;

- (getTestConfigOutput *) getTestConfig:(int) courseCode; 
- (BOOL) saveTestConfig: (getTestConfigOutput *) config courseCode: (int)courseCode;
- (long) getLastTestDownload: (int) courseCode;
- (BOOL) setLastTestDownload: (int) courseCode time: (long)beginTime;

- (BOOL) saveTest: (getTestOutput *) test courseCode: (int)courseCode;

@end
