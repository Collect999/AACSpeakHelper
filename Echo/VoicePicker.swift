//
//  VoicePicker.swift
//  Echo
//
//  Created by Gavin Henderson on 29/09/2023.
//

import Foundation
import SwiftUI
import AVFAudio

private func getFullLanguage(_ givenLocale: String) -> String {
    let currentLocale: Locale = .current
    return currentLocale.localizedString(forIdentifier: givenLocale) ?? "Unknown"
}

class VoiceGroup {
    var voices: [AVSpeechSynthesisVoice] = []
    var language: String
    
    init(voices: [AVSpeechSynthesisVoice], language: String) {
        self.voices = voices
        self.language = language
    }
}

class VoiceList: ObservableObject {
    @Published var voices: [AVSpeechSynthesisVoice] = []
    @Published var voicesByLang: [String: [AVSpeechSynthesisVoice]]
    
    init() {
        voices = AVSpeechSynthesisVoice.speechVoices()
        voicesByLang = [:]
        for voice in voices {
            var currentList = voicesByLang[voice.language] ?? []
            currentList.append(voice)
            voicesByLang[voice.language] = currentList
        }
    }
    
    /***
        Sorts all the languages availble by the following criteria
     
        * Push users language and region to the top
        * Push users language to the top
        * Sort alphabetically (by display name)
     */
    func sortedKeys() -> [String] {
        let currentLocale: String = Locale.current.language.languageCode?.identifier ?? "en"
        let currentIdentifier: String = Locale.current.identifier(.bcp47)
        
        return Array(voicesByLang.keys).sorted(by: {
            let zeroLocale = Locale(identifier: $0).language.languageCode?.identifier ?? "en"
            let oneLocale = Locale(identifier: $1).language.languageCode?.identifier ?? "en"
            let zeroFullLanguage = getFullLanguage($0)
            let oneFullLanguage = getFullLanguage($1)
            
            if $0 == currentIdentifier {
                return true
            }
            
            if $1 == currentIdentifier {
                return false
            }
            
            if zeroLocale == currentLocale && oneLocale == currentLocale {
                return zeroFullLanguage < oneFullLanguage
            }
            
            if zeroLocale == currentLocale {
                return true
            }
            
            if oneLocale == currentLocale {
                return false
            }
            
            return zeroFullLanguage < oneFullLanguage

        })
    }
}

struct VoicePicker: View {
    @StateObject var voiceList = VoiceList()
    
    var body: some View {
        ScrollView {
            ForEach(voiceList.sortedKeys(), id: \.self) { lang in
                Text(getFullLanguage(lang))
//                GroupBox {
//                    ForEach(voiceList.voicesByLang[lang], id: \.id) { voice in
//                      Text("huh")
//                    }
//                }
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
                        VoicePicker()
                    })
                    
                }
            }
            .navigationTitle("Voice Options")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
}

struct VoicePickerPage_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        PreviewWrapper().preferredColorScheme(.light)
    }
}
