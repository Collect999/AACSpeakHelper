//
//  AccessOptions.swift
//  Echo
//
//  Created by Gavin Henderson on 04/10/2023.
//

import Foundation
import SwiftUI

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
    case next, back, none
    var id: Self { self }
    
    var display: String {
        switch self {
        case .none: return "None"
        case .next: return "Go to the next item"
        case .back: return "Go to the previous item"
        }
    }
    
}

class AccessOptions: ObservableObject {
    @AppStorage("showOnScreenArrows") var showOnScreenArrows = true
    @AppStorage("allowSwipeGestures") var allowSwipeGestures = true
    @AppStorage("enableSwitchControl") var enableSwitchControl = true

    @Published var listOfSwitches: [Switch] = []
    
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
            
            UserDefaults.standard.set(switchesData, forKey: "switchesList")
        } catch {
            print("Failed to persist your settings")
        }
    }
    
    func load() {
        if let switchesData = UserDefaults.standard.data(forKey: "switchesList") {
            do {
                let decoder = JSONDecoder()
                listOfSwitches = try decoder.decode([Switch].self, from: switchesData)
            } catch {
                print("Failed to load your settings")
            }
        }
    }
}
