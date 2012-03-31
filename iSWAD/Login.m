//
//  Login.m
//  iSWAD
//
//  Created by Diego Montesinos on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Login.h"
#import "swad.h"
#import "Encrypt.h"
#import "NSData+Base64.h"

@implementation Login

+(void) loginTarget:(id) target action:(SEL) action{
    swad* service = [swad service];
    NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:@"user"];
    NSString *pass = [[NSUserDefaults standardUserDefaults] stringForKey:@"pass"];
    
	NSData *data = [pass dataUsingEncoding: NSUTF8StringEncoding];
    
    NSData *encryptedData = [Encrypt sha512:data];
    
	NSString *passEncB64 = [encryptedData base64Encoding];    
    passEncB64 = [passEncB64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    passEncB64 = [passEncB64 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    passEncB64 = [passEncB64 stringByReplacingOccurrencesOfString:@"=" withString:@" "];
    
    [service loginByUserPasswordKey:target action:action userID:user userPassword:passEncB64 appKey:@"iTorres"];
}

// Handle the response from loginByUserPasswordKey.

@end
