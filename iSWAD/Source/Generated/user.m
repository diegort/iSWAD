/*
	user.h
	The implementation of properties and methods for the user object.
	Generated by SudzC.com
*/
#import "user.h"

@implementation user
	@synthesize userCode = _userCode;
	@synthesize userID = _userID;
	@synthesize userNickname = _userNickname;
	@synthesize userSurname1 = _userSurname1;
	@synthesize userSurname2 = _userSurname2;
	@synthesize userFirstname = _userFirstname;

	- (id) init
	{
		if(self = [super init])
		{
			self.userID = nil;
			self.userNickname = nil;
			self.userSurname1 = nil;
			self.userSurname2 = nil;
			self.userFirstname = nil;

		}
		return self;
	}

	+ (user*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (user*)[[[user alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.userCode = [[Soap getNodeValue: node withName: @"userCode"] intValue];
			self.userID = [Soap getNodeValue: node withName: @"userID"];
			self.userNickname = [Soap getNodeValue: node withName: @"userNickname"];
			self.userSurname1 = [Soap getNodeValue: node withName: @"userSurname1"];
			self.userSurname2 = [Soap getNodeValue: node withName: @"userSurname2"];
			self.userFirstname = [Soap getNodeValue: node withName: @"userFirstname"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"user"];
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
		[s appendFormat: @"<userCode>%@</userCode>", [NSString stringWithFormat: @"%i", self.userCode]];
		if (self.userID != nil) [s appendFormat: @"<userID>%@</userID>", [[self.userID stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.userNickname != nil) [s appendFormat: @"<userNickname>%@</userNickname>", [[self.userNickname stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.userSurname1 != nil) [s appendFormat: @"<userSurname1>%@</userSurname1>", [[self.userSurname1 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.userSurname2 != nil) [s appendFormat: @"<userSurname2>%@</userSurname2>", [[self.userSurname2 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.userFirstname != nil) [s appendFormat: @"<userFirstname>%@</userFirstname>", [[self.userFirstname stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[user class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.userID != nil) { [self.userID release]; }
		if(self.userNickname != nil) { [self.userNickname release]; }
		if(self.userSurname1 != nil) { [self.userSurname1 release]; }
		if(self.userSurname2 != nil) { [self.userSurname2 release]; }
		if(self.userFirstname != nil) { [self.userFirstname release]; }
		[super dealloc];
	}

@end