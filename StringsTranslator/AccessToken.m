//
//  AccessToken.m
//  LanguageConverter
//
//  Created by Derek Maurer on 7/7/14.
//  Copyright (c) 2014 Moca Apps LLC. All rights reserved.
//

#import "AccessToken.h"

@implementation AccessToken

+ (NSString*)accessToken {
    NSString *defaultsAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
    if (defaultsAccessToken) return defaultsAccessToken;
    
    NSString *clientSecret = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)[self clientSecret],
                                                                                 NULL,
                                                                                 (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
    NSMutableString* authHeader = [NSMutableString stringWithString:@"client_id="];
    [authHeader appendString:[self appID]];
    [authHeader appendString:@"&client_secret="];
    [authHeader appendString:clientSecret];
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
    NSString *accessToken = @"";
    if (data != nil) {
        NSError *errorPaserJSON = nil;
        NSDictionary *jsonContents = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorPaserJSON];
        if (!errorPaserJSON) {
            accessToken = [jsonContents objectForKey:@"access_token"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:accessToken forKey:@"AccessToken"];
            [defaults synchronize];
            
            if (accessToken.length > 0 ) {
                return accessToken;
            }else{
                accessToken = @"";
            }
        }
    }
    
    return nil;
}

+ (NSString*)appID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"AppID"];
}

+ (NSString*)clientSecret {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ClientSecret"];
}

+ (void)setAppID:(NSString*)appID {
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    [defualts setObject:appID forKey:@"AppID"];
    [defualts synchronize];
}

+ (void)setClientSecret:(NSString*)clientSecret {
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    [defualts setObject:clientSecret forKey:@"ClientSecret"];
    [defualts synchronize];
}

@end