#import "Soap.h"

@interface getTestConfigOutput : SoapObject{
	int _pluggable;
	int _numQuestions;
	int _minQuestions;
	int _defQuestions;
	int _maxQuestions;
	NSString* _feedback;
}

@property int pluggable;
@property int numQuestions;
@property int minQuestions;
@property int defQuestions;
@property int maxQuestions;
@property (retain, nonatomic) NSString* feedback;

+ (getTestConfigOutput*) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
- (NSMutableString*) serialize;
- (NSMutableString*) serialize: (NSString*) nodeName;
- (NSMutableString*) serializeAttributes;
- (NSMutableString*) serializeElements;

@end
