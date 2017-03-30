//
//  NSData+MyExtensions.h
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

#import <Foundation/Foundation.h>

#define kAES256CryptoErrorDomain @"AES256CryptoErrorDomain"
#define kAES256CryptoUserInfoErrorStatus @"CCCryptorStatus"

@interface NSData (MyExtensions)

/**
 * Method to AES256 encrypt the data with the specified key and initialization vector.
 *
 * @param key The key to use to encrypt the data - only up to the first kCCKeySizeAES256 characters are used.
 * @param iv The initialization vector, if any, to use for randomizing the encrypted result so no repeatable patterns can be detected.  The initialization vector should be up to kCCKeySizeAES128 in length.  If nil, no initialization vector is used.
 *
 * @return The encrypted data if successful, otherwise nil.
 *
 * @note This method is intended for use with small NSData (less than tens of MBs).
 */
- (NSData *)aes256EncryptWithKey:(NSString*)key initializationVector: (NSData *)iv error: (NSError **)error;

/**
 * Method to AES256 decrypt the encrypted data with the specified key and initialization vector.
 *
 * @param key The key to use to decrypt the data - only up to the first kCCKeySizeAES256 characters are used.
 * @param iv The initialization vector, if any, should be up to kCCKeySizeAES128 in length and match that which was specified for encryption.  If nil, no initialization vector is used.
 *
 * @return The decrypted data if successful, otherwise nil.
 *
 * @note This method is intended for use with small NSData (less than tens of MBs).
 */
- (NSData *)aes256DecryptWithKey:(NSString*)key initializationVector: (NSData *)iv error: (NSError **)error;

@end
