#import "Soap.h"

@interface loginByUserPasswordKeyOutput : SoapObject 
{
	int _userCode;
	int _userTypeCode;
	NSString *_wsKey;
	NSString *_userID;
	NSString *_userSurname1;
	NSString *_userSurname2;
	NSString *_userFirstname;
//	NSString *_userTypeName;
}

@property int userCode;
@property int userTypeCode;
@property (retain) NSString * wsKey;
@property (retain) NSString * userID;
@property (retain) NSString * userSurname1;
@property (retain) NSString * userSurname2;
@property (retain) NSString * userFirstname;
//@property (retain) NSString * userTypeName;

+ (loginByUserPasswordKeyOutput*) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
- (NSMutableString*) serialize;
- (NSMutableString*) serialize: (NSString*) nodeName;
- (NSMutableString*) serializeAttributes;
- (NSMutableString*) serializeElements;

@end
