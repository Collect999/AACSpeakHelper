//
//  KeyPressController.swift
//  Echo
//
//  Created by Gavin Henderson on 13/10/2023.
//

import Foundation
import SwiftUI

/***
 This whole view is a bit of a hack but it works nicely
 
 For every registered switch it renders a button with a keyboard shortcut. It doesn't visually display anything
 It then triggers the correct action for the given switch
 */
struct KeyPressController: View {
    @EnvironmentObject var items: ItemsList
    @EnvironmentObject var accessOptions: AccessOptions
    
    var body: some View {
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
    }
}
