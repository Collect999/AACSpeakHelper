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
        Form {
            Group {
                NavigationLink(destination: {
                    VoiceSelectionPage()
                }, label: {
                    Text(
                        "Voice Selection",
                        comment: "Label for the navigation link to the voice options page"
                    )
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.black)
                })
                NavigationLink(destination: {
                    AccessOptionsPage()
                }, label: {
                    Text(
                        "Access Methods",
                        comment: "Label for the navigation link to the access methods options page"
                    )
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.black)
                })
                NavigationLink(destination: {
                    ScanningOptionsPage()
                }, label: {
                    Text(
                        "Scanning",
                        comment: "Label for the navigation link to the scanning options page"
                    )
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.black)
                })
                NavigationLink(destination: {
                    SpellingAndAlphabetPage()
                }, label: {
                    Text(
                        "Spelling & Alphabet",
                        comment: "Label for the navigation link to the spelling, alphabet and predictions options page"
                    )
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.black)
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(
            String(
                localized: "Settings",
                comment: "The navigation title for the settings page"
            )
        )
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back", comment: "The button text for the navigation back button")
                    }
                })
            }
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
