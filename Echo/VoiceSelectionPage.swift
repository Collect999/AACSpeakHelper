//
//  VoiceSelectionPage.swift
//  Echo
//
//  Created by Gavin Henderson on 28/09/2023.
//

import Foundation
import SwiftUI

struct VoiceSelectionSettingsArea: View {
    var title: String
    var helpText: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(helpText)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            GroupBox {
                Button(action: {}, label: {
                    Image(systemName: "play.circle")
                    Text("Play Sample")
                    Spacer()
                })
                Divider().padding(.vertical, 6)
                NavigationLink(destination: {
                    VoicePicker()
                }, label: {
                    HStack {
                        Text("Voice")
                        Spacer()
                        Text("Daniel (English)")
                            .foregroundStyle(.gray)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }.foregroundStyle(.black)
                   
                })
                Divider().padding(.vertical, 6)
                VStack {
                    HStack {
                        Text("Pitch")
                        Spacer()
                        Text("50")
                            .foregroundStyle(.gray)
                    }
                    Slider(
                        value: .constant(50),
                        in: 0...100
                    )
                }
                Divider().padding(.vertical, 6)
                VStack {
                    HStack {
                        Text("Volume")
                        Spacer()
                        Text("50")
                            .foregroundStyle(.gray)
                    }
                    Slider(
                        value: .constant(50),
                        in: 0...100
                    )
                }
                Divider().padding(.vertical, 6)
                VStack {
                    HStack {
                        Text("Rate")
                        Spacer()
                        Text("50")
                            .foregroundStyle(.gray)
                    }
                    Slider(
                        value: .constant(50),
                        in: 0...100
                    )
                }
                
            }
            
            Spacer()
        }
            
            .padding()
            .navigationTitle("Voice Options")
    }
}

struct VoiceSelectionPage: View {
    var body: some View {
        ScrollView {
            VoiceSelectionSettingsArea(
                title: "Speaking Voice",
                // swiftlint:disable:next line_length
                helpText: "Your speaking voice is the voice that is used to communicate with your communication partner. Select the options that you want to represent your voice."
            )
            VoiceSelectionSettingsArea(
                title: "Cue Voice",
                // swiftlint:disable:next line_length
                helpText: "Your cue voice is the voice that is used to speak information to you. Select the options tht you want to hear when Echo is talking to you."
            )
        }
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
