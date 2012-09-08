#import "getTestConfigOutput.h"

@implementation getTestConfigOutput
@synthesize pluggable = _pluggable;
@synthesize numQuestions = _numQuestions;
@synthesize defQuestions = _defQuestions;
@synthesize minQuestions = _minQuestions;
@synthesize maxQuestions = _maxQuestions;
@synthesize feedback = _feedback;

- (id) init
{
    if(self = [super init])
    {
        //self.answerText = nil;
        
    }
    return self;
}

+ (getTestConfigOutput*) newWithNode: (CXMLNode*) node
{
    if(node == nil) { return nil; }
    return (getTestConfigOutput*)[[[getTestConfigOutput alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node {
    if(self = [super initWithNode: node])
    {
        self.pluggable = [[Soap getNodeValue: node withName: @"pluggable"] intValue];
        self.numQuestions = [[Soap getNodeValue: node withName: @"numQuestions"] intValue];
        self.defQuestions = [[Soap getNodeValue: node withName: @"defQuestions"] intValue];
        self.minQuestions = [[Soap getNodeValue: node withName: @"minQuestions"] intValue];
        self.maxQuestions = [[Soap getNodeValue: node withName: @"maxQuestions"] intValue];
        self.feedback = [Soap getNodeValue: node withName: @"feedback"];
    }
    
    return self;
}

- (NSMutableString*) serialize
{
    return [self serialize: @"getTestConfigOutput"];
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
    [s appendFormat: @"<pluggable>%@</pluggable>", [NSString stringWithFormat: @"%i", self.pluggable]];
    [s appendFormat: @"<numQuestions>%@</numQuestions>", [NSString stringWithFormat: @"%i", self.numQuestions]];
	[s appendFormat: @"<minQuestions>%@</minQuestions>", [NSString stringWithFormat: @"%i", self.minQuestions]];
	[s appendFormat: @"<defQuestions>%@</defQuestions>", [NSString stringWithFormat: @"%i", self.defQuestions]];
	[s appendFormat: @"<maxQuestions>%@</maxQuestions>", [NSString stringWithFormat: @"%i", self.maxQuestions]];
	
    if (self.feedback != nil) 
        [s appendFormat: @"<feedback>%@</feedback>", [[self.feedback stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
        
    return s;
}

- (NSMutableString*) serializeAttributes
{
    NSMutableString* s = [super serializeAttributes];
    
    return s;
}

-(BOOL)isEqual:(id)object{
    if(object != nil && [object isKindOfClass:[getTestConfigOutput class]]) {
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
