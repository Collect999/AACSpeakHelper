//
//  AccessOptions.swift
//  Echo
//
//  Created by Gavin Henderson on 04/10/2023.
//

import Foundation
import SwiftUI

class AccessOptions: ObservableObject {
     @AppStorage("showOnScreenArrows") var showOnScreenArrows = true
     @AppStorage("allowSwipeGestures") var allowSwipeGestures = true
    
    func save() {
        
    }
    
    func load() {
        
    }
}
