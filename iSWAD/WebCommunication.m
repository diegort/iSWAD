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
bool showError;
time_t currentTime;

id target;
SEL act;

- (id) init{
    self = [super init];
    if (self) {
        myDB = [[DBManager alloc] init];
    }
    return self;
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

- (void) sendMessage: (NSString *)message subject: (NSString *)subject to: (NSString *)receivers code: (long) code{
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    //time_t time = (time_t) [now timeIntervalSince1970];
    int timeDif = [now timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[User loginTime]]];
    if (![User loged] || timeDif > 3600) {
        //[self loginWithTarget:self Action:@selector(updateNotifications)];
    } else {
        //[self getNotifications];
    }
}

- (void) notificationsHandler: (id) value { 
    
	if(showError){
        showError = NO;
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
            SoapFault *err = (SoapFault *) value;
            
            if ([[err faultString] hasPrefix:@"Bad l"]) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: NSLocalizedString(@"getNotificationsErrorAlertTitle", nil)
                                      message: NSLocalizedString(@"getNotificationsErrorAlertMessage", nil)
                                      delegate: nil
                                      cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
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
    
    showError = YES;
    [service getNotifications:self action:@selector(notificationsHandler:) wsKey:User.wsKey beginTime:beginTime];
}

- (void) updateNotifications{
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    //time_t time = (time_t) [now timeIntervalSince1970];
    int timeDif = [now timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[User loginTime]]];
    if (![User loged] || timeDif > 3600) {
        [self loginWithTarget:self Action:@selector(getNotifs)];
    } else {
        [self getNotifs];
    }
}

@end
