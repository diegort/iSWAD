#import "getNotificationsOutput.h"

@implementation getNotificationsOutput
@synthesize numNotifications = _numNotifications;
@synthesize notifications = _notifications;

- (id) init
{
    if(self = [super init])
    {
        //self.answerText = nil;
        
    }
    return self;
}

+ (getNotificationsOutput*) newWithNode: (CXMLNode*) node
{
    if(node == nil) { return nil; }
    return (getNotificationsOutput*)[[getNotificationsOutput alloc] initWithNode: node];
}

- (id) initWithNode: (CXMLNode*) node {
    if(self = [super initWithNode: node])
    {
        self.numNotifications = [[Soap getNodeValue: node withName: @"numNotifications"] intValue];
        self.notifications = [[notificationsArray alloc] initWithNode:[Soap getNode: node withName:@"notificationsArray"]];
    }
    
    return self;
}

- (NSMutableString*) serialize
{
    return [self serialize: @"getNotificationsOutput"];
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
	[s appendFormat: @"<numNotifications>%@</numNotifications>", [NSString stringWithFormat: @"%i", self.numNotifications]];
	
	[s appendString:[_notifications serialize]];
	
    return s;
}

- (NSMutableString*) serializeAttributes
{
    NSMutableString* s = [super serializeAttributes];
    
    return s;
}

-(BOOL)isEqual:(id)object{
    if(object != nil && [object isKindOfClass:[getNotificationsOutput class]]) {
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
