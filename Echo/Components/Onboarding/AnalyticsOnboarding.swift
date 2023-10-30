//
//  Analytics.swift
//  Echo
//
//  Created by Gavin Henderson on 30/10/2023.
//

import Foundation
import SwiftUI

struct AnalyticsOnboarding: View {
    @EnvironmentObject var analytics: Analytics
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Image(systemName: "chart.xyaxis.line")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(Color("aceBlue"))
                Spacer()
            }
            
            BottomText(
                topText: AttributedString(
                    localized: "Collect Analytics?",
                    comment: "Header for analytics onboarding page"
                ),
                bottomText: AttributedString(
                    localized: "We collect analytics to help us improve the app. All data is anonymised and never shared with any third party.",
                    comment: "Explaination of analytics controls"
                )
            )
            Picker(String(localized: "Analytics", comment: "Label for analytics picker"), selection: analytics.$allowAnalytics) {
                Text("Do not track", comment: "Label to disable swipe").tag(false)
                Text("Allow tracking", comment: "Label to enable swipe").tag(true)
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal)
        .padding(.bottom, 64)
    }
}
