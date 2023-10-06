//
//  ScanningOptions.swift
//  Echo
//
//  Created by Gavin Henderson on 05/10/2023.
//

import Foundation
import SwiftUI

class ScanningOptions: ObservableObject {
    @AppStorage("scanning") var scanning = true
    @AppStorage("scanWaitTime") var scanWaitTime: Double = 2
    @AppStorage("scanLoops") var scanLoops: Int = 3
    @AppStorage("scanOnLaunch") var scanOnAppLaunch = true
    @AppStorage("scanAfterSelection") var scanAfterSelection = true
}
