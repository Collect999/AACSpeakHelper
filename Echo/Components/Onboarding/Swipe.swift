//
//  Swipe.swift
//  Echo
//
//  Created by Gavin Henderson on 27/10/2023.
//

import Foundation
import SwiftUI

struct SwipeOnboarding: View {
    @EnvironmentObject var access: AccessOptions
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Image(systemName: "hand.draw")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(Color("aceBlue"))
                Spacer()
            }
            
            BottomText(
                topText: AttributedString(
                    localized: "Swipe?",
                    comment: "Header for swipe onboarding page"
                ),
                bottomText: AttributedString(
                    localized: "Control Echo using Swipes",
                    comment: "Explaination of swipe controls"
                )
            )
            Picker(String(localized: "Swipe Gestures", comment: "Label for swipe picker"), selection: access.$allowSwipeGestures) {
                Text("Disable", comment: "Label to disable swipe").tag(false)
                Text("Enable", comment: "Label to enable swipe").tag(true)
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal)
        .padding(.bottom, 64)
    }
}
