//
//  EchoApp.swift
//  Echo
//
//  Created by Gavin Henderson on 14/07/2023.
//

import SwiftUI

@main
struct EchoApp: App {
    @StateObject var voiceEngine: VoiceEngine = VoiceEngine()
    @StateObject var itemsList: ItemsList = ItemsList()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(voiceEngine)
                .environmentObject(itemsList)
                .onAppear {
                    voiceEngine.load()
                    itemsList.loadEngine(voiceEngine)
                }
                .onDisappear {
                    voiceEngine.save()
                }
        }
        
    }
}
