# CRDKeychain
[![Build Status](https://travis-ci.org/cdisdero/CRDCrypt.svg?branch=master)](https://travis-ci.org/cdisdero/CRDCrypt)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CRDCrypt.svg)](https://img.shields.io/cocoapods/v/CRDCrypt.svg)
[![Platform](https://img.shields.io/cocoapods/p/CRDCrypt.svg?style=flat)](http://cocoadocs.org/docsets/CRDCrypt)

Simple straightforward Swift-based extension to Data for AES 256 bit encryption/decryption for iOS, macOS, watchOS, and tvOS

- [Overview](#overview)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Conclusion](#conclusion)
- [License](#license)

## Overview
I recently needed a simple way to encrypt/decrypt strings and other small data using AES 256 bit encryption using an optional initialization vector to increase encryption pattern randomness.  The result is this small code library that extends the Swift class `Data` with methods to encrypt and decrypt and to generate a unique initialization vector that can be used in the encryption and decryption calls.

## Requirements
- iOS 9.0+ / macOS 10.11+ / watchOS 3.0+ / tvOS 9.0+
- Xcode 8.2+
- Swift 3.0+

## Installation
You can simply copy the following files from the GitHub tree into your project:

  * `Data+MyExtensions.swift`
    - Swift-based extension to the built-in `Data` class for encryption/decryption and for generating an initialization vector.

  * `NSData+MyExtensions.m + .h`
    - Objective C implementation of the encryption/decryption routines called by the Swift-based extensions to the `Data` class.

### CocoaPods
Alternatively, you can install it as a Cocoapod

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build CRDCrypt.

To integrate CRDKeychain into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
target 'MyApp' do
  use_frameworks!

  # Pods for MyApp
  pod 'CRDCrypt'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage
The library is easy to use.  Just import CRDCrypt and generate an initialization vector:

```
let iv = Data.generateInitializationVector()
```

Then we can use this initialization vector in the encryption call to encrypt some string data and make the encryption less predictable between encryptions, for example:

```
let myStringToEncrypt = "This is the string I want to encrypt with the library."
let myPrivateKey = "This is my master key"
var encryptedData: Data? = nil
var myStringDecrypted: String? = nil

do {

  encryptedData = try myStringToEncrypt.data(using: .utf8)?.aes256Encrypt(withKey: myPrivateKey, initializationVector: iv)

} catch let error as NSError {

  print("\(error)")
}

```

To decrypt, we use the same initialization vector that was used to encrypt and our key again:

```
if let encryptedData = encryptedData {

  do {

    myStringDecrypted = String(bytes: try encryptedData.aes256Decrypt(withKey: myPrivateKey, initializationVector: iv), encoding: .utf8)

  } catch let error as NSError {

    print("\(error)")
  }
}

print("Unencrypted: \(myStringDecrypted)")
```

## Conclusion
I hope this small library/framework is helpful to you in your next Swift project.  I'll be updating as time and inclination permits and of course I welcome all your feedback.

## License
CRDCrypt is released under an Apache 2.0 license. See LICENSE for details.
