//
//  ScanningOptionsPage.swift
//  Echo
//
//  Created by Gavin Henderson on 05/10/2023.
//

import Foundation
import SwiftUI

struct ScanningOptionsPage: View {
    @EnvironmentObject var scanningOptions: ScanningOptions
    
    var body: some View {
        VStack {
            // swiftlint:disable:next line_length
            Text("Scanning is when Echo automatically cycles through the items in the list one ofter the other reading them aloud one a time.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            GroupBox {
                Toggle("Scanning", isOn: $scanningOptions.scanning)
                Divider().padding(.vertical, 6)
                HStack {
                    Text("Scanning speed")
                    Spacer()
                    Text(String(format: "%.1f", scanningOptions.scanWaitTime) + "s")
                }
                Slider(
                    value: $scanningOptions.scanWaitTime,
                    in: 0.3...10,
                    step: 0.1
                )
                Text("The length of time that Echo will wait before moving onto the next item")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider().padding(.vertical, 6)
                Toggle("Scan on app launch", isOn: .constant(true))
                Divider().padding(.vertical, 6)
                Toggle("Scan after selection", isOn: .constant(true))
                Divider().padding(.vertical, 6)
                Stepper(
                    value: $scanningOptions.scanLoops,
                    in: 1...10,
                    step: 1
                ) {
                    Text("Scan **\(scanningOptions.scanLoops)** times before stopping")
                        .fixedSize()
                }

            }
            Spacer()
        }.padding(.horizontal)
    }
}

private struct PreviewWrapper: View {
    @StateObject var scanningOptions = ScanningOptions()

    var body: some View {
        NavigationStack {
            Text("Main Page")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    navigationDestination(isPresented: .constant(true), destination: {
                        ScanningOptionsPage()
                            .environmentObject(scanningOptions)
                            
                    })
                    
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct ScanningOptionsPage_Previews: PreviewProvider {
    
    static var previews: some SwiftUI.View {
        PreviewWrapper().preferredColorScheme(.light)
            
    }
}
