/*
	answer.h
	The implementation of properties and methods for the answer object.
	Generated by SudzC.com
*/
#import "answer.h"

@implementation answer
	@synthesize questionCode = _questionCode;
	@synthesize answerIndex = _answerIndex;
	@synthesize correct = _correct;
	@synthesize answerText = _answerText;

	- (id) init
	{
		if(self = [super init])
		{
			self.answerText = nil;

		}
		return self;
	}

	+ (answer*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (answer*)[[answer alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.questionCode = [[Soap getNodeValue: node withName: @"questionCode"] intValue];
			self.answerIndex = [[Soap getNodeValue: node withName: @"answerIndex"] intValue];
			self.correct = [[Soap getNodeValue: node withName: @"correct"] intValue];
			self.answerText = [Soap getNodeValue: node withName: @"answerText"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"answer"];
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
		[s appendFormat: @"<questionCode>%@</questionCode>", [NSString stringWithFormat: @"%i", self.questionCode]];
		[s appendFormat: @"<answerIndex>%@</answerIndex>", [NSString stringWithFormat: @"%i", self.answerIndex]];
		[s appendFormat: @"<correct>%@</correct>", [NSString stringWithFormat: @"%i", self.correct]];
		if (self.answerText != nil) [s appendFormat: @"<answerText>%@</answerText>", [[self.answerText stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[answer class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.answerText != nil) { [_answerText release]; }
		[super dealloc];
	}

@end
