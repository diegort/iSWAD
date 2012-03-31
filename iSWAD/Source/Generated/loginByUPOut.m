#import "loginByUPOut.h"

@implementation loginByUserPasswordKeyOutput
@synthesize userCode = _userCode;
@synthesize userTypeCode = _userTypeCode;
@synthesize wsKey = _wsKey;
@synthesize userID = _userID;
@synthesize userSurname1 = _userSurname1;
@synthesize userSurname2 = _userSurname2;
@synthesize userFirstname = _userFirstname;
@synthesize userTypeName = _userTypeName;

- (id) init
{
    if(self = [super init])
    {
        //self.answerText = nil;
        
    }
    return self;
}

+ (loginByUserPasswordKeyOutput*) newWithNode: (CXMLNode*) node
{
    if(node == nil) { return nil; }
    return (loginByUserPasswordKeyOutput*)[[[loginByUserPasswordKeyOutput alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node {
    if(self = [super initWithNode: node])
    {
        self.userCode = [[Soap getNodeValue: node withName: @"userCode"] intValue];
        self.userTypeCode = [[Soap getNodeValue: node withName: @"userTypeCode"] intValue];
        self.wsKey = [Soap getNodeValue: node withName: @"wsKey"];
        self.userID = [Soap getNodeValue: node withName: @"userID"];
        self.userSurname1 = [Soap getNodeValue: node withName: @"userSurname1"];
        self.userSurname2 = [Soap getNodeValue: node withName: @"userSurname2"];
        self.userFirstname = [Soap getNodeValue: node withName: @"userFirstname"];
        self.userTypeName = [Soap getNodeValue: node withName: @"userTypeName"];
    }
    
    return self;
}

- (NSMutableString*) serialize
{
    return [self serialize: @"loginByUserPasswordKeyOutput"];
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
    
    return s;
}

- (NSMutableString*) serializeAttributes
{
    NSMutableString* s = [super serializeAttributes];
    
    return s;
}

-(BOOL)isEqual:(id)object{
    if(object != nil && [object isKindOfClass:[loginByUserPasswordKeyOutput class]]) {
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
