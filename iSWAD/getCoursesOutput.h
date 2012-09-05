//
//  getCoursesOutput.h
//  iSWAD
//
//  Created by Diego Montesinos on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoapObject.h"
#import "coursesArray.h"

@interface getCoursesOutput : SoapObject
{
	int _numCourses;
	coursesArray *_courses;
}

@property int numCourses;
@property (retain, nonatomic) coursesArray* courses;

+ (getCoursesOutput*) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
- (NSMutableString*) serialize;
- (NSMutableString*) serialize: (NSString*) nodeName;
- (NSMutableString*) serializeAttributes;
- (NSMutableString*) serializeElements;
@end
