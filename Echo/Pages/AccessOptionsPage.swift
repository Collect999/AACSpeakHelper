//
//  AccessOptionsPage.swift
//  Echo
//
//  Created by Gavin Henderson on 04/10/2023.
//

import Foundation
import SwiftUI

struct AccessOptionsPage: View {
    @EnvironmentObject var accessOptions: AccessOptions
    
    var body: some View {
        VStack {
            GroupBox {
                HStack {
                    Toggle("Show on-screen arrows", isOn: $accessOptions.showOnScreenArrows)
                }
            }
            VStack {
                
                GroupBox {
                    
                    HStack {
                        Toggle("Swiping gestures", isOn: $accessOptions.allowSwipeGestures)
                    }
                }
                VStack {
                    Text("Swipe up, down, left or right to control Echo")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("""
                   • **Right:** Select the current item
                   • **Down:** Go to the next item in the list
                   • **Left:** Remove the last entered character
                   • **Up:** Go to the previous item in the list
                """)
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.horizontal)

            }.padding(.vertical)
            Spacer()
        }
        .padding(.horizontal)
        .onDisappear {
            accessOptions.save()
        }
    }
}

private struct PreviewWrapper: View {
    @StateObject var accessOptions: AccessOptions = AccessOptions()

    var body: some View {
        NavigationStack {
            Text("Main Page")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    navigationDestination(isPresented: .constant(true), destination: {
                        AccessOptionsPage()
                            .environmentObject(accessOptions)
                    })
                    
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct AccessOptionsPage_Previews: PreviewProvider {
    
    static var previews: some SwiftUI.View {
        PreviewWrapper().preferredColorScheme(.light)
            
    }
}
