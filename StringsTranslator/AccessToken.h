//
//  AccessToken.h
//  LanguageConverter
//
//  Created by Derek Maurer on 7/7/14.
//  Copyright (c) 2014 Moca Apps LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessToken : NSObject
+ (NSString*)accessToken;
+ (void)setAppID:(NSString*)appID;
+ (void)setClientSecret:(NSString*)clientSecret;
@end