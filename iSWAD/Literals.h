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
#define MessageSent			@"MessageSent"
#define NotificationsDone	@"NotificationsDone"
#define NoticePosted		@"NoticePosted"
#define CoursesListReady	@"CoursesListReady"
#define TestConfigReady		@"TestConfigReady"

/*
 NSUserDefault keys
 */
#define UserKey				@"user"
#define PassKey				@"pass"
#define NotifUpdateTimeKey	@"notificationsUpdateTime"
#define UserTypeKey			@"userType"
#define AppVersionKEy		@"appVersion"

/*
 Call types
 */
enum CallType {
	LoginCall = 1,
	NotificationCall,
	MessagesCall
	};

#endif
