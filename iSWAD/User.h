//
//  User.h
//  iSWAD
//
//  Created by Diego Montesinos on 27/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "loginByUPOut.h"

@interface User : NSObject

+(void)initWithUserCode:(int) userCode userTypeCode:(int) userTypeCode wsKey:(NSString *)wskey userID:(NSString *)userID userSurname1:(NSString *)userSurname1 userSurname2:(NSString *) userSurname2 userFirstname:(NSString *)userFirstname userTypeName:(NSString *)userTypeName;

+(void) initWithLoginOutput:(loginByUserPasswordKeyOutput *) value time:(time_t) tValue;

/*Getters*/
+(int) userCode;
+(int) userTypeCode;
+(NSString *) wsKey;
+(NSString *) userID;
+(NSString *) userSurname1;
+(NSString *) userSurname2;
+(NSString *) userFirstname;
+(NSString *) userTypeName;
+(BOOL) loged;
+(time_t) loginTime;

/*Setters*/
+(void) setUserCode:(int)value;
+(void) setUserTypeCode:(int)value;
+(void) setWsKey:(NSString *) value;
+(void) setUserID:(NSString *) value;
+(void) setUserSurname1:(NSString *) value;
+(void) setUserSurname2:(NSString *) value;
+(void) setUserFirstname:(NSString *) value;
+(void) setUserTypeName:(NSString *) value;
+(void) setLoged:(BOOL) value;
+(void) setLoginTime: (time_t) value;
@end
