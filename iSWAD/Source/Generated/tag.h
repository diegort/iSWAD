/*
	tag.h
	The interface definition of properties and methods for the tag object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface tag : SoapObject
{
	int _tagCode;
	NSString* _tagText;
	
}
		
	@property int tagCode;
	@property (retain, nonatomic) NSString* tagText;

	+ (tag*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
