//
//  SpellingAndAlphabetPage.swift
//  Echo
//
//  Created by Gavin Henderson on 18/10/2023.
//

import Foundation
import SwiftUI

struct SpellingAndAlphabetPage: View {
    @EnvironmentObject var spellingOptions: SpellingOptions
    
    var body: some View {
        Form {
            Section(content: {
                Toggle(
                    String(
                        localized: "Letter prediction",
                        comment: "Label for toggle to turn letter based prediction off and on"
                    ),
                    isOn: spellingOptions.$letterPrediction
                )
                Toggle(
                    String(
                        localized: "Word prediction",
                        comment: "Label for toggle to turn word prediction off and on"
                    ),
                    isOn: spellingOptions.$wordPrediction
                )
                if spellingOptions.wordPrediction {
                    Stepper(
                        value: spellingOptions.$wordPredictionLimit,
                        in: 1...10,
                        step: 1
                    ) {
                        HStack {
                            Text(
                                "Word prediction limit",
                                comment: "Label for the stepper that controls word prediction limit"
                            )
                            Spacer()
                            Text(String(spellingOptions.wordPredictionLimit))
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }, header: {
                Text(
                    "Prediction",
                    comment: "Label for the section in settings about prediction"
                )
            }, footer: {
                Text(
                    "Prediction helps you to get to the words you want to speak faster",
                    comment: "Footer for the section in settings about prediction"
                )
            })
        }
    }
}

private struct PreviewWrapper: View {
    @StateObject var spellingOptions = SpellingOptions()

    var body: some View {
        SpellingAndAlphabetPage()
            .environmentObject(spellingOptions)
    }
}

private struct SpellingAndAlphabetPage_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        PreviewWrapper()
    }
}
