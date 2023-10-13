//
//  Helpers.swift
//  Echo
//
//  Created by Gavin Henderson on 03/10/2023.
//

import Foundation
import SwiftUI

func getLanguageAndRegion(_ givenLocale: String) -> String {
    let currentLocale: Locale = .current
    return currentLocale.localizedString(forIdentifier: givenLocale) ?? "Unknown"
}

func getLanguage(_ givenLocale: String) -> String {
    let currentLocale: Locale = .current
    return currentLocale.localizedString(forLanguageCode: givenLocale) ?? "Unknown"
}

func keyToDisplay(_ key: KeyEquivalent) -> String {
    let deleteKey = KeyEquivalent("\u{7F}")
    
    let keyMap: [KeyEquivalent: String] = [
        deleteKey: "<DELETE>",
        .upArrow: "<UP ARROW>",
        .downArrow: "<DOWN ARROW>",
        .leftArrow: "<LEFT ARROW>",
        .rightArrow: "<RIGHT ARROW>",
        .clear: "<CLEAR>",
        .delete: "<BACKSPACE>",
        .deleteForward: "<DELETE FORWARD>",
        .end: "<END>",
        .escape: "<ESC>",
        .home: "<HOME>",
        .pageUp: "<PAGE UP>",
        .return: "<ENTER>",
        .space: "<SPACE>",
        .tab: "<TAB>"
    ]
    
    return keyMap[key] ?? "Key: \"\(key.character.description)\""
}
