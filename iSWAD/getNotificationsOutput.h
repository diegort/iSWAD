#import "Soap.h"
#import "notificationsArray.h"

@interface getNotificationsOutput : SoapObject{
    int _numNotifications;
    notificationsArray *_notifications;
}
@property int numNotifications;
@property (retain, nonatomic) notificationsArray* notifications;

+ (getNotificationsOutput*) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
- (NSMutableString*) serialize;
- (NSMutableString*) serialize: (NSString*) nodeName;
- (NSMutableString*) serializeAttributes;
- (NSMutableString*) serializeElements;

@end
