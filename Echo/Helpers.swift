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

// swiftlint:disable function_body_length
func keyToDisplay(_ key: KeyEquivalent) -> String {
    let deleteKey = KeyEquivalent("\u{7F}")
    
    let keyMap: [KeyEquivalent: String] = [
        deleteKey: String(
            localized: "<DELETE>",
            comment: "A description of the delete key on a keyboard, please use all caps and <>"
        ),
        .upArrow: String(
            localized: "<UP ARROW>",
            comment: "A description of the up arrow key on a keyboard, please use all caps and <>"
        ),
        .downArrow: String(
            localized: "<DOWN ARROW>",
            comment: "A description of the down arrow on a keyboard, please use all caps and <>"
        ),
        .leftArrow: String(
            localized: "<LEFT ARROW>",
            comment: "A description of the left arrow on a keyboard, please use all caps and <>"
        ),
        .rightArrow: String(
            localized: "<RIGHT ARROW>",
            comment: "A description of the right arrow on a keyboard, please use all caps and <>"
        ),
        .clear: String(
            localized: "<CLEAR>",
            comment: "A description of the clear key on a keyboard, please use all caps and <>"
        ),
        .delete: String(
            localized: "<BACKSPACE>",
            comment: "A description of the backspace key on a keyboard, please use all caps and <>"
        ),
        .deleteForward: String(
            localized: "<DELETE FORWARD>",
            comment: "A description of the delete forward key on a keyboard, please use all caps and <>"
        ),
        .end: String(
            localized: "<END>",
            comment: "A description of the end key on a keyboard, please use all caps and <>"
        ),
        .escape: String(
            localized: "<ESC>",
            comment: "A description of the escape key on a keyboard, please use all caps and <>"
        ),
        .home: String(
            localized: "<HOME>",
            comment: "A description of the home key on a keyboard, please use all caps and <>"
        ),
        .pageUp: String(
            localized: "<PAGE UP>",
            comment: "A description of the page up key on a keyboard, please use all caps and <>"
        ),
        .return: String(
            localized: "<ENTER>",
            comment: "A description of the enter key on a keyboard, please use all caps and <>"
        ),
        .space: String(
            localized: "<SPACE>",
            comment: "A description of the space bar key on a keyboard, please use all caps and <>"
        ),
        .tab: String(
            localized: "<TAB>",
            comment: "A description of the tab key on a keyboard, please use all caps and <>"
        )
    ]
    
    return keyMap[key] ?? "Key: \"\(key.character.description)\""
}
// swiftlint:enable function_body_length
