//
//  getNotificationsOutput.h
//  iSWAD
//
//  Created by Diego Montesinos on 03/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Soap.h"
#import "notificationsArray.h"

@interface getNotificationsOutput : SoapObject{
    int _numNotifications;
    notificationsArray *_notifications;
}
@property int numNotifications;
@property (retain, nonatomic) notificationsArray* notifications;

+ (getNotificationsOutput*) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
- (NSMutableString*) serialize;
- (NSMutableString*) serialize: (NSString*) nodeName;
- (NSMutableString*) serializeAttributes;
- (NSMutableString*) serializeElements;

@end
