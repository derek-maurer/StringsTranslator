//
//  AccessToken.m
//  LanguageConverter
//
//  Created by Derek Maurer on 7/7/14.
//  Copyright (c) 2014 Moca Apps LLC. All rights reserved.
//

#import "AccessToken.h"

static NSString *appID = nil;
static NSString *clientSecret = nil;
static NSString *accessToken = nil;

@implementation AccessToken

+ (NSString*)accessToken {
    if (accessToken) return accessToken;
    
    if (!clientSecret || !appID) {
        NSLog(@"You must set the client secret and app id");
        return nil;
    }
    
    NSString *clientSecretEscaped = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)clientSecret,
                                                                                 NULL,
                                                                                 (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
    NSMutableString* authHeader = [NSMutableString stringWithString:@"client_id="];
    [authHeader appendString:appID];
    [authHeader appendString:@"&client_secret="];
    [authHeader appendString:clientSecretEscaped];
    [authHeader appendString:@"&grant_type=client_credentials&scope=http://api.microsofttranslator.com"];
    
    
    
    NSMutableURLRequest *requestAuTh =[NSMutableURLRequest
                                       requestWithURL:[NSURL URLWithString:@"https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"]
                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60.0];
    
    [requestAuTh setHTTPMethod:@"POST"];
    [requestAuTh addValue:@"application/x-www-form-urlencoded"
       forHTTPHeaderField:@"Content-Type"];
    
    const char *bytes = [authHeader UTF8String];
    [requestAuTh setHTTPBody:[NSData dataWithBytes:bytes length:strlen(bytes)]];
    
    NSURLResponse* response;
    NSError* error;
    
    NSData* data = [NSURLConnection sendSynchronousRequest: requestAuTh returningResponse: &response error: &error];
    
    if (data != nil) {
        NSError *errorPaserJSON = nil;
        NSDictionary *jsonContents = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorPaserJSON];
        if (!errorPaserJSON) {
            accessToken = [jsonContents objectForKey:@"access_token"];
            
            if (accessToken.length > 0 ) {
                return accessToken;
            }
        }
    }
    
    return nil;
}

+ (void)setAppID:(NSString*)ai {
    appID = ai;
}

+ (void)setClientSecret:(NSString*)cs {
    clientSecret = cs;
}

@end