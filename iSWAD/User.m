//
//  User.m
//  iSWAD
//
//  Created by Diego Montesinos on 27/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "Literals.h"

static int _userCode;
static int _userTypeCode;
static NSString *_wskey;
static NSString *_userID;
static NSString *_userSurname1;
static NSString *_userSurname2;
static NSString *_userFirstname;
//static NSString *_userTypeName;
static BOOL _logged;
static time_t _loginTime;

@implementation User
+(void) initWithLoginOutput:(loginByUserPasswordKeyOutput *) value time:(time_t) tValue{
    _userCode = value.userCode;
    _userTypeCode = value.userTypeCode;
    _wskey = value.wsKey;
    _userID = value.userID;
    _userSurname1 = value.userSurname1;
    _userSurname2 = value.userSurname2;
    _userFirstname = value.userFirstname;
    //_userTypeName = value.userTypeName;
    _logged = YES;
    _loginTime = tValue;
    
    NSNumber *tmp = [[NSNumber alloc] initWithInt:_userTypeCode];
    [[NSUserDefaults standardUserDefaults] setValue:tmp forKey:UserTypeKey];
    [tmp release];
}

+(void)initWithUserCode:(int) userCode userTypeCode:(int) userTypeCode wsKey:(NSString *)wskey userID:(NSString *)userID userSurname1:(NSString *)userSurname1 userSurname2:(NSString *) userSurname2 userFirstname:(NSString *)userFirstname{
    
    _userCode = userCode;
    _userTypeCode = userTypeCode;
    _wskey = wskey;
    _userID = userID;
    _userSurname1 = userSurname1;
    _userSurname2 = userSurname2;
    _userFirstname = userFirstname;
    //_userTypeName = userTypeName;
	_logged = YES;
    
    NSNumber *tmp = [[NSNumber alloc] initWithInt:_userTypeCode];
    [[NSUserDefaults standardUserDefaults] setValue:tmp forKey:UserTypeKey];
    [tmp release];
}

/*Getters*/
+(int) userCode{
    return _userCode;
}

+(int) userTypeCode{
    return _userTypeCode;
}

+(NSString *) wsKey{
    return _wskey;
}

+(NSString *) userID{
    return _userID;
}

+(NSString *) userSurname1{
    return _userSurname1;
}

+(NSString *) userSurname2{
    return _userSurname2;
}

+(NSString *) userFirstname{
    return _userFirstname;
}

/*+(NSString *) userTypeName{
    return _userTypeName;
}*/

+(BOOL) logged{
    return  _logged;
}

+(time_t) loginTime{
    return _loginTime;
}

/*Setters*/
+(void) setUserCode:(int)value{
    _userCode = value;
}

+(void) setUserTypeCode:(int)value{
    _userTypeCode = value;
}

+(void) setWsKey:(NSString *) value{
    _wskey = value;
}

+(void) setUserID:(NSString *) value{
    _userID = value;
}

+(void) setUserSurname1:(NSString *) value{
    _userSurname1 = value;
}

+(void) setUserSurname2:(NSString *) value{
    _userSurname2 = value;
}

+(void) setUserFirstname:(NSString *) value{
    _userFirstname = value;
}

/*+(void) setUserTypeName:(NSString *) value{
    _userTypeName = value;
}*/

+(void) setLogged:(BOOL) value{
	_logged = value;
}

+(void) setLoginTime: (time_t) value{
	_loginTime = value;
}


@end
