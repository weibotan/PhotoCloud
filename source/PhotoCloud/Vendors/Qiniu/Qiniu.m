//
//  Qiniu.m
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

#import "Qiniu.h"
#import "QN_GTM_Base64.h"

#include <CommonCrypto/CommonHMAC.h>
#import "NSString+Hashing.h"

@implementation Qiniu

+(instancetype)sharedQN{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance=[[self alloc]init];
    });
    return instance;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        self.QNURL=@"http://www.7xptab.com1.z0.glb.clouddn.com/";
        self.QNBucketName=@"lxlsk";
        self.QNAccessKey=@"mPoPh4Aui1ukbhkO0xDt3gIi4OAghpgFPEXtL1QT";
        self.QNSecretKey=@"PjRIdEL6QKUxVuduszY0P8zleexI15cCZnwxc0kf";
    }
    return self;
}

-(instancetype)initWithQNURL:(NSString *)url
              withQNBucketName:(NSString *)bucketName
               withQNAccessKey:(NSString *)accessKey
               withQNSecretKey:(NSString *)secretKey{
    self=[super init];
    if (self) {
        self.QNURL=url;
        self.QNBucketName=bucketName;
        self.QNAccessKey=accessKey;
        self.QNSecretKey=secretKey;
    }
    return self;
}

-(NSURL *)downloadURLForFile:(NSString *)fileName{
    return [Qiniu downloadURLForFile:fileName urlString:self.QNURL accessKey:self.QNAccessKey secretKey:self.QNSecretKey];
}

+(NSURL *)downloadURLForFile:(NSString *)fileName urlString:(NSString *)urlString accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey{
    if(!fileName) return nil;
    //编码非常重要！！！！！！！！！！！！！！！！！
    NSString *formattedFileName=[fileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *downloadUrl=[urlString stringByAppendingString:formattedFileName];
    
    NSTimeInterval unixTimeStamp = [[NSDate date] timeIntervalSince1970];
    unixTimeStamp+=1000;
    
    downloadUrl=[downloadUrl stringByAppendingFormat:@"?e=%0.f",unixTimeStamp];
    
    NSData *signData=[downloadUrl hmac_sha1:secretKey];
    
    NSString *sign=[QN_GTM_Base64 stringByWebSafeEncodingData:signData padded:YES];
    
    NSString *token=[accessKey stringByAppendingFormat:@":%@",sign];
    
    NSString *realDownloadUrl=[downloadUrl stringByAppendingFormat:@"&token=%@",token];
    
    //NSLog(@"realDownloadUrl:%@",realDownloadUrl);
    
    return [NSURL URLWithString:realDownloadUrl];

}

- (NSString *)upToken{
    return [Qiniu upTokenWithBucketName:self.QNBucketName accessKey:self.QNAccessKey secretKey:self.QNSecretKey];
}

+ (NSString *)upTokenWithBucketName:(NSString *)bucketName accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey{
    const char *secretKeyStr = [secretKey UTF8String];
    
    NSString *policy = [self putPolicyWithBucketName:bucketName];
    
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodedPolicy = [QN_GTM_Base64 stringByWebSafeEncodingData:policyData padded:TRUE];
    
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    
    NSString *encodedDigest = [QN_GTM_Base64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
    
    return token;
}

// 上传策略
+ (NSString *)putPolicyWithBucketName:(NSString *)bucketName
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    //    time_t deadline;
    //    time(&deadline);
    //
    //    deadline += (self.deadline > 0) ? self.deadline : 3600; // 1 hour by default.
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]+3600];
    [dic setObject:deadlineNumber forKey:@"deadline"];
    
    [dic setObject:bucketName forKey:@"scope"];
    //[dic setObject:fileName forKey:@"saveKey"];
    
    //    if (self.callbackUrl) {
    //        [dic setObject:self.callbackUrl forKey:@"callbackUrl"];
    //    }
    //    if (self.callbackBodyType) {
    //        [dic setObject:self.callbackBodyType forKey:@"callbackBodyType"];
    //    }
    //    if (self.customer) {
    //        [dic setObject:self.customer forKey:@"customer"];
    //    }
    //
    
    //
    //    if (self.escape) {
    //        NSNumber *escapeNumber = [NSNumber numberWithLongLong:escape];
    //        [dic setObject:escapeNumber forKey:@"escape"];
    //    }
    
    
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *putPolicy=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"putPolicy=%@",putPolicy);
    return putPolicy;
}

-(NSString *)accessToken:(NSString *)string{
    return [Qiniu accessToken:string accessKey:self.QNAccessKey secretKey:self.QNSecretKey];
}

+(NSString *)accessToken:(NSString *)string accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey{
    if (!string) return nil;
    
    //按要求格式化字符串
    NSString *formattedString=[string stringByAppendingString:@"\n"];
    //对字符串进行hmac_sha1签名
    NSData *signData=[formattedString hmac_sha1:secretKey];
    //对签名结果进行url安全的base64编码
    NSString *urlsafe_base64_encoded_signString=[QN_GTM_Base64 stringByWebSafeEncodingData:signData padded:YES];
    //按规定格式生成AccessToken
    NSString *accessToken=[NSString stringWithFormat:@"%@:%@",accessKey,urlsafe_base64_encoded_signString];
    
    return accessToken;
}

-(BOOL)syncDeleteFile:(NSString *)fileName{
    return [Qiniu syncDeleteFile:fileName bucketName:self.QNBucketName accessKey:self.QNAccessKey secretKey:self.QNSecretKey];
}

+(BOOL)syncDeleteFile:(NSString *)fileName bucketName:(NSString *)bucketName accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey{
    NSURLRequest *req=[Qiniu deleteURLRequestForFile:fileName bucketName:bucketName accessKey:accessKey secretKey:secretKey];
    NSString *info;
    BOOL succeeded=[Qiniu syncURLRequest:req httpStatusString:&info];
    NSLog(@"%@",info);
    if (succeeded) {
        NSLog(@"Delete Succeed:%@",fileName);
    }else{
        NSLog(@"Delete Error!");
    }
    return succeeded;
}

+(NSURLRequest *)deleteURLRequestForFile:(NSString *)fileName bucketName:(NSString *)bucketName accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey{
    //1.生成requestURI
    NSString *entry=[NSString stringWithFormat:@"%@:%@",bucketName,fileName];
    NSData *entryData=[NSData dataWithBytes:[entry UTF8String] length:[entry lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSString *encodedEntryURI=[QN_GTM_Base64 stringByWebSafeEncodingData:entryData padded:YES];
    NSString *requestURI=[@"/delete/" stringByAppendingString:encodedEntryURI];
    //NSLog(@"%@",requestURI);
    
    //2.生成AccessToken
    NSString *accessToken=[self accessToken:requestURI accessKey:accessKey secretKey:secretKey];
    
    //3.生成删除请求
    NSString *urlString=[@"http://rs.qiniu.com" stringByAppendingString:requestURI];
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:30.0];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *authorization=[@"QBox " stringByAppendingString:accessToken];
    [req setValue:authorization forHTTPHeaderField:@"Authorization"];
    //NSLog(@"%@",req);
    
    return req;
}

-(BOOL)syncMoveFromFile:(NSString *)srcFileName toFile:(NSString *)destFileName{
    return [Qiniu syncMoveFromFile:srcFileName toFile:destFileName bucketName:self.QNBucketName accessKey:self.QNAccessKey secretKey:self.QNSecretKey];
}

+(BOOL)syncMoveFromFile:(NSString *)srcFileName toFile:(NSString *)destFileName bucketName:(NSString *)bucketName accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey{
    NSURLRequest *req=[Qiniu moveURLRequestFromFile:srcFileName toFile:destFileName bucketName:bucketName accessKey:accessKey secretKey:secretKey];
    NSString *info;
    BOOL succeeded=[Qiniu syncURLRequest:req httpStatusString:&info];
    NSLog(@"%@",info);
    if (succeeded) {
        NSLog(@"Move Succeed.");
    }else{
        NSLog(@"Move Error!");
    }
    return succeeded;
}

+(NSURLRequest *)moveURLRequestFromFile:(NSString *)srcFileName toFile:(NSString *)destFileName bucketName:(NSString *)bucketName accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey{
    //1.生成requestURI
    NSString *entrySrc=[NSString stringWithFormat:@"%@:%@",bucketName,srcFileName];
    NSData *entryDataSrc=[NSData dataWithBytes:[entrySrc UTF8String] length:[entrySrc lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSString *encodedEntryURISrc=[QN_GTM_Base64 stringByWebSafeEncodingData:entryDataSrc padded:YES];
    NSString *entryDest=[NSString stringWithFormat:@"%@:%@",bucketName,destFileName];
    
    NSData *entryDataDest=[NSData dataWithBytes:[entryDest UTF8String] length:[entryDest lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSString *encodedEntryURIDest=[QN_GTM_Base64 stringByWebSafeEncodingData:entryDataDest padded:YES];
    
    NSString *requestURI=[NSString stringWithFormat:@"/move/%@/%@",encodedEntryURISrc,encodedEntryURIDest];
    //NSLog(@"%@",requestURI);
    
    //2.生成AccessToken
    NSString *accessToken=[self accessToken:requestURI accessKey:accessKey secretKey:secretKey];
    
    //3.生成移动（重命名）文件请求
    NSString *urlString=[@"http://rs.qiniu.com" stringByAppendingString:requestURI];
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:30.0];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *authorization=[@"QBox " stringByAppendingString:accessToken];
    [req setValue:authorization forHTTPHeaderField:@"Authorization"];
    //NSLog(@"%@",req);
    
    return req;
}

+(BOOL)syncURLRequest:(NSURLRequest *)request httpStatusString:(NSString **)httpStatusString{
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    BOOL succeeded=NO;
    NSString *httpDetail;
    switch (response.statusCode) {
        case 200:{
            succeeded=YES;
            httpDetail=@"200-操作执行成功。";
        }
            break;
        case 298:
            httpDetail=@"298-部分操作执行成功。";
            break;
        case 400:
            httpDetail=@"400-请求报文格式错误。（包括上传时，上传表单格式错误；URL触发图片处理时，处理参数错误；资源管理操作或触发持久化处理（pfop）操作请求格式错误）";
            break;
        case 401:
            httpDetail=@"401-认证授权失败。（包括密钥信息不正确；数字签名错误；授权已超时）";
            break;
        case 404:
            httpDetail=@"404-资源不存在。（包括空间资源不存在；镜像源资源不存在）";
            break;
        case 405:
            httpDetail=@"405-请求方式错误。（主要指非预期的请求方式）";
            break;
        case 406:
            httpDetail=@"406-上传的数据 CRC32 校验错误。";
            break;
        case 419:
            httpDetail=@"419-用户账号被冻结。";
            break;
        case 478:
            httpDetail=@"478-镜像回源失败。（主要指镜像源服务器出现异常）";
            break;
        case 503:
            httpDetail=@"503-服务端不可用。";
            break;
        case 504:
            httpDetail=@"504-服务端操作超时。";
            break;
        case 579:
            httpDetail=@"579-上传成功但是回调失败。（包括业务服务器异常；七牛服务器异常；服务器间网络异常）";
            break;
        case 599:
            httpDetail=@"599-服务端操作失败。";
            break;
        case 608:
            httpDetail=@"608-资源内容被修改。";
            break;
        case 612:
            httpDetail=@"612-指定资源不存在或已被删除。";
            break;
        case 614:
            httpDetail=@"614-目标资源已存在。";
            break;
        case 630:
            httpDetail=@"630-已创建的空间数量达到上限，无法创建新空间。";
            break;
        case 631:
            httpDetail=@"631-指定空间不存在。";
            break;
        case 640:
            httpDetail=@"640-调用列举资源（list）接口时，指定非法的marker参数。";
            break;
        case 701:
            httpDetail=@"701-在断点续上传过程中，后续上传接收地址不正确或ctx信息已过期。";
            break;
        default:
            break;
    }
    *httpStatusString=httpDetail;
    return succeeded;
}
@end
