//
//  ItemsList.swift
//  Echo
//
//  Created by Gavin Henderson on 03/10/2023.
//

import Foundation
import SwiftUI

class ItemsList: ObservableObject {
    @Published var items: [Item]
    @Published var selectedUUID: UUID
    @Published var enteredText = ""
    
    var predictor: PredictionEngine
    var undoItem: Item?
    
    var voiceEngine: VoiceEngine?
    
    init() {
        predictor = SlowAndBadPrediciton()
        items = []
        selectedUUID = UUID()
        undoItem = nil
        
        let predictions = predictor.predict(enteredText: enteredText)
        
        items = predictions + items
        
        if let firstItem = items.first {
            selectedUUID = firstItem.id
        }
    }
    
    func loadEngine(_ voiceEngine: VoiceEngine) {
        self.voiceEngine = voiceEngine
        self.undoItem = Item(actionType: .backspace, display: "Undo", voiceEngine: voiceEngine)
    }
    
    func reset() {
        if let firstItem = items.first {
            selectedUUID = firstItem.id
        }
    }
    
    private func getIndexOfSelectedItem() -> Int {
        let currentIndex = items.firstIndex(where: { $0.id == selectedUUID })
        
        return currentIndex ?? 0
    }
    
    func back() {
        move(moveBy: -1, reset: false)
    }
    
    func move(moveBy: Int = 1, reset: Bool = false) {
        let currentIndex = self.getIndexOfSelectedItem()
        var newIndex = (currentIndex + moveBy) % items.count
        
        if reset == true {
            newIndex = 0
        }
        
        let wrappedIndex = newIndex < 0 ? items.count + newIndex : newIndex
        
        let newItem = items[wrappedIndex]
        
        selectedUUID = newItem.id
        
        voiceEngine?.playCue(newItem.details.speakText) {}
    }
    
    func moveToUUID(target: UUID) {
        if let newItem = items.first(where: { $0.id == target }) {
            voiceEngine?.playCue(newItem.details.speakText) {}
            self.selectedUUID = target
        } else {
            self.move(reset: true)
        }
    }
    
    /***
     Move onto the next item in the list
     */
    func next(reset: Bool = false) {
        move(moveBy: 1, reset: reset)
    }
    
    func backspace() {
        select(overrideItem: undoItem)
    }
    
    /***
     Select the current item in the list
     
     'Select' will perform different actions depending on the item that is currently focused
     */
    func select(overrideItem: Item? = nil) {
        let currentItem = overrideItem ?? items[getIndexOfSelectedItem()]
        
        currentItem.details.select(enteredText: enteredText) { newText in
            self.enteredText = newText
            
            let predictions = self.predictor.predict(enteredText: self.enteredText)
            var prefixItems: [Item] = []
            
            let finishedText = "Current Sentence: " + self.enteredText
            
            guard let unwrappedEngine = self.voiceEngine else {
                print("Something went very wrong")
                return
            }
            
            let fullSentenceItem = Item(actionType: .finish, display: finishedText, voiceEngine: unwrappedEngine)
            var newTargetItem = fullSentenceItem
            if self.enteredText.count > 0 {
                prefixItems.append(fullSentenceItem)
            }
            
            let splitBySpace = self.enteredText.components(separatedBy: "·")
            let prefix = splitBySpace.last ?? ""
            let prefixWithHyphens = "Current Word: " + String(Array(prefix.split(separator: "")).joined(separator: "·"))
            let prefixItem = Item(
                letter: "·",
                display: "Current Word: " + prefix,
                speakText: prefixWithHyphens,
                isPredicted: true
            )
            if prefix.count > 0 {
                prefixItems.append(prefixItem)
                newTargetItem = prefixItem
            }
            
            self.items = prefixItems + predictions
            self.moveToUUID(target: newTargetItem.id)
        }
    }
    
}
