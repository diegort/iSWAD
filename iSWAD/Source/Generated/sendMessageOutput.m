#import "sendMessageOutput.h"

@implementation sendMessageOutput
@synthesize numUsers = _numUsers;
@synthesize users = _users;

- (id) init
{
    if(self = [super init])
    {
        //self.answerText = nil;
        
    }
    return self;
}

+ (sendMessageOutput*) newWithNode: (CXMLNode*) node
{
    if(node == nil) { return nil; }
    return (sendMessageOutput*)[[sendMessageOutput alloc] initWithNode: node];
}

- (id) initWithNode: (CXMLNode*) node {
    if(self = [super initWithNode: node])
    {
        self.numUsers = [[Soap getNodeValue: node withName: @"numUsers"] intValue];
        self.users = [[usersArray alloc] initWithNode:[Soap getNode: node withName:@"usersArray"]];
    }
    
    return self;
}

- (NSMutableString*) serialize
{
    return [self serialize: @"sendMessageOutput"];
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
	[s appendFormat: @"<numUsers>%i</numUsers>", _numUsers];
	[s appendString:[_users serialize]];
    /*[s appendFormat: @"<userCode>%@</userCode>", [NSString stringWithFormat: @"%i", self.userCode]];
    [s appendFormat: @"<userTypeCode>%@</userTypeCode>", [NSString stringWithFormat: @"%i", self.userTypeCode]];
    
    if (self.wsKey != nil) 
        [s appendFormat: @"<wsKey>%@</wsKey>", [[self.wsKey stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
    if (self.userID != nil) 
        [s appendFormat: @"<userID>%@</userID>", [[self.userID stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
    if (self.userSurname1 != nil) 
        [s appendFormat: @"<userSurname1>%@</userSurname1>", [[self.userSurname1 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
    if (self.userSurname2 != nil) 
        [s appendFormat: @"<userSurname2>%@</userSurname2>", [[self.userSurname2 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
    if (self.userFirstname != nil) 
        [s appendFormat: @"<userFirstname>%@</userFirstname>", [[self.userFirstname stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
    if (self.userTypeName != nil) 
        [s appendFormat: @"<userFirstname>%@</userFirstname>", [[self.userFirstname stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
    */
    return s;
}

- (NSMutableString*) serializeAttributes
{
    NSMutableString* s = [super serializeAttributes];
    
    return s;
}

-(BOOL)isEqual:(id)object{
    if(object != nil && [object isKindOfClass:[sendMessageOutput class]]) {
        return [[self serialize] isEqualToString:[object serialize]];
    }
    return NO;
}

-(NSUInteger)hash{
    return [Soap generateHash:self];
    
}

- (void) dealloc
{
    //if(self.answerText != nil) { [self.answerText release]; }
    [super dealloc];
}

@end
