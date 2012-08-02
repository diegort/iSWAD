//
//  WebCommunication.h
//  iSWAD
//
//  Created by Diego Montesinos on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface WebCommunication : NSObject{
    DBManager *myDB;
}

- (void) login;
- (void) updateNotifications;
- (void) sendMessage: (NSString *)message subject: (NSString *)subject to: (NSString *)receivers code: (long) code;

@end
