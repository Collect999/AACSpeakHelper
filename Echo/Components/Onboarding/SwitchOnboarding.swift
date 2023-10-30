//
//  SwitchOnboarding.swift
//  Echo
//
//  Created by Gavin Henderson on 30/10/2023.
//

import Foundation
import SwiftUI

struct SwitchOnboarding: View {
    @EnvironmentObject var accessOptions: AccessOptions
    @State var showNewSwitchSheet = false
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Image(systemName: "button.horizontal.top.press")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color("aceBlue"))
                Spacer()
            }
            
            BottomText(
                topText: AttributedString(
                    localized: "Switch Control",
                    comment: "Header for switch control in onboarding page"
                ),
                bottomText: AttributedString(
                    localized: "Control Echo using switch presses to perform actions. Add new switches and change what they trigger.",
                    comment: "Description describing what switch access is"
                )
            )
            Form {
                Section(content: {
                    Toggle(
                        String(
                            localized: "Switch Control",
                            comment: "Label for toggle to turn switch control off and on"
                        ),
                        isOn: $accessOptions.enableSwitchControl
                    )
                    
                    ForEach(accessOptions.listOfSwitches) { currentSwitch in
                        NavigationLink(destination: {
                            AddSwitch(
                                switchName: currentSwitch.name,
                                selectedKey: currentSwitch.key,
                                tapAction: currentSwitch.tapAction,
                                holdAction: currentSwitch.holdAction,
                                id: currentSwitch.id
                            )
                        }, label: {
                            HStack {
                                Text(currentSwitch.name)
                                Spacer()
                                Text(keyToDisplay(currentSwitch.key))
                                    .foregroundStyle(.gray)
                            }
                        })
                    }
                    
                    Button(action: {
                        showNewSwitchSheet.toggle()
                    }, label: {
                        Label(
                            String(
                                localized: "Add Switch",
                                comment: "Button label to add a new switch to the list"
                            ),
                            systemImage: "plus.circle.fill"
                        )
                    })
                })
                .onDisappear {
                    accessOptions.save()
                }
                .sheet(isPresented: $showNewSwitchSheet) {
                    AddSwitch()
                }
            }
            .scrollContentBackground(.hidden)
        }
        
    }
}
