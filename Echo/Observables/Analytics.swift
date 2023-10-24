//
//  Analytics.swift
//  Echo
//
//  Created by Gavin Henderson on 24/10/2023.
//

import Foundation
import PostHog
import SwiftUI

enum AnalyticKey: String, CaseIterable {
    case appLaunch
    
    var explaination: String {
        switch self {
        case .appLaunch: return String(
            localized: "When the app is opened",
            comment: "A label for an analytics event"
        )
        }
    }
}

protocol Analytic {
    func getAnalyticData() -> [String: Any]
}

class Analytics: ObservableObject {
    @AppStorage("allowAnalytics") var allowAnalytics = false
    
    var voiceEngine: VoiceEngine?
    var accessOptions: AccessOptions?
    var scanningOptions: ScanningOptions?
    var spellingOptions: SpellingOptions?
    
    var posthog: PHGPostHog?
    
    func load(voiceEngine: VoiceEngine, accessOptions: AccessOptions, scanningOptions: ScanningOptions, spellingOptions: SpellingOptions) {
        self.voiceEngine = voiceEngine
        self.accessOptions = accessOptions
        self.scanningOptions = scanningOptions
        self.spellingOptions = spellingOptions
        
        if allowAnalytics {
            let configuration = PHGPostHogConfiguration(apiKey: "phc_Iu0qJYNNfok6scjPSnKIYF1EKgWDCMpuc8vYGYMLMip", host: "https://app.posthog.com")
            
            configuration.captureApplicationLifecycleEvents = true
            configuration.recordScreenViews = false
            configuration.flushAt = 1
            
            PHGPostHog.setup(with: configuration)
            posthog = PHGPostHog.shared()
        }
    }
        
    func event(_ key: AnalyticKey) {
        let properties: [String: Any] = [:]
            .merging(voiceEngine?.getAnalyticData() ?? [:], uniquingKeysWith: { (current, _) in current })
            .merging(accessOptions?.getAnalyticData() ?? [:], uniquingKeysWith: { (current, _) in current })
            .merging(scanningOptions?.getAnalyticData() ?? [:], uniquingKeysWith: { (current, _) in current })
            .merging(spellingOptions?.getAnalyticData() ?? [:], uniquingKeysWith: { (current, _) in current })

        if let unwrappedPosthog = posthog, allowAnalytics == true {
            print("======")
            print("Event sent:", key.rawValue)
            print(properties)
            print("======")
            unwrappedPosthog.capture(
                key.rawValue,
                properties: [
                    "$set": properties
                ]
            )
        } else {
            print("======")
            print("Event sent, but analytics disabled:", key.rawValue)
            print(properties)
            print("======")
        }
    }
}
