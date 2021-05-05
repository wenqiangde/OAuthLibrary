//
//  OAuthParameterDefaults.h
//  OAuth
//
//  Created by wenqiang on 28/4/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Parameters)
@interface OAuthParameters : NSObject

@property (nonatomic, strong) NSString* host;
@property (nonatomic, strong) NSString* apiKey;
@property (nonatomic, strong) NSString* secretKey;
@property (nonatomic, strong) NSString* scope;

@property (class, readonly, strong) OAuthParameters *instance;

@end

NS_ASSUME_NONNULL_END
