//
//  NSString+Hashing.h
//  Created by CTP.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

enum {
    NJHashTypeMD5 = 0,
    NJHashTypeSHA1,
    NJHashTypeSHA256,
}; typedef NSUInteger NJHashType;

enum {
    NJHmacTypeMD5 = 0,
    NJHmacTypeSHA1,
    NJHmacTypeSHA256,
}; typedef NSUInteger NJHmacType;

@interface NSString (Hashing)

- (NSData*)md5;
- (NSData*)sha1;
- (NSData*)sha256;
- (NSData*)hashWithType:(NJHashType)type;

- (NSData*)hmac_md5:(NSString*)key;
- (NSData*)hmac_sha1:(NSString*)key;
- (NSData*)hmac_sha256:(NSString*)key;
- (NSData*)hmacWithType:(NJHmacType)type key:(NSString*)key;

@end