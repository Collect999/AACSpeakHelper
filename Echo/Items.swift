//
//  Items.swift
//  Echo
//
//  Created by Gavin Henderson on 02/08/2023.
//

import Foundation
import SwiftUI

class FinishItem: ItemProtocol, Identifiable {
    var id = UUID()
    var displayText: String
    var speakText: String
    var voiceEngine: VoiceEngine
    
    init(_ display: String, voiceEngine: VoiceEngine) {
        self.displayText = display
        self.speakText = displayText
        self.voiceEngine = voiceEngine
    }

    func select(enteredText: String, cb: @escaping (_ enteredText: String) -> Void) {
        voiceEngine.playSpeaking(enteredText) {
            cb("")
        }
    }
    
    func isPredicted() -> Bool {
        return false
    }
}

class BackspaceItem: ItemProtocol, Identifiable {
    var id = UUID()
    var displayText: String
    var speakText = "Undo"
    
    init(_ display: String) {
        self.displayText = display
    }

    func select(enteredText: String, cb: @escaping (_ enteredText: String) -> Void) {
        if enteredText == "" {
            cb("")
            return
        }
        
        // `removeLast` annoyingly mutates the string
        // which means we have to do this copy nonsense
        var mutableCopy = enteredText
        mutableCopy.removeLast()
        cb(mutableCopy)
    }
    
    func isPredicted() -> Bool {
        return false
    }
}

class ClearItem: ItemProtocol, Identifiable {
    var id = UUID()
    var displayText: String = "Clear"
    var speakText = "Clear"

    func select(enteredText: String, cb: @escaping (_ enteredText: String) -> Void) {
        cb("")
    }
    
    func isPredicted() -> Bool {
        return false
    }
}

class LetterItem: ItemProtocol, Identifiable {
    var id = UUID()
    var letter: String
    var displayText: String
    var predicted: Bool
    var speakText: String
    
    init(_ letter: String) {
        self.letter = letter
        self.displayText = letter
        self.predicted = false
        self.speakText = letter
    }
    
    init(_ letter: String, isPredicted: Bool) {
        self.letter = letter
        self.displayText = letter
        self.predicted = isPredicted
        self.speakText = letter

    }
    
    init(_ letter: String, display: String) {
        self.letter = letter
        self.displayText = display
        self.predicted = false
        self.speakText = letter
    }
    
    init(_ letter: String, display: String, speakText: String) {
        self.letter = letter
        self.displayText = display
        self.predicted = false
        self.speakText = speakText
    }
    
    init(_ letter: String, display: String, speakText: String, isPredicted: Bool) {
        self.letter = letter
        self.displayText = display
        self.predicted = isPredicted
        self.speakText = speakText
    }
    
    init(_ letter: String, display: String, isPredicted: Bool) {
        self.letter = letter
        self.displayText = display
        self.predicted = isPredicted
        self.speakText = letter
    }
  
    func isPredicted() -> Bool {
        return self.predicted
    }
    
    func select(enteredText: String, cb: @escaping (_ enteredText: String) -> Void) {
        cb(enteredText + letter)
    }
}

/// This is protocol of an item.
///
/// The reason this is a protocol is because we will define different types of item for example
/// we will want a 'LetterItem' and maybe a 'SentenceItem' and a 'ActionItem'
protocol ItemProtocol: Identifiable {
    var id: UUID { get }
    var displayText: String { get }
    var speakText: String { get }
    func select(enteredText: String, cb: @escaping (_ enteredText: String) -> Void)
    func isPredicted() -> Bool
}

// We need this kinda annoying container due to:
/// https://stackoverflow.com/questions/73773884/any-identifiable-cant-conform-to-identifiable
struct Item: Identifiable {
    var details: any ItemProtocol
    var id: UUID { details.id }
    
    init(letter: String) {
        self.details = LetterItem(letter)
    }
    
    init(letter: String, isPredicted: Bool) {
        self.details = LetterItem(letter, isPredicted: isPredicted)

    }
    
    init(letter: String, display: String) {
        self.details = LetterItem(letter, display: display)
    }
    
    init(letter: String, display: String, speakText: String) {
        self.details = LetterItem(letter, display: display, speakText: speakText)
    }
    
    init(letter: String, display: String, speakText: String, isPredicted: Bool) {
        self.details = LetterItem(letter, display: display, speakText: speakText, isPredicted: isPredicted)
    }
    
    init(actionType: ItemActionType, display: String, voiceEngine: VoiceEngine) {
        switch actionType {
        case .backspace:
            self.details = BackspaceItem(display)
        case .finish:
            self.details = FinishItem(display, voiceEngine: voiceEngine)
        case .clear:
            self.details = ClearItem()
        }

    }
    
    enum ItemActionType {
        case backspace, finish, clear
    }
}
