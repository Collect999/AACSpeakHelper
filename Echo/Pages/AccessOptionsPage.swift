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
            Spacer()
        }
        .padding(.horizontal)
        
        .onDisappear {
            accessOptions.save()
        }
    }
}

private struct PreviewWrapper: View {
    var body: some View {
        NavigationStack {
            Text("Main Page")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    navigationDestination(isPresented: .constant(true), destination: {
                        AccessOptionsPage()
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
