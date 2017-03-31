#
#  Be sure to run `pod spec lint CRDCrypt.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#

s.name         = "CRDCrypt"
s.version      = "1.0.1"
s.summary      = "Simple and quick way to encrypt/decrypt strings with AES256 on iOS or macOS."
s.description  = <<-DESC
Simple straightforward Swift-based extension to Data for AES256 encryption/decryption for macOS and iOS.
DESC

s.homepage     = "https://github.com/cdisdero/CRDCrypt"

# ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#

s.license      = "Apache License, Version 2.0"

# ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#

s.author             = { "Christopher Disdero" => "info@code.chrisdisdero.com" }

# ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#

s.ios.deployment_target = "9.0"
s.osx.deployment_target = "10.11"

# ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#

s.source       = { :git => "https://github.com/cdisdero/CRDCrypt.git", :tag => "#{s.version}" }

# ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#

s.source_files       = 'Shared/*.{swift,h,m}'
s.ios.source_files   = 'CRDCryptMobile/*.h'
s.osx.source_files   = 'CRDCryptMac/*.h'

end
