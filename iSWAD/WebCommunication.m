//
//  WebCommunication.m
//  iSWAD
//
//  Created by Diego Montesinos on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebCommunication.h"
#import "Login.h"
#import "swad.h"
#import "User.h"
#import "sendMessageOutput.h"
#import "notificationsArray.h"
#import "getNotificationsOutput.h"

@implementation WebCommunication

bool showLoginError;
bool showNotifError;
bool showMessageError;
time_t currentTime;

NSString *_messageBody;
NSString *_messageSubject;
NSString *_messageReceivers;
long  _messageCode;


id target;
SEL act;

- (id) init{
    self = [super init];
    if (self) {
        myDB = [[DBManager alloc] init];
    }
    return self;
}

-(BOOL)loginNeeded{
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    //time_t time = (time_t) [now timeIntervalSince1970];
    int timeDif = [now timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[User loginTime]]];
    
    return (![User loged] || timeDif > 3600);
}

- (void) loginWithTarget: (id)object Action: (SEL)method{
    showLoginError = YES;
    target = object;
    act = method;
    [Login loginTarget:self action:@selector(loginHandler:)];
}

-(void) login{
    [self loginWithTarget:nil Action:nil];
}

- (void) loginHandler: (id) value { 
    UIApplication* app = [UIApplication sharedApplication];
	if(showLoginError){
        showLoginError = NO;
        if ([value isKindOfClass:[NSError class]]) { // Handle errors
            //NSLog(@"%@", value);
            //NSError *err = (NSError *) value;
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"noConnectionAlertTitle", nil)
                                  message: NSLocalizedString(@"noConnectionAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            app.networkActivityIndicatorVisible = NO;
        } else if([value isKindOfClass:[SoapFault class]]) { // Handle faults
            SoapFault *err = (SoapFault *) value;
            
            if ([[err faultString] hasPrefix:@"Bad l"]) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: NSLocalizedString(@"loginErrorAlertTitle", nil)
                                      message: NSLocalizedString(@"loginErrorAlertMessage", nil)
                                      delegate: nil
                                      cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                app.networkActivityIndicatorVisible = NO;
            }
        } else if ([value isKindOfClass:[loginByUserPasswordKeyOutput class]]){ //All went OK
            loginByUserPasswordKeyOutput* tmp = (loginByUserPasswordKeyOutput*)value;
            NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
            [User initWithLoginOutput:tmp time:[now timeIntervalSince1970]];
            
            //[self sendMessage];
            if (target != nil){
                [target performSelector:act];
            }
        }
    }
}

//#section "Messages"

- (void) sendMessageHandler: (id) value { 
    id param;
	if(showMessageError){
        showMessageError = NO;
        if ([value isKindOfClass:[NSError class]]) { // Handle errors
            //NSLog(@"%@", value);
            //NSError *err = (NSError *) value;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"noConnectionAlertTitle", nil)
                                  message: NSLocalizedString(@"noConnectionAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else if([value isKindOfClass:[SoapFault class]]) { // Handle faults
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"sendMessageErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"sendMessageErrorAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else if ([value isKindOfClass:[sendMessageOutput class]]){ //All went OK
            [[NSNotificationCenter defaultCenter] postNotificationName:@"messageSent" object:param];                                
        }
        
    }
}


-(void) sendMessageToUsers{
    swad* service = [swad service];
    
    showMessageError = YES;
    [service sendMessage:self action:@selector(sendMessageHandler:) wsKey:User.wsKey messageCode:_messageCode to:_messageReceivers subject:_messageSubject body:_messageBody];
}

- (void) sendMessage: (NSString *)message subject: (NSString *)subject to: (NSString *)receivers code: (long) code{
    _messageCode = code;
    _messageBody = message;
    _messageSubject = subject;
    _messageReceivers = receivers;
    
    [_messageBody retain];
    [_messageReceivers retain];
    [_messageSubject retain];
    
    if ([self loginNeeded]) {
        [self loginWithTarget:self Action:@selector(sendMessageToUsers)];
    } else {
        [self sendMessageToUsers];
    }
}

- (void) sendMessage: (NSString *)message subject: (NSString *)subject to: (NSString *)receivers{
    [self sendMessage:message subject:subject to:receivers code:0];
}

- (void) notificationsHandler: (id) value { 
    
	if(showNotifError){
        showNotifError = NO;
        if ([value isKindOfClass:[NSError class]]) { // Handle errors
            //NSLog(@"%@", value);
            //NSError *err = (NSError *) value;
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"noConnectionAlertTitle", nil)
                                  message: NSLocalizedString(@"noConnectionAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else if([value isKindOfClass:[SoapFault class]]) { // Handle faults
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"getNotificationsErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"getNotificationsErrorAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else if ([value isKindOfClass:[getNotificationsOutput class]]){ //All went OK
            getNotificationsOutput* tmp = (getNotificationsOutput*)value;
            //Esto a la función de retorno de
            if ([myDB saveNotifications:tmp.notifications.items]){
                
                //currentTime = ((notification*)[notifications objectAtIndex:0]).eventTime;
                NSNumber *temp = [NSNumber numberWithLong:currentTime];
                [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"notificationsUpdateTime"];
                
                /*if(noNotif){
                    [noNotif removeFromSuperview];
                    self.tableView.bounces = YES;
                }*/
                /*notificationsArray *notifications;
                [notifications release];
                notifications = nil;
                notifications = [myDB getNotifications];
                [notifications retain];*/
                //[self.tableView reloadData];
            }else{
                //Error
            }
            //sleep(2000);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotificationsDone" object:nil];            
        }
    }
}

- (void) getNotifs{
    swad* service = [swad service];
    
    NSNumber *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:@"notificationsUpdateTime"];
    long beginTime = [tmp longValue];
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    currentTime = (time_t) [now timeIntervalSince1970];
    
    showNotifError = YES;
    [service getNotifications:self action:@selector(notificationsHandler:) wsKey:User.wsKey beginTime:beginTime];
}

- (void) updateNotifications{
    if ([self loginNeeded]) {
        [self loginWithTarget:self Action:@selector(getNotifs)];
    } else {
        [self getNotifs];
    }
}

@end
