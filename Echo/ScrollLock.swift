//
//  ScrollLock.swift
//  Echo
//
//  Created by Gavin Henderson on 26/09/2023.
//

import Foundation
import SwiftUI

/***
    Renders a ScrollView and keeps the given UUID always in the center of the scroll area
 */
struct ScrollLock<Content: View>: SwiftUI.View {
    @Binding var selectedUUID: UUID
    @ViewBuilder var content: Content

    var body: some View {
        ScrollViewReader { scrollControl in
            content
                .onChange(of: selectedUUID) { newUUID in
                    withAnimation {
                        scrollControl.scrollTo(newUUID, anchor: .center)
                    }
                }.onAppear {
                    scrollControl.scrollTo(selectedUUID, anchor: .center)
                }.scrollDisabled(true)
        }
    }
}
