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
    @Published var scanLoops = 0
    
    var disableScanningAsHidden = false
    
    var predictor: PredictionEngine
    var undoItem: Item?
    var clearItem: Item?
    
    var voiceEngine: VoiceEngine?
    var scanningOptions: ScanningOptions?
    
    var workItem: DispatchWorkItem?
    
    var isFastScan: Bool = false
    
    init() {
        predictor = SlowAndBadPrediciton()
        items = []
        selectedUUID = UUID()
        undoItem = nil
        clearItem = nil
        
        let predictions = predictor.predict(enteredText: enteredText)
        
        items = predictions + items
        
        if let firstItem = items.first {
            selectedUUID = firstItem.id
        }
    }
    
    func cancelScanning() {
        disableScanningAsHidden = true
        if let unwrappedWorkItem = workItem {
            unwrappedWorkItem.cancel()
        }
    }
    
    func allowScanning() {
        disableScanningAsHidden = false
    }
    
    func cancelCurrentItem() {
        if let unwrappedWorkItem = workItem {
            unwrappedWorkItem.cancel()
        }
    }
    
    func startScanningOnAppLaunch() {
        self.moveToUUID(target: selectedUUID, isAppLaunch: true, isAfterSelection: false)
    }
    
    func startScanningOnKeyPress() {
        self.moveToUUID(target: selectedUUID, isAppLaunch: false, isAfterSelection: false, isKeyPress: true)
    }
    
    func loadEngine(_ voiceEngine: VoiceEngine) {
        self.voiceEngine = voiceEngine
        self.undoItem = Item(actionType: .backspace, display: "Undo", voiceEngine: voiceEngine)
        self.clearItem = Item(actionType: .clear, display: "Clear", voiceEngine: voiceEngine)
    }
    
    func loadScanning(_ scanning: ScanningOptions) {
        self.scanningOptions = scanning
    }
    
    private func getIndexOfSelectedItem() -> Int {
        let currentIndex = items.firstIndex(where: { $0.id == selectedUUID })
        
        return currentIndex ?? 0
    }
    
    func back(userInteraction: Bool = false) {
        if userInteraction { scanLoops = 0 }

        move(moveBy: -1, reset: false)
    }
    
    func setNextMoveTimer() {
        let isScanningEnabled = scanningOptions?.scanning ?? false
        if !isScanningEnabled { return }
        
        if disableScanningAsHidden { return }
        
        let newWorkItem = DispatchWorkItem(block: {
            self.next()
        })
        
        workItem = newWorkItem
        let timeInterval = scanningOptions?.scanWaitTime ?? 3
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: newWorkItem)
    }
    
    func startFastScan() {
        let currentIndex = self.getIndexOfSelectedItem()
        let newIndex = (currentIndex + 1) % items.count
        
        let wrappedIndex = newIndex < 0 ? items.count + newIndex : newIndex
        
        let newItem = items[wrappedIndex]
        
        selectedUUID = newItem.id
        isFastScan = true
        
        voiceEngine?.playFastCue(newItem.details.speakText) {
            if self.isFastScan {
                self.startFastScan()
            }
        }
    }
    
    func stopFastScan() {
        isFastScan = false
    }
    
    func move(moveBy: Int = 1, reset: Bool = false) {
        self.cancelCurrentItem()
                
        let currentIndex = self.getIndexOfSelectedItem()
        var newIndex = (currentIndex + moveBy) % items.count
        
        if newIndex == 0 {
            scanLoops += 1
        }
        
        if reset == true {
            newIndex = 0
        }
        
        let wrappedIndex = newIndex < 0 ? items.count + newIndex : newIndex
        
        let newItem = items[wrappedIndex]
        
        selectedUUID = newItem.id
        
        voiceEngine?.playCue(newItem.details.speakText) {
            let maxScanLoops = self.scanningOptions?.scanLoops ?? 1
            
            if reset == true && (self.scanningOptions?.scanAfterSelection ?? false) == true {
                self.setNextMoveTimer()
                return
            }
            
            if self.scanLoops < maxScanLoops && reset == false {
                self.setNextMoveTimer()
                return
            }
            
        }
    }
    
    func moveToUUID(target: UUID, isAppLaunch: Bool, isAfterSelection: Bool, isKeyPress: Bool = false) {
        if let newItem = items.first(where: { $0.id == target }) {
            voiceEngine?.playCue(newItem.details.speakText) {
                if isKeyPress {
                    self.setNextMoveTimer()
                } else if isAppLaunch && (self.scanningOptions?.scanOnAppLaunch ?? false) {
                    self.setNextMoveTimer()
                } else if isAfterSelection && (self.scanningOptions?.scanAfterSelection ?? false) {
                    self.setNextMoveTimer()
                }
            }
            self.selectedUUID = target
        } else {
            self.move(reset: true)
        }
    }
    
    /***
     Move onto the next item in the list
     */
    func next(reset: Bool = false, userInteraction: Bool = false) {
        if userInteraction { scanLoops = 0 }
        
        move(moveBy: 1, reset: reset)
    }
    
    func backspace(userInteraction: Bool = false) {
        select(overrideItem: undoItem, userInteraction: userInteraction)
    }
    
    func clear(userInteraction: Bool = false) {
        select(overrideItem: clearItem, userInteraction: userInteraction)
    }
    
    /***
     Select the current item in the list
     
     'Select' will perform different actions depending on the item that is currently focused
     */
    func select(overrideItem: Item? = nil, userInteraction: Bool = true) {
        cancelCurrentItem()
        if userInteraction { scanLoops = 0 }

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
            self.moveToUUID(target: newTargetItem.id, isAppLaunch: false, isAfterSelection: true)
        }
    }
    
}
