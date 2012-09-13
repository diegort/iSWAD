#import "SoapObject.h"
#import "tagsArray.h"
#import "questionsArray.h"
#import "answersArray.h"
#import "questionTagsArray.h"

@interface getTestOutput : SoapObject{
	tagsArray* _tags;
	questionsArray* _questions;
	answersArray* _answers;
	questionTagsArray* _questionTags;
}

@property (retain, nonatomic) tagsArray* tags;
@property (retain, nonatomic) questionsArray* questions;
@property (retain, nonatomic) answersArray* answers;
@property (retain, nonatomic) questionTagsArray* questionTags;


+ (getTestOutput*) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
- (NSMutableString*) serialize;
- (NSMutableString*) serialize: (NSString*) nodeName;
- (NSMutableString*) serializeAttributes;
- (NSMutableString*) serializeElements;

@end
