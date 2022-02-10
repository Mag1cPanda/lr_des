#import "LrDesPlugin.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation LrDesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"lr_des"
            binaryMessenger:[registrar messenger]];
  LrDesPlugin* instance = [[LrDesPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }
  else if ([@"encryptToBase64" isEqualToString:call.method]) {
      NSArray<NSString *> *paramArray = call.arguments;
      result([self encryptUseDES:paramArray[0] key:paramArray[1]]);
  }
  else if ([@"decryptFromBase64" isEqualToString:call.method]) {
      NSArray<NSString *> *paramArray = call.arguments;
      result([self decryptUseDES:paramArray[0] key:paramArray[1]]);
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark 自定义方法

/*
 * 字符串加密
 *
 * plainText : 待加密明文
 * key       : 密钥
 */
- (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key {
    NSString *ciphertext = nil;
    NSData *baseData = [plainText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSUInteger dataLength = baseData.length + 10 + [key dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES].length;
    unsigned char buffer[dataLength];
    memset(buffer, 0, sizeof(char));
//    Byte iv[] = {1,2,3,4,5,6,7,8};
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [baseData bytes],
                                          [baseData length],
                                          buffer,
                                          dataLength,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [self convertToBase64String:data];
    }
    return ciphertext;
}

- (NSString *)convertToBase64String:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSString *base64string = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return base64string;
}


 
/*
 * 字符串解密
 *
 * plainText : 加密密文
 * key       : 密钥
 */
- (NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key {
    NSData *cipherData = [self convertBase64StringToData:cipherText];
    NSUInteger dataLength = cipherData.length + 10 + [key dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES].length;
    unsigned char buffer[dataLength];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          dataLength,
                                          &numBytesDecrypted);
    NSString *plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"解密失败！%d",cryptStatus);
    }
    return plainText;
}
 
- (NSData *)convertBase64StringToData:(NSString *)base64String {
    if (!base64String || [base64String length] == 0) {
        return nil;
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    NSDataBase64DecodingIgnoreUnknownCharacters
    return data;
}


@end
