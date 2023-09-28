//
//  File.swift
//  Echo
//
//  Created by Gavin Henderson on 28/09/2023.
//

import Foundation
import SwiftUI

struct SettingsPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Text("New settings")
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    })
                }
            }
        
    }
}

struct PreviewWrapper: View {
    var body: some View {
        NavigationStack {
            Text("Main Page")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    navigationDestination(isPresented: .constant(true), destination: {
                        SettingsPage()
                    })
                    
                }
            }
            .navigationTitle("Echo: Auditory Scanning")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        PreviewWrapper()
    }
}
