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
#import "getNotificationsOutput.h"
#import "getCoursesOutput.h"
#import "Literals.h"

@implementation WebCommunication

bool showLoginError;
bool showNotifError;
bool showMessageError;
bool showCoursesError;
bool showNoticeError;
bool showTestConfigError;
bool showTestError;

//bool showError;

time_t currentTime;

NSString *_messageBody;
NSString *_messageSubject;
NSString *_messageReceivers;
long  _messageCode;

NSString *_noticeBody;
int _courseCode;

long _beginTime;

id target;
SEL act;
//enum CallType callType;

- (id) init{
    self = [super init];
    if (self) {
        myDB = [[DBManager alloc] init];
		app = [UIApplication sharedApplication];
    }
    return self;
}

/*- (void) responseHandler: (id) value{
	if(showError){
        showError = NO;
        if ([value isKindOfClass:[NSError class]]) { // Handle errors
            NSLog(@"%@", value);
            NSError *err = (NSError *) value;
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"noConnectionAlertTitle", nil)
                                  message: NSLocalizedString(@"noConnectionAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            //app.networkActivityIndicatorVisible = NO;
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
                //app.networkActivityIndicatorVisible = NO;
            }else{
				NSString *msg, *title;
				switch (callType) {
					case NotificationCall:
						title = NSLocalizedString(@"getNotificationsErrorAlertTitle", nil);
						msg = NSLocalizedString(@"getNotificationsErrorAlertMessage", nil);
						break;
						
					default:
						title = @"";
						msg = @"";
						break;
				}
				UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: title
                                      message: msg
                                      delegate: nil
                                      cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
			}
        } else {//if ([value isKindOfClass:[loginByUserPasswordKeyOutput class]]){ //All went OK
			NSString *nsnotif;
			switch (callType) {
				case LoginCall:
					[User initWithLoginOutput:value time:[[[NSDate alloc] initWithTimeIntervalSinceNow:0] timeIntervalSince1970]];
					if (target != nil){
						[target performSelector:act];
					}
					break;
				case NotificationCall:
					if ([myDB saveNotifications:((getNotificationsOutput * )value).notifications.items]){
						NSNumber *temp = [NSNumber numberWithLong:currentTime];
						[[NSUserDefaults standardUserDefaults] setObject:temp forKey:NotifUpdateTimeKey];
					}else{
						//Error
					}
					nsnotif = NotificationsDone;
					break;
					
				default:
					break;
			}
			if (callType != LoginCall)
				[[NSNotificationCenter defaultCenter] postNotificationName:nsnotif object:value];
        }
    }
}
*/
-(BOOL)loginNeeded{
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    //time_t time = (time_t) [now timeIntervalSince1970];
    int timeDif = [now timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[User loginTime]]];
    [now release];
    return (![User logged] || timeDif > 3600);
}

- (void) loginWithTarget: (id)object Action: (SEL)method{
    showLoginError = YES;
	//showError = YES;
    target = object;
    act = method;
	//callType = LoginCall;
    [Login loginTarget:self action:@selector(loginHandler:)];
	//[Login loginTarget:self action:@selector(responseHandler:)];
}

-(void) login{
    [self loginWithTarget:nil Action:nil];
}

- (void) loginHandler: (id) value { 
    //UIApplication* app = [UIApplication sharedApplication];
	if(showLoginError){
        showLoginError = NO;
        if ([value isKindOfClass:[NSError class]]) { // Handle errors
            //NSLog(@"%@", value);
            NSError *err = (NSError *) value;
            switch ([err code]) {
				case 400:
				{
					UIAlertView *alert = [[UIAlertView alloc]
										  initWithTitle: NSLocalizedString(@"noConnectionAlertTitle", nil)
										  message: NSLocalizedString(@"noConnectionAlertMessage", nil)
										  delegate: nil
										  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
										  otherButtonTitles:nil];
					[alert show];
					[alert release];
					app.networkActivityIndicatorVisible = NO;
				}
					break;
				case 1:
				{
					UIAlertView *alert = [[UIAlertView alloc]
										  initWithTitle: NSLocalizedString(@"badPetitionAlertTitle", nil)
										  message: NSLocalizedString(@"badPetitionAlertMessage", nil)
										  delegate: nil
										  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
										  otherButtonTitles:nil];
					[alert show];
					[alert release];
					app.networkActivityIndicatorVisible = NO;
				}
					break;
				default:
					break;
			}
            
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
            [now release];
            //[self sendMessage];
            if (target != nil){
                [target performSelector:act];
            }
        }
    }
}

/****************************
 ********* Messages *********
 ****************************/
- (void) sendMessageHandler: (id) value { 
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
			app.networkActivityIndicatorVisible = NO;
        } else if([value isKindOfClass:[SoapFault class]]) { // Handle faults
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"sendMessageErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"sendMessageErrorAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
			app.networkActivityIndicatorVisible = NO;
        } else if ([value isKindOfClass:[sendMessageOutput class]]){ //All went OK
			
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageSent object:value];                                
        }
        
    }
}


-(void) sendMessageToUsers{
    swad* service = [swad service];
    
    showMessageError = YES;
    [service sendMessage:self action:@selector(sendMessageHandler:) wsKey:User.wsKey messageCode:_messageCode to:_messageReceivers subject:_messageSubject body:_messageBody];
}

- (void) sendMessage: (NSString *)message subject: (NSString *)subject to: (NSString *)receivers code: (int) code{
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

/****************************
 ****** Notifications *******
 ****************************/

- (void) notificationsHandler: (id) value { 
    
	if(showNotifError){
        showNotifError = NO;
		NSNumber* result;
        if ([value isKindOfClass:[NSError class]]) { // Handle errors
            //NSLog(@"%@", value);
            NSError *err = (NSError *) value;
            
            /*UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"noConnectionAlertTitle", nil)
                                  message: NSLocalizedString(@"noConnectionAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
			app.networkActivityIndicatorVisible = NO;*/
			result = [NSNumber numberWithInt:[err code]];
        } else if([value isKindOfClass:[SoapFault class]]) { // Handle faults
            /*UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"getNotificationsErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"getNotificationsErrorAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
			app.networkActivityIndicatorVisible = NO;*/
			result = [NSNumber numberWithInt:-1];
        } else if ([value isKindOfClass:[getNotificationsOutput class]]){ //All went OK
            getNotificationsOutput* tmp = (getNotificationsOutput*)value;
            
            if ([myDB saveNotifications:tmp.notifications.items]){
                NSNumber *temp = [NSNumber numberWithLong:currentTime];
                [[NSUserDefaults standardUserDefaults] setObject:temp forKey:NotifUpdateTimeKey];
            }else{
                //Error
            }
            //sleep(2000);
			result = [NSNumber numberWithInt:0];
        }
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationsDone object:result];  
    }
}

- (void) getNotifs{
    swad* service = [swad service];
    
    NSNumber *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:NotifUpdateTimeKey];
    long beginTime = [tmp longValue];
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    currentTime = (time_t) [now timeIntervalSince1970];
    [now release];
    showNotifError = YES;
	//showError = YES;
	//callType = NotificationCall;
    [service getNotifications:self action:@selector(notificationsHandler:) wsKey:User.wsKey beginTime:beginTime];
	//[service getNotifications:self action:@selector(responseHandler:) wsKey:User.wsKey beginTime:beginTime];
}

- (void) updateNotifications{
    if ([self loginNeeded]) {
        [self loginWithTarget:self Action:@selector(getNotifs)];
    } else {
        [self getNotifs];
    }
}

/****************************
 ********* Courses **********
 ****************************/

-(void) getSubjectsHandler: (id) value{
	if(showCoursesError){
        showCoursesError = NO;
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
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"getCoursesErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"getCoursesErrorAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
			app.networkActivityIndicatorVisible = NO;
        } else if ([value isKindOfClass:[getCoursesOutput class]]){ //All went OK
            getCoursesOutput* tmp = (getCoursesOutput*)value;
            //NSLog(@"%@",[tmp serialize]);
			[[NSNotificationCenter defaultCenter] postNotificationName:CoursesListReady object:tmp];            
        }
    }
}

-(void) getCoursesList{
	swad* service = [swad service];
    
    showCoursesError = YES;
    [service getCourses:self action:@selector(getSubjectsHandler:) wsKey:User.wsKey];
}

-(void) getSubjects{
	if ([self loginNeeded]) {
        [self loginWithTarget:self Action:@selector(getCoursesList)];
    } else {
        [self getCoursesList];
    }
}

/****************************
 ********** Notices *********
 ****************************/
- (void) sendNoticeHandler: (id) value { 
	if(showNoticeError){
        showNoticeError = NO;
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
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"sendNoticeErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"sendNoticeErrorAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
			app.networkActivityIndicatorVisible = NO;
        } else { //All went OK
            [[NSNotificationCenter defaultCenter] postNotificationName:NoticePosted object:nil];                                
        }        
    }
}


-(void) postNotice{
    swad* service = [swad service];
    
    showNoticeError = YES;
	[service sendNotice:self action:@selector(sendNoticeHandler:) wsKey:User.wsKey courseCode:_courseCode body:_noticeBody];
}

- (void) sendNotice:(NSString *)body courseCode:(int)course{
    _noticeBody = body;
    _courseCode = course;
    
    [_noticeBody retain];
    
    if ([self loginNeeded]) {
        [self loginWithTarget:self Action:@selector(postNotice)];
    } else {
        [self postNotice];
    }
}

/***************************
 ********** Tests **********
 ***************************/
- (void) testConfigHandler: (id) value { 
	if(showTestConfigError){
        showTestConfigError = NO;
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
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"testConfigErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"testConfigErrorAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
			app.networkActivityIndicatorVisible = NO;
        } else if ([value isKindOfClass:[getTestConfigOutput class]]){ //All went OK
            [myDB saveTestConfig:(getTestConfigOutput *) value courseCode:_courseCode];
			[[NSNotificationCenter defaultCenter] postNotificationName:TestConfigReady object:nil];
        }        
    }
}

-(void) getTestConfig{
    swad* service = [swad service];
    
    showTestConfigError = YES;
	[service getTestConfig:self action:@selector(testConfigHandler:) wsKey:User.wsKey courseCode:_courseCode];
}

- (void) getTestConfig:(int)courseCode{
    _courseCode = courseCode;
    
    if ([self loginNeeded]) {
        [self loginWithTarget:self Action:@selector(getTestConfig)];
    } else {
        [self getTestConfig];
    }
}

- (void) testsHandler: (id) value { 
	if(showTestError){
        showTestError = NO;
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
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"sendNoticeErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"sendNoticeErrorAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
			app.networkActivityIndicatorVisible = NO;
        } else if ([value isKindOfClass:[getTestOutput class]]){ //All went OK
            //[myDB insertTestConfig:(getTestOutput *) value courseCode:_courseCode];
			//[[NSNotificationCenter defaultCenter] postNotificationName:@"testConfigReady" object:nil];
			getTestOutput* tmp = (getTestOutput*) value;
        }        
    }
}

-(void) getTests{
    swad* service = [swad service];
    
    showTestError = YES;
	[service getTests:self action:@selector(testsHandler:) wsKey:User.wsKey courseCode:_courseCode beginTime:_beginTime];
}

- (void) getTests:(int)courseCode beginTime:(long)beginTime{
    _courseCode = courseCode;
	_beginTime = beginTime;
	
    if ([self loginNeeded]) {
        [self loginWithTarget:self Action:@selector(getTests)];
    } else {
        [self getTests];
    }
}

@end
