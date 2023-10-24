//
//  AnalyticsOptions.swift
//  Echo
//
//  Created by Gavin Henderson on 24/10/2023.
//

import Foundation
import SwiftUI

struct AnalyticsOptions: View {
    @EnvironmentObject var analytics: Analytics
    
    var body: some View {
        Form {
            Section(content: {
                Toggle(
                    String(
                        localized: "Collect Analytics",
                        comment: "Label for toggle to analytics off and on"
                    ),
                    isOn: analytics.$allowAnalytics
                )
            }, header: {
                Text(
                    "Analytics",
                    comment: "The label for the section about analytics"
                )
            }, footer: {
                Text(
                    """
                    If enabled we collect analytics when the events listed below happen. We collect what your settings are and your basic device information. We will never sell or use your data for marketing purposes, its purely to help us to improve the app.
                    
                    Events:
                    \(AnalyticKey.allCases.map({ x in
                        return "• " + x.explaination
                    }).joined(separator: "\n"))
                    """,
                comment: "A description of the analytics that we capture.")
            })
        }
        .navigationTitle(
            String(
                localized: "Analytics & Telemetry",
                comment: "The navigation title for the Analytics & Telemetry options page"
            )
        )
    }
}
