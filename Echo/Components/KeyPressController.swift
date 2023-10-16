//
//  KeyPressController.swift
//  Echo
//
//  Created by Gavin Henderson on 13/10/2023.
//

import Foundation
import SwiftUI

enum KeyStage {
    case unpressed, pressed, held
}

/***
 This whole view is a bit of a hack but it works nicely
 
 For every registered switch it renders a button with a keyboard shortcut. It doesn't visually display anything
 It then triggers the correct action for the given switch
 */
struct KeyPressController: View {
    @EnvironmentObject var items: ItemsList
    @EnvironmentObject var accessOptions: AccessOptions
    
    @FocusState var focused
        
    // This method does complain that 'Publishing changes from within view updates is not allowed,
    // this will cause undefined behavior.'
    // Im not sure why because im changing it in an onKeyPress function not a view update
    // However, because we dont display keyMap we shouldn't get any 'undefined behaviour'
    @State var keyMap: [KeyEquivalent: KeyStage] = [:]
    @State var workItemsMap: [KeyEquivalent: DispatchWorkItem] = [:]
    
    func doAction(action: Action) {
        switch action {
        case .none:
            print("No action")
        case .next:
            items.next(userInteraction: true)
        case .back:
            items.back(userInteraction: true)
        }
    }
    
    var body: some View {
        Text("Capturing Keys")
            .opacity(0)
            .focusable()
            .focused($focused)
            .onAppear {
                focused = true
            }
            .onKeyPress(phases: [.all]) { press in
                // We only want to capture buttons that the user has specifed
                guard let currentSwitch = accessOptions.listOfSwitches.first(where: { $0.key == press.key }) else {
                    return .ignored
                }
                
                let currentKeyStage = keyMap[press.key] ?? .unpressed
                
                // Deal with keydown event
                if press.phase == .down {
                    self.keyMap.updateValue(.pressed, forKey: press.key)
                    
                    // Cancel any previous work items now we have a new keypress
                    let lastWorkItem = self.workItemsMap[press.key]
                    lastWorkItem?.cancel()
                    
                    // Shedule hold callback
                    let newWorkItem = DispatchWorkItem(block: {
                        let keyStage = keyMap[press.key] ?? .unpressed
                        
                        print("Held threshold met", keyStage)
                        
                        if keyStage == .pressed {
                            self.keyMap.updateValue(.held, forKey: press.key)
                            
                            doAction(action: currentSwitch.holdAction)
                        }
                    })
                    
                    let timeInterval = 1.0
                    self.workItemsMap.updateValue(newWorkItem, forKey: press.key)
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: newWorkItem)
                }
                
                // When the key is up we need to do our action
                if press.phase == .up {
                    // Normal length press
                    if currentKeyStage == .pressed {
                        print("Normal Press Release", press.key.character.debugDescription)
                        
                        doAction(action: currentSwitch.tapAction)
                    }
                    
                    // The key was held for longer than the threshold
                    if currentKeyStage == .held {
                        print("Hold Press Release", press.key.character.debugDescription)
                    }
                    
                    self.keyMap.updateValue(.unpressed, forKey: press.key)
                }
                
                return .handled
            }

    }
}

/**
 .onKeyPress is only on iOS 17. We can use the following hack if we
 want to back support older versions but it doesnt support 'hold' press
 
         Group {
             ForEach($accessOptions.listOfSwitches) { $currentSwitch in
                 Button(action: {
                     switch currentSwitch.tapAction {
                     case .none:
                         return
                     case .next:
                         items.next(userInteraction: true)
                         return
                     case .back:
                         items.back(userInteraction: true)
                         return
                     }
                 }, label: {
                     Text("Hidden button for switch: \(currentSwitch.name)")
                 })
                 .keyboardShortcut(currentSwitch.key, modifiers: [])
             }
         }
         .opacity(0)
 
 */
