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
    @State var isCopied: Bool = false
    
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
                        return "• " + x.explanation
                    }).joined(separator: "\n"))
                    """,
                comment: "A description of the analytics that we capture.")
            })
            Section(content: {
                VStack {
                    Text(analytics.anonId)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    Button(
                        isCopied ?
                            String(localized: "Copied!", comment: "Label thats shown when text is copied")
                            :
                            String(localized: "Copy to clipboard", comment: "Label thats shown prompting the user to copy text"),
                        systemImage: "clipboard",
                        action: {
                            UIPasteboard.general.string = analytics.anonId
                            isCopied = true
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }, header: {
                Text("Analytics ID", comment: "Label for the section that shows the users analytics ID")
            }, footer: {
                Text(
                    "This ID is used to identify you in the analytics collected. Do not share it unless you are willing to be identified.",
                    comment: "Explanation of what an ID is"
                )
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
