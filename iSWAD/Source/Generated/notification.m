/*
	notification.h
	The implementation of properties and methods for the notification object.
	Generated by SudzC.com
*/
#import "notification.h"

@implementation notification
	@synthesize notificationCode = _notificationCode;
	@synthesize eventType = _eventType;
	@synthesize eventTime = _eventTime;
	@synthesize userNickname = _userNickname;
	@synthesize userSurname1 = _userSurname1;
	@synthesize userSurname2 = _userSurname2;
	@synthesize userFirstname = _userFirstname;
	@synthesize location = _location;
	@synthesize status = _status;
	@synthesize summary = _summary;
	@synthesize content = _content;

	- (id) init
	{
		if(self = [super init])
		{
			self.eventType = nil;
			self.userNickname = nil;
			self.userSurname1 = nil;
			self.userSurname2 = nil;
			self.userFirstname = nil;
			self.location = nil;
			self.summary = nil;
			self.content = nil;

		}
		return self;
	}

	+ (notification*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (notification*)[[[notification alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.notificationCode = [[Soap getNodeValue: node withName: @"notificationCode"] longLongValue];
			self.eventType = [Soap getNodeValue: node withName: @"eventType"];
			self.eventTime = [[Soap getNodeValue: node withName: @"eventTime"] longLongValue];
			self.userNickname = [Soap getNodeValue: node withName: @"userNickname"];
			self.userSurname1 = [Soap getNodeValue: node withName: @"userSurname1"];
			self.userSurname2 = [Soap getNodeValue: node withName: @"userSurname2"];
			self.userFirstname = [Soap getNodeValue: node withName: @"userFirstname"];
			self.location = [Soap getNodeValue: node withName: @"location"];
			self.status = [[Soap getNodeValue: node withName: @"status"] intValue];
			self.summary = [Soap getNodeValue: node withName: @"summary"];
			self.content = [Soap getNodeValue: node withName: @"content"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"notification"];
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
		[s appendFormat: @"<notificationCode>%@</notificationCode>", [NSString stringWithFormat: @"%l", self.notificationCode]];
		if (self.eventType != nil) [s appendFormat: @"<eventType>%@</eventType>", [[self.eventType stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<eventTime>%@</eventTime>", [NSString stringWithFormat: @"%ld", self.eventTime]];
		if (self.userNickname != nil) [s appendFormat: @"<userNickname>%@</userNickname>", [[self.userNickname stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.userSurname1 != nil) [s appendFormat: @"<userSurname1>%@</userSurname1>", [[self.userSurname1 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.userSurname2 != nil) [s appendFormat: @"<userSurname2>%@</userSurname2>", [[self.userSurname2 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.userFirstname != nil) [s appendFormat: @"<userFirstname>%@</userFirstname>", [[self.userFirstname stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.location != nil) [s appendFormat: @"<location>%@</location>", [[self.location stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<status>%@</status>", [NSString stringWithFormat: @"%i", self.status]];
		if (self.summary != nil) [s appendFormat: @"<summary>%@</summary>", [[self.summary stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.content != nil) [s appendFormat: @"<content>%@</content>", [[self.content stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[notification class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.eventType != nil) { [self.eventType release]; }
		if(self.userNickname != nil) { [self.userNickname release]; }
		if(self.userSurname1 != nil) { [self.userSurname1 release]; }
		if(self.userSurname2 != nil) { [self.userSurname2 release]; }
		if(self.userFirstname != nil) { [self.userFirstname release]; }
		if(self.location != nil) { [self.location release]; }
		if(self.summary != nil) { [self.summary release]; }
		if(self.content != nil) { [self.content release]; }
		[super dealloc];
	}

@end
