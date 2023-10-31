//
//  AccessOptions.swift
//  Echo
//
//  Created by Gavin Henderson on 04/10/2023.
//

import Foundation
import SwiftUI
import SharedEcho

struct Switch: Identifiable, Decodable, Encodable {
    var id: UUID
    var name: String
    var key: KeyEquivalent
    var tapAction: Action
    var holdAction: Action
    
    init(
        id: UUID,
        name: String,
        key: KeyEquivalent,
        tapAction: Action,
        holdAction: Action
    ) {
        self.id = id
        self.name = name
        self.key = key
        self.tapAction = tapAction
        self.holdAction = holdAction
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case tapAction
        case key
        case holdAction
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.tapAction = try container.decode(Action.self, forKey: .tapAction)
        self.holdAction = try container.decode(Action.self, forKey: .holdAction)

        let key = try container.decode(String.self, forKey: .key)
        self.key = KeyEquivalent(Character(key))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let encodableKey = String(key.character)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(tapAction, forKey: .tapAction)
        try container.encode(holdAction, forKey: .holdAction)
        try container.encode(encodableKey, forKey: .key)
    }
}

enum Action: String, CaseIterable, Identifiable, Codable {
    case next, back, none, fast, select, delete, clear, startScanning
    var id: Self { self }
    
    static public var tapCases: [Action] = [.next, .back, .none, .select, .delete, .clear, .startScanning]
    static public var holdCases: [Action] = [.next, .back, .none, .fast, .select, .delete, .clear, .startScanning]

    var display: String {
        switch self {
        case .none: return String(
            localized: "None",
            comment: "Label for action that happens on a keypress"
        )
        case .next: return String(
            localized: "Go to the next item",
            comment: "Label for action that happens on a keypress"
        )
        case .back: return String(
            localized: "Go to the previous item",
            comment: "Label for action that happens on a keypress"
        )
        case .fast: return String(
            localized: "Quickly scan through the items",
            comment: "Label for action that happens on a keypress"
        )
        case .select: return String(
            localized: "Select the currently selected item",
            comment: "Label for action that happens on a keypress"
        )
        case .delete: return String(
            localized: "Delete the last inputted letter",
            comment: "Label for action that happens on a keypress"
        )
        case .clear: return String(
            localized: "Clear all the inputted text",
            comment: "Label for action that happens on a keypress"
        )
        case .startScanning: return String(
            localized: "Start scanning from the current item, scanning must be enabled",
            comment: "Label for action that happens on a keypress"
        )
        }
    }
    
}

class AccessOptions: ObservableObject, Analytic {
    @AppStorage(StorageKeys.showOnScreenArrows) var showOnScreenArrows = true
    @AppStorage(StorageKeys.allowSwipeGestures) var allowSwipeGestures = true
    @AppStorage(StorageKeys.enableSwitchControl) var enableSwitchControl = true

    @Published var listOfSwitches: [Switch] = [
        Switch(
            id: UUID(),
            name: String(
                localized: "Enter Switch",
                comment: ""
            ),
            key: .return,
            tapAction: .next,
            holdAction: .none
        ),
        Switch(
            id: UUID(),
            name: String(
                localized: "Space Switch",
                comment: ""
            ),
            key: .space,
            tapAction: .select,
            holdAction: .none
        )
    ]
    
    func getAnalyticData() -> [String: Any] {
        return [
            "showOnScreenArrows": showOnScreenArrows,
            "allowSwipeGestures": allowSwipeGestures,
            "enableSwitchControl": enableSwitchControl,
            "switchCount": listOfSwitches.count
        ]
    }
    
    func addSwitch(name: String, key: KeyEquivalent, tapAction: Action, holdAction: Action) {
        listOfSwitches.append(
            Switch(
                id: UUID(),
                name: name,
                key: key,
                tapAction: tapAction,
                holdAction: holdAction
            )
        )
        
        save()
    }
    
    func updateSwitch(id: UUID, name: String, key: KeyEquivalent, tapAction: Action, holdAction: Action) {
        
        listOfSwitches = listOfSwitches.map { current in
            if current.id == id {
                return Switch(
                    id: id,
                    name: name,
                    key: key,
                    tapAction: tapAction,
                    holdAction: holdAction
                )
            } else {
                return current
            }
        }
        
        save()
    }
    
    func deleteSwitch(id: UUID) {
        listOfSwitches = listOfSwitches.filter { $0.id != id }
        save()
    }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            let switchesData = try encoder.encode(self.listOfSwitches)
            
            UserDefaults.standard.set(switchesData, forKey: StorageKeys.switchesList)
        } catch {
            print("Failed to persist your settings")
        }
    }
    
    func load() {
        if let switchesData = UserDefaults.standard.data(forKey: StorageKeys.switchesList) {
            do {
                let decoder = JSONDecoder()
                listOfSwitches = try decoder.decode([Switch].self, from: switchesData)
            } catch {
                print("Failed to load your settings")
            }
        }
    }
}
