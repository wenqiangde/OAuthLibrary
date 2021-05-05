//
//  OAuthGetAccessToken.h
//  OAuth
//
//  Created by wenqiang on 28/4/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(GetAccessToken)
@interface OAuthGetAccessToken : NSObject

+ (void)configrueWithHost:(nonnull NSString*)host
                   apiKey:(nonnull NSString*)apiKey
                secretKey:(nonnull NSString*)secretKey
                    scope:(nullable NSString*)scope NS_SWIFT_NAME(configrue(host:apiKey:secretKey:scope:));

+ (NSString*)accessToken:(NSError * _Nonnull *)error NS_SWIFT_NAME(accessToken(error:));

@end

NS_ASSUME_NONNULL_END
