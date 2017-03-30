//
//  DataMyExtensionsTests.swift
//  DataMyExtensionsTests
//
//  Created by Christopher Disdero on 2/10/17.
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

import XCTest
#if os(iOS)
    import CRDCryptMobile
#elseif os(OSX)
    import CRDCryptMac
#endif

class DataMyExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAES256EncryptDecrypt() {
        
        let expectedUnencrypted = "Blippo the wonder dog is a very good dog.  He can sing and dance and say hello."
        let encryptionKey = "This is my big encryption key."
        
        let initializationVector = Data.generateInitializationVector()
        
        var actualEncrypted: Data? = nil
        do {

            actualEncrypted = try expectedUnencrypted.data(using: .utf8)?.aes256Encrypt(withKey: encryptionKey, initializationVector: initializationVector)
            XCTAssertNotNil(actualEncrypted)

        } catch let error as NSError {
            
            XCTFail("\(error)")
        }
        
        if let actualEncrypted = actualEncrypted {
        
            do {

                let actualUnencrypted = String(data: try actualEncrypted.aes256Decrypt(withKey: encryptionKey, initializationVector: initializationVector), encoding: .utf8)
                XCTAssertEqual(actualUnencrypted, expectedUnencrypted)
            
            } catch let error as NSError {
                
                XCTFail("\(error)")
            }
        }
    }
}
