//
//  WebCommunication.h
//  iSWAD
//
//  Created by Diego Montesinos on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class swad, DBManager;
@interface WebCommunication : NSObject{
    DBManager *myDB;
	UIApplication* app;
	swad* service;
}

- (void) login;

- (void) updateNotifications;

- (void) sendMessage: (NSString *)message subject: (NSString *)subject to: (NSString *)receivers code: (int) code;
- (void) sendMessage: (NSString *)message subject: (NSString *)subject to: (NSString *)receivers;

- (void) getSubjects;

- (void) sendNotice: (NSString *)body courseCode: (int)course;

- (void) getTestConfig:(int)courseCode;

- (void) getTests:(int)courseCode beginTime: (long)beginTime;

@end
