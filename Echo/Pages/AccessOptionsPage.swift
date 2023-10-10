//
//  AccessOptionsPage.swift
//  Echo
//
//  Created by Gavin Henderson on 04/10/2023.
//

import Foundation
import SwiftUI

struct AccessOptionsPage: View {
    @EnvironmentObject var accessOptions: AccessOptions
    
    @State var showNewSwitchSheet = false
    
    var body: some View {
        Form {
            Section(content: {
                Toggle("Show on-screen arrows", isOn: $accessOptions.showOnScreenArrows)
            }, header: {
                Text("On-screen")
            })
            
            Section(content: {
                Toggle("Swiping gestures", isOn: $accessOptions.allowSwipeGestures)

            }, footer: {
                Text("""
            Swipe up, down, left or right to control Echo
               • **Right:** Select the current item
               • **Down:** Go to the next item in the list
               • **Left:** Remove the last entered character
               • **Up:** Go to the previous item in the list
            """)
            })
            
            Section(content: {
                Toggle("Switch Control", isOn: .constant(false))
                Button(action: {
                    showNewSwitchSheet.toggle()
                }, label: {
                    Label("Add Switch", systemImage: "plus.circle.fill")
                })
            }, footer: {
                Text("""
                Control Echo using switch presses to perform actions. Add new switches and change what they trigger.
                """)
            })
        }
        .onDisappear {
            accessOptions.save()
        }
        .sheet(isPresented: $showNewSwitchSheet) {
            AddSwitch(sheetState: $showNewSwitchSheet)
        }
    }
}

private struct PreviewWrapper: View {
    @StateObject var accessOptions: AccessOptions = AccessOptions()

    var body: some View {
        NavigationStack {
            Text("Main Page")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    navigationDestination(isPresented: .constant(true), destination: {
                        AccessOptionsPage()
                            .environmentObject(accessOptions)
                    })
                    
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct AccessOptionsPage_Previews: PreviewProvider {
    
    static var previews: some SwiftUI.View {
        PreviewWrapper().preferredColorScheme(.light)
            
    }
}
