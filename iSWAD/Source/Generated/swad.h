/*
	swad.h
	The interface definition of classes and methods for the swad web service.
	Generated by SudzC.com
*/
				
#import "Soap.h"
	
/* Add class references */
				
#import "coursesArray.h"
#import "usersArray.h"
#import "notificationsArray.h"
#import "tagsArray.h"
#import "questionsArray.h"
#import "answersArray.h"
#import "questionTagsArray.h"
#import "notification.h"
#import "course.h"
#import "tag.h"
#import "questionTag.h"
#import "question.h"
#import "answer.h"
#import "user.h"
/* Interface for the service */
				
@interface swad : SoapService
		
	/* Returns int. Service definition of function swad__loginBySession */
	- (SoapRequest*) loginBySession: (id <SoapDelegate>) handler sessionID: (NSString*) sessionID;
	- (SoapRequest*) loginBySession: (id) target action: (SEL) action sessionID: (NSString*) sessionID;

	/* Returns int. Service definition of function swad__loginByUserPassword */
	- (SoapRequest*) loginByUserPassword: (id <SoapDelegate>) handler userID: (NSString*) userID userPassword: (NSString*) userPassword;
	- (SoapRequest*) loginByUserPassword: (id) target action: (SEL) action userID: (NSString*) userID userPassword: (NSString*) userPassword;

	/* Returns int. Service definition of function swad__loginByUserPasswordKey */
	- (SoapRequest*) loginByUserPasswordKey: (id <SoapDelegate>) handler userID: (NSString*) userID userPassword: (NSString*) userPassword appKey: (NSString*) appKey;
	- (SoapRequest*) loginByUserPasswordKey: (id) target action: (SEL) action userID: (NSString*) userID userPassword: (NSString*) userPassword appKey: (NSString*) appKey;

    - (id) loginByUserPasswordKeySync: (NSString*) userID userPassword: (NSString*) userPassword appKey: (NSString*) appKey;

	/* Returns int. Service definition of function swad__getCourses */
	- (SoapRequest*) getCourses: (id <SoapDelegate>) handler wsKey: (NSString*) wsKey;
	- (SoapRequest*) getCourses: (id) target action: (SEL) action wsKey: (NSString*) wsKey;

	/* Returns int. Service definition of function swad__getUsers */
	- (SoapRequest*) getUsers: (id <SoapDelegate>) handler wsKey: (NSString*) wsKey courseCode: (int) courseCode groupCode: (int) groupCode userTypeCode: (int) userTypeCode;
	- (SoapRequest*) getUsers: (id) target action: (SEL) action wsKey: (NSString*) wsKey courseCode: (int) courseCode groupCode: (int) groupCode userTypeCode: (int) userTypeCode;

	/* Returns int. Service definition of function swad__getNotifications */
	- (SoapRequest*) getNotifications: (id <SoapDelegate>) handler wsKey: (NSString*) wsKey beginTime: (long) beginTime;
	- (SoapRequest*) getNotifications: (id) target action: (SEL) action wsKey: (NSString*) wsKey beginTime: (long) beginTime;

	/* Returns int. Service definition of function swad__getTestConfig */
	- (SoapRequest*) getTestConfig: (id <SoapDelegate>) handler wsKey: (NSString*) wsKey courseCode: (int) courseCode;
	- (SoapRequest*) getTestConfig: (id) target action: (SEL) action wsKey: (NSString*) wsKey courseCode: (int) courseCode;

	/* Returns NSMutableArray*. Service definition of function swad__getTests */
	- (SoapRequest*) getTests: (id <SoapDelegate>) handler wsKey: (NSString*) wsKey courseCode: (int) courseCode beginTime: (long) beginTime;
	- (SoapRequest*) getTests: (id) target action: (SEL) action wsKey: (NSString*) wsKey courseCode: (int) courseCode beginTime: (long) beginTime;

	/* Returns int. Service definition of function swad__sendMessage */
	- (SoapRequest*) sendMessage: (id <SoapDelegate>) handler wsKey: (NSString*) wsKey messageCode: (long) messageCode to: (NSString*) to subject: (NSString*) subject body: (NSString*) body;
	- (SoapRequest*) sendMessage: (id) target action: (SEL) action wsKey: (NSString*) wsKey messageCode: (long) messageCode to: (NSString*) to subject: (NSString*) subject body: (NSString*) body;

		
	+ (swad*) service;
	+ (swad*) serviceWithUsername: (NSString*) username andPassword: (NSString*) password;
@end
	