//
//  VoiceSelectionPage.swift
//  Echo
//
//  Created by Gavin Henderson on 28/09/2023.
//

import Foundation
import SwiftUI

struct VoicePicker: View {
    var body: some View {
        Text("Voice Picker")
    }
}

struct VoiceSelectionPage: View {
    var body: some View {
        VStack {
            Text("Speaking Voice")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // swiftlint:disable:next line_length
            Text("Your speaking voice is the voice that is used to communicate with your communication partner. Select the options that you want to represent your voice.")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            GroupBox {
                Button(action: {}, label: {
                    Image(systemName: "play.circle")
                    Text("Play Sample")
                    Spacer()
                })
                Divider()
                NavigationLink(destination: {
                    VoicePicker()
                }, label: {
                    
                })
            }
            
            Spacer()
        }
            
            .padding()
            .navigationTitle("Voice Selection")
    }
}

private struct PreviewWrapper: View {
    var body: some View {
        NavigationStack {
            Text("Main Page")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    navigationDestination(isPresented: .constant(true), destination: {
                        VoiceSelectionPage()
                    })
                    
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
}

struct VoiceSelectionPage_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        PreviewWrapper().preferredColorScheme(.light)
    }
}
