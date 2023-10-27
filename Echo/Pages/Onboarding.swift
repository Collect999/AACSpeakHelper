//
//  Onboarding.swift
//  Echo
//
//  Created by Gavin Henderson on 26/10/2023.
//

import Foundation
import SwiftUI
import AVKit

struct NextButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 52)
            .padding(.vertical)
            .background(Color("aceBlue"))
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .fontWeight(.bold)
            .font(.system(size: 24))

    }
}

struct SkipButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 52)
            .padding(.vertical)
            .border(Color("aceBlue"), width: 2, cornerRadius: 32)
            .foregroundStyle(Color("aceBlue"))
            .fontWeight(.bold)
            .font(.system(size: 24))
    }
}

enum OnboardingSteps: Int, CaseIterable, Identifiable {
    case introVideo = 0
    case secondStep = 1
    
    var id: String {
        switch self {
        case .introVideo: "intro"
        case .secondStep: "second"
        }
    }
    
    @ViewBuilder var page: some View {
        switch self {
        case .introVideo: IntroStep()
        case .secondStep: Text("This is an example step", comment: "Temp text")
        }
    }
}

struct OnboardingSettingsPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Onboarding(endOnboarding: {
            self.presentationMode.wrappedValue.dismiss()
        })
    }
}

struct Onboarding: View {
    @State var currentPage: Int = 0
    var endOnboarding: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(stops: [
                .init(color: Color("gradientBackground").opacity(0.3), location: 0),
                .init(color: Color("gradientBackground").opacity(0.75), location: 0.5),
                .init(color: Color("gradientBackground").opacity(1), location: 1.0)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(OnboardingSteps.allCases) { step in
                        step.page.tag(step.rawValue)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                HStack {
                    if currentPage + 1 < OnboardingSteps.allCases.count {
                        Button(action: {
                            endOnboarding()
                        }, label: {
                            Text("Skip", comment: "The label for the button to exit onboarding")
                        })
                        .buttonStyle(SkipButton())
                        Button(action: {
                            currentPage += 1
                        }, label: {
                            Text("Next", comment: "The label for the to go to the next onboarding step")
                        }).buttonStyle(NextButton())
                    } else {
                        Button(action: {
                            endOnboarding()
                        }, label: {
                            Text("Done", comment: "The label for the button to exit onboarding")
                        }).buttonStyle(NextButton())
                    }
                }.padding(.bottom)
            }.frame(maxWidth: 800)
        }

    }
}

struct IntroStep: View {
    var body: some View {
        VStack {
            VideoPlayerOnboarding()
            Text("Welcome to **Echo**", comment: "Welcome message in onboarding")
                .foregroundStyle(Color("aceBlue"))
                .font(.system(size: 24))
                .padding(.bottom, 4)
            Text("Communication for the visual impaired", comment: "Explain what Echo is")
                .foregroundStyle(Color("aceBlue"))
                .font(.system(size: 18))
        }.padding(.bottom, 64)
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        Onboarding(endOnboarding: {
            print("Done")
        })
    }
}
