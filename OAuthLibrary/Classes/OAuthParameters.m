//
//  OAuthParameterDefaults.m
//  OAuth
//
//  Created by wenqiang on 28/4/2021.
//

#import "OAuthParameters.h"

@implementation OAuthParameters

+ (OAuthParameters *)instance {
    static OAuthParameters *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

@end
