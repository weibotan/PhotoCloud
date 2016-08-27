//
//
//  NSString+Hashing.h
//  Created by CTP.
//

#import "NSString+Hashing.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
//#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (Hashing)

#pragma mark - Hashing
- (NSData*)md5 {
    return [self hashWithType:NJHashTypeMD5];
}

- (NSData*)sha1 {
    return [self hashWithType:NJHashTypeSHA1];
}

- (NSData*)sha256 {
    return [self hashWithType:NJHashTypeSHA256];
}

- (NSData*)hashWithType:(NJHashType)type {
    
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create buffer with length for chosen digest
    NSInteger bufferSize;
    switch (type) {
        case NJHashTypeMD5:
            // 16 bytes            
            bufferSize = CC_MD5_DIGEST_LENGTH;
            break;
        
        case NJHashTypeSHA1:
            // 20 bytes            
            bufferSize = CC_SHA1_DIGEST_LENGTH;
            break;
        
        case NJHashTypeSHA256:
            // 32 bytes            
            bufferSize = CC_SHA256_DIGEST_LENGTH;
            break;
            
        default:
            return nil;
            break;
    }
    
    unsigned char buffer[bufferSize];
    
    // Perform hash calculation and store in buffer
    switch (type) {
        case NJHashTypeMD5:
            CC_MD5(ptr, (CC_LONG)strlen(ptr), buffer);
            break;
            
        case NJHashTypeSHA1:
            CC_SHA1(ptr, (CC_LONG)strlen(ptr), buffer);
            break;
            
        case NJHashTypeSHA256:
            CC_SHA256(ptr, (CC_LONG)strlen(ptr), buffer);
            break;
            
        default:
            return nil;
            break;
    }
    
    NSData *hmacData=[[NSData alloc]initWithBytes:buffer length:bufferSize];
    //NSLog(@"Data:%@,Data Length:%lu",hmacData,(unsigned long)hmacData.length);
    return hmacData;
}

#pragma mark - HMAC (Keyed Message Authentication Code)
- (NSData*)hmac_md5:(NSString*)key{
    return [self hmacWithType:NJHmacTypeMD5 key:key];
}

- (NSData*)hmac_sha1:(NSString*)key{
    return [self hmacWithType:NJHmacTypeSHA1 key:key];
}
- (NSData*)hmac_sha256:(NSString*)key{
    return [self hmacWithType:NJHmacTypeSHA256 key:key];
}

- (NSData*)hmacWithType:(NJHmacType)type key:(NSString*)key{
    // Pointer to UTF8 representations of strings
    const char *ptr = [self UTF8String];
    const char *keyPtr = [key UTF8String];
    
    // Create buffer with length for chosen digest
    NSInteger bufferSize;
    switch (type) {
        case NJHmacTypeMD5:
            // 16 bytes
            bufferSize = CC_MD5_DIGEST_LENGTH;
            break;
            
        case NJHmacTypeSHA1:
            // 20 bytes
            bufferSize = CC_SHA1_DIGEST_LENGTH;
            break;
            
        case NJHmacTypeSHA256:
            // 32 bytes
            bufferSize = CC_SHA256_DIGEST_LENGTH;
            break;
            
        default:
            return nil;
            break;
    }
    
    unsigned char buffer[bufferSize];
    
    // Perform hash calculation and store in buffer
    switch (type) {
        case NJHmacTypeMD5:
            // Create hash value
            CCHmac(kCCHmacAlgMD5,            // algorithm
                   keyPtr, strlen(keyPtr),    // key and key length
                   ptr, strlen( ptr ),          // data to hash and length
                   buffer);
            break;
            
        case NJHmacTypeSHA1:
            // Create hash value
            CCHmac(kCCHmacAlgSHA1,            // algorithm
                   keyPtr, strlen(keyPtr),    // key and key length
                   ptr, strlen( ptr ),          // data to hash and length
                   buffer);                     // output buffer
            break;
            
        case NJHmacTypeSHA256:
            // Create hash value
            CCHmac(kCCHmacAlgSHA256,            // algorithm
                   keyPtr, strlen(keyPtr),    // key and key length
                   ptr, strlen( ptr ),          // data to hash and length
                   buffer);                     // output buffer
            break;
            
        default:
            return nil;
            break;
    }
    
    NSData *hmacData=[[NSData alloc]initWithBytes:buffer length:bufferSize];
    //NSLog(@"Data:%@,Data Length:%lu",hmacData,(unsigned long)hmacData.length);
    return hmacData;
}

+(NSString *)hexStringForNSData:(NSData *)data{
    NSString *hexString=[[data description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    hexString=[hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSLog(@"%@",hexString);
    return hexString;
}

@end