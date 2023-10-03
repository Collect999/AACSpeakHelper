//
//  VoiceSelectionPage.swift
//  Echo
//
//  Created by Gavin Henderson on 28/09/2023.
//

import Foundation
import SwiftUI
import AVFAudio

private func getLanguage(_ givenLocale: String) -> String {
    let currentLocale: Locale = .current
    return currentLocale.localizedString(forLanguageCode: givenLocale) ?? "Unknown"
}

class SelectedVoice: ObservableObject {
    @Published var pitch: Double = 25
    @Published var volume: Double = 100
    @Published var rate: Double = 50
    @Published var selectedVoiceId = ""
    @Published var selectedVoiceName = ""
    
    var selectedVoice: AVSpeechSynthesisVoice = AVSpeechSynthesisVoice()
    var synthesizer = AVSpeechSynthesizer()
    
    init(_ behaviour: InitBehaviour) {
        let langCode = AVSpeechSynthesisVoice.currentLanguageCode()
        if let defaultVoice = AVSpeechSynthesisVoice(language: langCode) {
            // If the default voice is the given gender use that
            if behaviour == .defaultVoice {
                selectNewVoice(newVoiceId: defaultVoice.identifier)
            } else { // Otherwise select the first voice of the opposite gender in the given language
                
                // For some reason, when you get a voice by language the gender is unspecified.
                // When you get the exact same voice by identifier it has a gender.
                let defaultVoiceFull = AVSpeechSynthesisVoice(identifier: defaultVoice.identifier) ?? AVSpeechSynthesisVoice()
                let defaultGender = defaultVoiceFull.gender
                let targetGender: AVSpeechSynthesisVoiceGender = defaultGender == .male ? .female : .male
                
                let voices = AVSpeechSynthesisVoice
                    .speechVoices()
                    .filter({
                        $0.language == langCode
                    })
                
                let targetVoice = voices.first(where: { $0.gender == targetGender })
                let voice = targetVoice ?? voices[0]
                selectNewVoice(newVoiceId: voice.identifier)
            }
            
        }
  
        // This makes it work in silent mode by setting the audio to playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        } catch let error {
            print("This error message from SpeechSynthesizer \(error.localizedDescription)")
        }
    }
    
    func selectNewVoice(newVoiceId: String) {
        selectedVoice = AVSpeechSynthesisVoice(identifier: newVoiceId) ?? AVSpeechSynthesisVoice()
        selectedVoiceId = selectedVoice.identifier
        selectedVoiceName = "\(selectedVoice.name) (\(getLanguage(selectedVoice.language)))"
    }
    
    func playSample() {
        let utterance = AVSpeechUtterance(string: "Thank you for using Echo")
        utterance.voice = selectedVoice
        utterance.pitchMultiplier = Float(((pitch * 1.5) / 100) + 0.5) // Pitch is between 0.5 - 2
        utterance.volume = Float(volume / 100) // Volume is between 0 - 1
        utterance.rate = Float(rate / 100) // Rate is between 0 - 1
        
        self.synthesizer.stopSpeaking(at: .immediate)
        self.synthesizer.speak(utterance)
    }
    
    enum InitBehaviour {
        case defaultVoice, oppositeGenderToDefault
    }
}

struct VoiceSelectionSettingsArea: View {
    var title: String
    var helpText: String
    @ObservedObject var selectedVoice: SelectedVoice
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(helpText)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            GroupBox {
                Button(action: {
                    selectedVoice.playSample()
                }, label: {
                    Image(systemName: "play.circle")
                    Text("Play Sample")
                    Spacer()
                })
                Divider().padding(.vertical, 6)
                NavigationLink(destination: {
                    VoicePicker(selectedVoice: selectedVoice )
                }, label: {
                    HStack {
                        Text("Voice")
                        Spacer()
                        Text(selectedVoice.selectedVoiceName)
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
                        Text(String(Int(selectedVoice.pitch)))
                            .foregroundStyle(.gray)
                    }
                    Slider(
                        value: $selectedVoice.pitch,
                        in: 0...100,
                        onEditingChanged: { isEditing in
                            if isEditing == false {
                                selectedVoice.playSample()
                            }
                        }
                    )
                }
                Divider().padding(.vertical, 6)
                VStack {
                    HStack {
                        Text("Volume")
                        Spacer()
                        Text(String(Int(selectedVoice.volume)))
                            .foregroundStyle(.gray)
                    }
                    Slider(
                        value: $selectedVoice.volume,
                        in: 0...100,
                        onEditingChanged: { isEditing in
                            if isEditing == false {
                                selectedVoice.playSample()
                            }
                        }
                    )
                }
                Divider().padding(.vertical, 6)
                VStack {
                    HStack {
                        Text("Rate")
                        Spacer()
                        Text(String(Int(selectedVoice.rate)))
                            .foregroundStyle(.gray)
                    }
                    Slider(
                        value: $selectedVoice.rate,
                        in: 0...100,
                        onEditingChanged: { isEditing in
                            if isEditing == false {
                                selectedVoice.playSample()
                            }
                        }
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
    @StateObject var speakingVoice = SelectedVoice(.defaultVoice)
    @StateObject var cueVoice = SelectedVoice(.oppositeGenderToDefault)

    var body: some View {
        ScrollView {
            VoiceSelectionSettingsArea(
                title: "Speaking Voice",
                // swiftlint:disable:next line_length
                helpText: "Your speaking voice is the voice that is used to communicate with your communication partner. Select the options that you want to represent your voice.",
                selectedVoice: speakingVoice
            )
            VoiceSelectionSettingsArea(
                title: "Cue Voice",
                // swiftlint:disable:next line_length
                helpText: "Your cue voice is the voice that is used to speak information to you. Select the options tht you want to hear when Echo is talking to you.",
                selectedVoice: cueVoice
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
