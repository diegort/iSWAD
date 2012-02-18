/*
	tagsArray.h
	The implementation of properties and methods for the tagsArray array.
	Generated by SudzC.com
*/
#import "tagsArray.h"

#import "tag.h"
@implementation tagsArray

	+ (id) newWithNode: (CXMLNode*) node
	{
		return [[[tagsArray alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				tag* value = [[tag newWithNode: child] object];
				if(value != nil) {
					[self addObject: value];
				}
			}
		}
		return self;
	}
	
	+ (NSMutableString*) serialize: (NSArray*) array
	{
		NSMutableString* s = [NSMutableString string];
		for(id item in array) {
			[s appendString: [item serialize: @"tag"]];
		}
		return s;
	}
@end
