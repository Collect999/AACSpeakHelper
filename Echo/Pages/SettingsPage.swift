//
//  File.swift
//  Echo
//
//  Created by Gavin Henderson on 28/09/2023.
//

import Foundation
import SwiftUI

enum SettingsPath: CaseIterable, Identifiable {
    case voice, access, scanning, spelling
     
    var id: String {
        switch self {
        case .voice: return "voice"
        case .access: return "access"
        case .scanning: return "scanning"
        case .spelling: return "spelling"
        }
    }
    
    @ViewBuilder var page: some View {
        switch self {
        case .voice: VoiceSelectionPage()
        case .access: AccessOptionsPage()
        case .scanning:  ScanningOptionsPage()
        case .spelling: SpellingAndAlphabetPage()
        }
    }
    
    var description: String {
        switch self {
        case .voice: return String(
            localized: "Voice Selection",
            comment: "Label for the navigation link to the voice options page"
        )
        case .access: return String(
            localized: "Access Methods",
            comment: "Label for the navigation link to the access methods options page"
        )
        case .scanning: return String(
            localized: "Scanning",
            comment: "Label for the navigation link to the scanning options page"
        )
        case .spelling: return String(
            localized: "Spelling & Alphabet",
            comment: "Label for the navigation link to the spelling, alphabet and predictions options page"
        )
        }
    }
}

struct SettingsPagePhone: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Form {
            Group {
                ForEach(SettingsPath.allCases) { settingPage in
                    NavigationLink(destination: {
                        settingPage.page
                    }, label: {
                        Text(settingPage.description)
                    })
                }
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

struct SettingsPagePad: View {
    @State private var selection: SettingsPath? = .voice
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationSplitView {
            List(SettingsPath.allCases, id: \.self, selection: $selection) { path in
                NavigationLink(path.description, value: path)
            }
        } detail: {
            if let unwrappedSelection = selection {
                unwrappedSelection.page
            } else {
                VoiceSelectionPage()
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

// Not a huge fan of this if im honest
struct SettingsPage: View {
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            SettingsPagePad()
        } else {
            SettingsPagePhone()
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
            
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        PreviewWrapper()
    }
}
