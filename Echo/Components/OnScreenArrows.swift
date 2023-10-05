//
//  OnScreenArrows.swift
//  Echo
//
//  Created by Gavin Henderson on 03/10/2023.
//

import Foundation
import SwiftUI

struct OnScreenArrows: View {
    // Thanks to https://sarunw.com/posts/move-view-around-with-drag-gesture-in-swiftui/
    @AppStorage("arrowLocationX") var locationX: Double = 300
    @AppStorage("arrowLocationY") var locationY: Double = 200
    @GestureState private var fingerLocation: CGPoint?
    @GestureState private var startLocation: CGPoint?
    
    var up: (() -> Void) = {}
    var down: (() -> Void) = {}
    var left: (() -> Void) = {}
    var right: (() -> Void) = {}
    
    var body: some View {
        HStack {
            ZStack {
                VStack(spacing: .zero) {
                    HStack(spacing: .zero) {
                        
                        Spacer()
                        Button {
                            up()
                        } label: {
                            Image("SingleArrow")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .offset(CGSize(width: 0, height: 3))
                                .accessibilityLabel("Arrow pointing up")
                        }
                        Spacer()
                        
                    }
                    HStack(spacing: .zero) {
                        
                        Button {
                            left()
                        } label: {
                            Image("SingleArrow")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotationEffect(.degrees(-90))
                                .accessibilityLabel("Arrow pointing left")
                        }
                        Spacer()
                        Button {
                            right()
                        } label: {
                            Image("SingleArrow")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotationEffect(.degrees(90))
                                .accessibilityLabel("Arrow pointing right")
                        }
                        
                    }
                    
                    HStack(spacing: .zero) {
                        
                        Spacer()
                        Button {
                            down()
                        } label: {
                            Image("SingleArrow")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotationEffect(.degrees(180))
                                .offset(CGSize(width: 0, height: -3))
                                .accessibilityLabel("Arrow pointing down")
                        }
                        Spacer()
                        
                    }
                }
                
            }
            .frame(width: 172.0, height: 172.0)
            .background(Color("transparent"))
            .position(CGPoint(
                x: locationX.clamped(172.0 / 2, UIScreen.main.bounds.width - (172.0 / 2)),
                y: locationY.clamped(172.0 / 2, UIScreen.main.bounds.height - (172.0))
            ))
            .zIndex(1)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        var newLocation = startLocation ?? CGPoint(x: locationX, y: locationY)
                        newLocation.x += value.translation.width
                        newLocation.y += value.translation.height
                        
                        locationX = newLocation.x
                        locationY = newLocation.y
                    }
                    .updating($startLocation) { (_, startLocation, _) in
                        startLocation = startLocation ?? CGPoint(x: locationX, y: locationY)
                    }
            )
        }
        .zIndex(1)
    }

}
