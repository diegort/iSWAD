//
//  getCoursesOutput.m
//  iSWAD
//
//  Created by Diego Montesinos on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "getCoursesOutput.h"

@implementation getCoursesOutput
@synthesize numCourses = _numCourses;
@synthesize courses = _courses;

- (id) init
{
    if(self = [super init])
    {
        //self.answerText = nil;
        
    }
    return self;
}

+ (getCoursesOutput*) newWithNode: (CXMLNode*) node
{
    if(node == nil) { return nil; }
    return (getCoursesOutput*)[[[getCoursesOutput alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node {
    if(self = [super initWithNode: node])
    {
		self.numCourses = [[Soap getNodeValue: node withName: @"numCourses"] intValue];
        self.courses = [[coursesArray alloc] initWithNode:[Soap getNode: node withName:@"coursesArray"]];
    }
    
    return self;
}

- (NSMutableString*) serialize
{
    return [self serialize: @"getCoursesOutput"];
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
	[s appendFormat: @"<%@>", @"numCourses"];
	[s appendFormat: @"%i", _numCourses];
	[s appendFormat: @"</%@>", @"numCourses"];
	[s appendString:[_courses serialize]];
    
    return s;
}

- (NSMutableString*) serializeAttributes
{
    NSMutableString* s = [super serializeAttributes];
    
    return s;
}

-(BOOL)isEqual:(id)object{
    if(object != nil && [object isKindOfClass:[getCoursesOutput class]]) {
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
