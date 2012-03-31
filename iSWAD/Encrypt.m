//
//  Encrypt.m
//  iSWAD
//
//  Created by Diego Montesinos on 24/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Encrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Encrypt

+ (NSData *)sha512:(NSData *)data {
    unsigned char hash[CC_SHA512_DIGEST_LENGTH];
    if ( CC_SHA512([data bytes], [data length], hash) ) {
        NSData *sha512 = [NSData dataWithBytes:hash length:CC_SHA512_DIGEST_LENGTH];        
        return sha512;
    }
    return nil;
}

@end
