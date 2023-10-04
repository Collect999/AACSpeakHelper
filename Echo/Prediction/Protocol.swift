//
//  Protocol.swift
//  Echo
//
//  Created by Gavin Henderson on 03/10/2023.
//

import Foundation

protocol PredictionEngine {
    func predict(enteredText: String) -> [Item]
}
