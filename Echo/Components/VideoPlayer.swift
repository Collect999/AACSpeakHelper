//
//  VideoPlayer.swift
//  Echo
//
//  Created by Gavin Henderson on 27/10/2023.
//

import Foundation
import AVKit
import SwiftUI

// https://developer.apple.com/forums/thread/711360
struct CustomPlayerController: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.beginAppearanceTransition(true, animated: false)
        controller.showsPlaybackControls = true
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    }
    
    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: ()) {
        uiViewController.beginAppearanceTransition(false, animated: false)
    }
}

struct VideoPlayerOnboarding: View {
    var player: AVPlayer?
    @State var unmutePressed = false
    
    init() {
        if let unwrappedUrl =  Bundle.main.url(
            forResource: "Promo",
            withExtension: "mp4"
        ) {
            player = AVPlayer(url: unwrappedUrl)
        }
    }
    
    var body: some View {
        if let unwrappedPlayer = player {
            VStack {
                HStack {
                    Spacer()
                    if unmutePressed == false {
                        Button(action: {
                            unwrappedPlayer.isMuted = false
                            unmutePressed = true
                        }, label: {
                            Label(String(localized: "Unmute", comment: "Label on button to unmute video"), systemImage: "speaker")
                        })
                    }
                }
                .padding()
                Spacer()
                GeometryReader { proxy in
                    CustomPlayerController(
                        player: unwrappedPlayer
                    )
                    .frame(width: proxy.size.width, height: proxy.size.width * 9 / 16)
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                    .onAppear {
                        unwrappedPlayer.seek(to: .zero)
                        unwrappedPlayer.play()
                        unwrappedPlayer.isMuted = true
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
}
