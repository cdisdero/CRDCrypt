//
//  Data+MyExtensions.swift
//  PassBook
//
//  Created by Christopher Disdero on 2/18/17.
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

import Foundation

public extension Data {
    
    public static func generateInitializationVector() -> Data {
        
        var uuidBytes: [UInt8] = [UInt8](repeating: 0, count: 16)
        NSUUID().getBytes(&uuidBytes)
        return Data(bytes: &uuidBytes, count: 16)
    }
    
    public func aes256Encrypt(withKey: String, initializationVector: Data?) throws -> Data {
        
        return try (self as NSData).aes256Encrypt(withKey: withKey, initializationVector: initializationVector)
    }

    public func aes256Decrypt(withKey: String, initializationVector: Data?) throws -> Data {
        
        return try (self as NSData).aes256Decrypt(withKey: withKey, initializationVector: initializationVector)
    }
}
