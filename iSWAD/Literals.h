//
//  Literals.h
//  iSWAD
//
//  Created by Diego Montesinos on 08/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef iSWAD_Literals_h
#define iSWAD_Literals_h

#define AppKey				@"iTorres"

/*
 NSNotification Names
 */
#define Common				@"CommonNotif"
#define MessageSent			@"MessageSent"
#define NotificationsDone	@"NotificationsDone"
#define NoticePosted		@"NoticePosted"
#define CoursesListReady	@"CoursesListReady"
#define TestConfigReady		@"TestConfigReady"
#define TestReady			@"TestReady"

/*
 NSUserDefault keys
 */
#define UserKey				@"user"
#define PassKey				@"pass"
#define NotifUpdateTimeKey	@"notificationsUpdateTime"
#define UserTypeKey			@"userType"
#define AppVersionKEy		@"appVersion"

/*
 Error codes
 */
#define OK					0
#define SoapError			-1
#define ConnectivityError	400
#define DBError				-5
#define LoginError			-2

/*
 Call types
 */
enum CallType {
	LoginCall = 1,
	NotificationCall,
	MessagesCall
	};

#endif
