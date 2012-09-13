//
//  getTestOutput.m
//  iSWAD
//
//  Created by Diego Montesinos on 08/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "getTestOutput.h"

@implementation getTestOutput
@synthesize tags = _tags;
@synthesize questions = _questions;
@synthesize answers = _answers;
@synthesize questionTags = _questionTags;

- (id) init
{
    if(self = [super init])
    {
        //self.answerText = nil;
        
    }
    return self;
}

+ (getTestOutput*) newWithNode: (CXMLNode*) node
{
    if(node == nil) { return nil; }
    return (getTestOutput*)[[getTestOutput alloc] initWithNode: node];
}

- (id) initWithNode: (CXMLNode*) node {
    if(self = [super initWithNode: node])
    {
        _tags = [[tagsArray alloc] initWithNode:[Soap getNode: node withName:@"tagsArray"]];
		_questions = [[questionsArray alloc] initWithNode:[Soap getNode: node withName:@"questionsArray"]];
		_answers = [[answersArray alloc] initWithNode:[Soap getNode: node withName:@"answersArray"]];
		_questionTags = [[questionTagsArray alloc] initWithNode:[Soap getNode: node withName:@"questionTagsArray"]];
    }
    
    return self;
}

- (NSMutableString*) serialize
{
    return [self serialize: @"getTestOutput"];
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
    NSMutableString* s = [super serialize];
    [s appendString:[_tags serialize]];
	[s appendString:[_questions serialize]];
	[s appendString:[_answers serialize]];
	[s appendString:[_questionTags serialize]];
	
    return s;
}

- (NSMutableString*) serializeAttributes
{
    NSMutableString* s = [super serializeAttributes];
    
    return s;
}

-(BOOL)isEqual:(id)object{
    if(object != nil && [object isKindOfClass:[getTestOutput class]]) {
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
