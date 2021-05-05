//
//  OAuthGetAccessToken.m
//  OAuth
//
//  Created by wenqiang on 28/4/2021.
//

#import "OAuthGetAccessToken.h"
#import "OAuthParameters.h"

@interface OAuthGetAccessToken()

@end

@implementation OAuthGetAccessToken

+ (void)configrueWithHost:(nonnull NSString*)host
                   apiKey:(nonnull NSString*)apiKey
                secretKey:(nonnull NSString*)secretKey
                    scope:(nullable NSString*)scope {
    
    OAuthParameters.instance.host = host;
    OAuthParameters.instance.apiKey = apiKey;
    OAuthParameters.instance.secretKey = secretKey;
    OAuthParameters.instance.scope = scope;
}


+ (NSString*)accessToken:(NSError * _Nonnull *)error {
    
    NSString* URLString = [self URLString];
    
    NSString* accessToken = [self accessTokenForURLString:URLString];
    if (!accessToken || accessToken.length == 0) {
        
        NSURLComponents* urlComponents = [NSURLComponents componentsWithString:URLString];
        urlComponents.queryItems = [self queryItems];
        
        NSData* data = [NSData dataWithContentsOfURL:urlComponents.URL options:0 error:error];
        NSTimeInterval currentTime = [self timestamp];
        if (*error == nil /* 请求access_token错误 */ ) {
            id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
            if (*error == nil /* data转JSON对象错误 */ ) {
                accessToken = JSONObject[@"access_token"];
                if (!accessToken || accessToken.length == 0 /* 服务器返回错误 */ ) {
                    *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:-1 userInfo:@{
                        NSLocalizedDescriptionKey:JSONObject[@"error"]?:@"",
                        NSLocalizedFailureReasonErrorKey:JSONObject[@"error_description"]?:@""
                    }];
                } else {
                    NSTimeInterval expires_in = [JSONObject[@"expires_in"] doubleValue];
                    NSTimeInterval expiresTime = expires_in + currentTime;
                    [self setAccessToken:accessToken forURLString:URLString];
                    [self setExpiresTime:expiresTime forAccessToken:accessToken];
                    return accessToken;
                }
            }
        }
        return @"error is nil, if condition has issue.";
    } else {
        NSTimeInterval expiresTime = [self expiresTimeForAccessToken:accessToken];
        NSTimeInterval currentTime = [self timestamp];
        NSLog(@"currentTime >= expiresTime ~ (%@ >= %@)", @(currentTime), @(expiresTime));
        if (currentTime >= expiresTime) {
            [NSUserDefaults.standardUserDefaults removeObjectForKey:URLString];
            [NSUserDefaults.standardUserDefaults removeObjectForKey:accessToken];
            [NSUserDefaults.standardUserDefaults synchronize];
            return [self accessToken:error];
        }
        return accessToken;
    }
}

+ (NSArray<NSURLQueryItem*>*)queryItems {
    return @[
        [NSURLQueryItem queryItemWithName:@"grant_type"    value:@"client_credentials"],
        [NSURLQueryItem queryItemWithName:@"client_id"     value:OAuthParameters.instance.apiKey],
        [NSURLQueryItem queryItemWithName:@"client_secret" value:OAuthParameters.instance.secretKey],
        [NSURLQueryItem queryItemWithName:@"scope"         value:OAuthParameters.instance.scope]
    ];
}

+ (NSString*)URLString {
    return [OAuthParameters.instance.host stringByAppendingString:@"/oauth/token"];
}

+ (NSString*)accessTokenForURLString:(NSString*)URLString {
    return [NSUserDefaults.standardUserDefaults objectForKey:URLString];
}

+ (BOOL)setAccessToken:(NSString*)accessToken forURLString:(NSString*)URLString {
    [NSUserDefaults.standardUserDefaults setObject:accessToken forKey:URLString];
    return [NSUserDefaults.standardUserDefaults synchronize];
}

+ (NSTimeInterval)expiresTimeForAccessToken:(NSString*)accessToken {
    return [NSUserDefaults.standardUserDefaults doubleForKey:accessToken];
}

+ (BOOL)setExpiresTime:(NSTimeInterval)expiresTime forAccessToken:(NSString*)accessToken {
    [NSUserDefaults.standardUserDefaults setDouble:expiresTime forKey:accessToken];
    return [NSUserDefaults.standardUserDefaults synchronize];
}

+ (NSTimeInterval)timestamp {
    return [[NSDate date] timeIntervalSince1970];
}

@end
