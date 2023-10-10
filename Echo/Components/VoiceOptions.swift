//
//  VoiceOptions.swift
//  Echo
//
//  Created by Gavin Henderson on 04/10/2023.
//

import Foundation
import SwiftUI

struct VoiceOptionsArea: View {
    var title: String
    var helpText: String
    
    @Binding var pitch: Double
    @Binding var rate: Double
    @Binding var volume: Double
    @Binding var voiceId: String
    @Binding var voiceName: String
    
    var playSample: () -> Void
    
    var body: some View {
        Section(content: {
            Button(action: {
                playSample()
            }, label: {
                Label("Play Sample", systemImage: "play.circle")
            })
            NavigationLink(destination: {
                VoicePicker(
                    voiceId: $voiceId,
                    voiceName: $voiceName
                )
            }, label: {
                HStack {
                    Text("Voice")
                    Spacer()
                    Text(voiceName)
                        .foregroundStyle(.gray)
                }.foregroundStyle(.black)
               
            })
            VStack {
                HStack {
                    Text("Pitch")
                    Spacer()
                    Text(String(Int(pitch)))
                        .foregroundStyle(.gray)
                }
                Slider(
                    value: $pitch,
                    in: 0...100,
                    onEditingChanged: { isEditing in
                        if isEditing == false {
                            playSample()
                        }
                    }
                )
            }
            VStack {
                HStack {
                    Text("Volume")
                    Spacer()
                    Text(String(Int(volume)))
                        .foregroundStyle(.gray)
                }
                Slider(
                    value: $volume,
                    in: 0...100,
                    onEditingChanged: { isEditing in
                        if isEditing == false {
                            playSample()
                        }
                    }
                )
            }
            
            VStack {
                HStack {
                    Text("Rate")
                    Spacer()
                    Text(String(Int(rate)))
                        .foregroundStyle(.gray)
                }
                Slider(
                    value: $rate,
                    in: 0...100,
                    onEditingChanged: { isEditing in
                        if isEditing == false {
                            playSample()
                        }
                    }
                )
            }
            
        }, header: {
            Text(title)
        }, footer: {
            Text(helpText)
        })
        .navigationTitle("Voice Options")
    }
}
