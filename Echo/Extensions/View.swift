//
//  View.swift
//  Echo
//
//  Created by Gavin Henderson on 03/10/2023.
//

import Foundation
import SwiftUI

extension SwiftUI.View {
    func swipe(
        up: @escaping (() -> Void) = {},
        down: @escaping (() -> Void) = {},
        left: @escaping (() -> Void) = {},
        right: @escaping (() -> Void) = {}
    ) -> some SwiftUI.View {
        return self.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width < 0 { left() }
                if value.translation.width > 0 { right() }
                if value.translation.height < 0 { up() }
                if value.translation.height > 0 { down() }
            }))
    }
}
