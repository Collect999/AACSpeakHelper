#!/bin/sh

#  ci_post_clone.sh
#  Echo
#
#  Created by Gavin Henderson on 27/09/2023.
#  

defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
brew install swiftlint
