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
    @StateObject var accessOptions: AccessOptions = AccessOptions()
    @StateObject var scanningOptions: ScanningOptions = ScanningOptions()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(voiceEngine)
                .environmentObject(itemsList)
                .environmentObject(accessOptions)
                .environmentObject(scanningOptions)
                .onAppear {
                    voiceEngine.load()
                    accessOptions.load()
                    itemsList.loadEngine(voiceEngine)
                    itemsList.loadScanning(scanningOptions)
                }
                .onDisappear {
                    voiceEngine.save()
                    accessOptions.save()
                }
        }
        
    }
}
