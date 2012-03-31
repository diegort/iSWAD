//
//  Encrypt.h
//  iSWAD
//
//  Created by Diego Montesinos on 24/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encrypt : NSObject

+ (NSData *)sha512:(NSData *)data;
@end
