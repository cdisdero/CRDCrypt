//
//  NSData+MyExtensions.m
//  PassBook
//
//  Created by Christopher Disdero on 2/8/17.
//
/*
 Copyright © 2017 Christopher Disdero.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import "NSData+MyExtensions.h"

@implementation NSData (MyExtensions)

- (NSString *)cryptoErrorDescriptionForStatus:(CCCryptorStatus)status {
    
    NSString *statusDescription = nil;
    
    switch (status) {
            
        case kCCParamError:
            statusDescription = @"Illegal parameter value.";
            break;

        case kCCBufferTooSmall:
            statusDescription = @"Insufficent buffer provided for specified operation.";
            break;

        case kCCMemoryFailure:
            statusDescription = @"Memory allocation failure.";
            break;

        case kCCAlignmentError:
            statusDescription = @"Input size was not aligned properly.";
            break;
            
        case kCCDecodeError:
            statusDescription = @"Input data did not decode or decrypt properly.";
            break;
            
        case kCCUnimplemented:
            statusDescription = @"Function not implemented for the current algorithm.";
            break;
        
        case kCCOverflow:
        case kCCRNGFailure:
        case kCCUnspecifiedError:
        case kCCCallSequenceError:
        default:
            statusDescription = @"Unspecified crypto failure occurred.";
            break;
    }
    
    return statusDescription;
}

- (NSData *)aes256EncryptWithKey:(NSString*)key initializationVector: (NSData *)iv error:(NSError *__autoreleasing *)error {
    
    // Bail out on invalid key.
    if (key.length == 0) {
        
        if (error != nil) {
            
            *error = [[NSError alloc] initWithDomain:kAES256CryptoErrorDomain code:__LINE__ userInfo:@{NSLocalizedDescriptionKey: @"invalid key specified"}];
        }
        
        return nil;
    }
    
    // Use only up to the first kCCKeySizeAES256 characters of the specified key.
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [[key substringToIndex:MIN(key.length, kCCKeySizeAES256)] getCString:keyPtr maxLength:sizeof( keyPtr ) encoding:NSUTF8StringEncoding];

    // Get the length of the data to encrypt
    NSUInteger dataLength = [self length];
    
    // Allocate buffer for encrypted result.
    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block, so we need to add the size of one block.
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    // Do the encryption.
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          iv.bytes /* initialization vector */,
                                          [self bytes], dataLength, /* decrypted input */
                                          buffer, bufferSize, /* encrypted output */
                                          &numBytesEncrypted );
    
    if ( cryptStatus == kCCSuccess ) {
        
        // The returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    
    } else {
        
        if (error != nil) {
            
            *error = [[NSError alloc] initWithDomain:kAES256CryptoErrorDomain code:__LINE__ userInfo:@{kAES256CryptoUserInfoErrorStatus: [NSNumber numberWithInt:cryptStatus],NSLocalizedDescriptionKey: [self cryptoErrorDescriptionForStatus:cryptStatus]}];
        }
    }
    
    // Free the buffer we used for the encryption.
    free( buffer );
    
    return nil;
}

- (NSData *)aes256DecryptWithKey:(NSString*)key initializationVector:(NSData *)iv error:(NSError *__autoreleasing *)error {
    
    // Bail out on invalid key.
    if (key.length == 0) {
        
        if (error != nil) {
            
            *error = [[NSError alloc] initWithDomain:kAES256CryptoErrorDomain code:__LINE__ userInfo:@{NSLocalizedDescriptionKey: @"invalid key specified"}];
        }

        return nil;
    }
    
    // Use only up to the first kCCKeySizeAES256 characters of the specified key.
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero( keyPtr, sizeof( keyPtr ) );
    [[key substringToIndex:MIN(key.length, kCCKeySizeAES256)] getCString:keyPtr maxLength:sizeof( keyPtr ) encoding:NSUTF8StringEncoding];
    
    // Get the length of the data to encrypt
    NSUInteger dataLength = [self length];
    
    // Allocate buffer for decrypted result.
    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block, so we need to add the size of one block.
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    // Do the decryption.
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          iv.bytes /* initialization vector */,
                                          [self bytes], dataLength, /* encrypted input */
                                          buffer, bufferSize, /* decrypted output */
                                          &numBytesDecrypted );
    
    if( cryptStatus == kCCSuccess ) {
        
        // The returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    
    } else {
        
        if (error != nil) {
            
            *error = [[NSError alloc] initWithDomain:kAES256CryptoErrorDomain code:__LINE__ userInfo:@{kAES256CryptoUserInfoErrorStatus: [NSNumber numberWithInt:cryptStatus],NSLocalizedDescriptionKey: [self cryptoErrorDescriptionForStatus:cryptStatus]}];
        }
    }
    
    // Free the buffer we used for the decryption.
    free( buffer );
    
    return nil;
}

@end
