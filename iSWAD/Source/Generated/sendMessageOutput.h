//
//  sendMessageOutput.h
//  iSWAD
//
//  Created by Diego Montesinos on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
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
