#import "Soap.h"
#import "usersArray.h"

@interface sendMessageOutput : SoapObject{
    int _numUsers;
    usersArray *_users;
}
@property int numUsers;
@property (retain, nonatomic) usersArray* users;

+ (sendMessageOutput*) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
- (NSMutableString*) serialize;
- (NSMutableString*) serialize: (NSString*) nodeName;
- (NSMutableString*) serializeAttributes;
- (NSMutableString*) serializeElements;
@end
