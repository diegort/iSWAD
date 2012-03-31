//
//  getNotificationsOutput.m
//  iSWAD
//
//  Created by Diego Montesinos on 03/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "getNotificationsOutput.h"

@implementation getNotificationsOutput
@synthesize numNotifications = _numNotifications;
@synthesize notifications = _notifications;

- (id) init
{
    if(self = [super init])
    {
        //self.answerText = nil;
        
    }
    return self;
}

+ (getNotificationsOutput*) newWithNode: (CXMLNode*) node
{
    if(node == nil) { return nil; }
    return (getNotificationsOutput*)[[[getNotificationsOutput alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node {
    if(self = [super initWithNode: node])
    {
        self.numNotifications = [[Soap getNodeValue: node withName: @"numNotifications"] intValue];
        self.notifications = [[notificationsArray alloc] initWithNode:[Soap getNode: node withName:@"notificationsArray"]];
    }
    
    return self;
}

- (NSMutableString*) serialize
{
    return [self serialize: @"getNotificationsOutput"];
}

- (NSMutableString*) serialize: (NSString*) nodeName
{
    NSMutableString* s = [[NSMutableString alloc] init];
    [s appendFormat: @"<%@", nodeName];
    [s appendString: [self serializeAttributes]];
    [s appendString: @">"];
    [s appendString: [self serializeElements]];
    [s appendFormat: @"</%@>", nodeName];
    return [s autorelease];
}

- (NSMutableString*) serializeElements
{
    NSMutableString* s = [super serializeElements];
    /*[s appendFormat: @"<userCode>%@</userCode>", [NSString stringWithFormat: @"%i", self.userCode]];
     [s appendFormat: @"<userTypeCode>%@</userTypeCode>", [NSString stringWithFormat: @"%i", self.userTypeCode]];
     
     if (self.wsKey != nil) 
     [s appendFormat: @"<wsKey>%@</wsKey>", [[self.wsKey stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
     if (self.userID != nil) 
     [s appendFormat: @"<userID>%@</userID>", [[self.userID stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
     if (self.userSurname1 != nil) 
     [s appendFormat: @"<userSurname1>%@</userSurname1>", [[self.userSurname1 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
     if (self.userSurname2 != nil) 
     [s appendFormat: @"<userSurname2>%@</userSurname2>", [[self.userSurname2 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
     if (self.userFirstname != nil) 
     [s appendFormat: @"<userFirstname>%@</userFirstname>", [[self.userFirstname stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
     if (self.userTypeName != nil) 
     [s appendFormat: @"<userFirstname>%@</userFirstname>", [[self.userFirstname stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
     */
    return s;
}

- (NSMutableString*) serializeAttributes
{
    NSMutableString* s = [super serializeAttributes];
    
    return s;
}

-(BOOL)isEqual:(id)object{
    if(object != nil && [object isKindOfClass:[getNotificationsOutput class]]) {
        return [[self serialize] isEqualToString:[object serialize]];
    }
    return NO;
}

-(NSUInteger)hash{
    return [Soap generateHash:self];
    
}

- (void) dealloc
{
    //if(self.answerText != nil) { [self.answerText release]; }
    [super dealloc];
}

@end
