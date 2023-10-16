//
//  AddSwitch.swift
//  Echo
//
//  Created by Gavin Henderson on 10/10/2023.
//

import Foundation
import SwiftUI

struct DetectSwitch: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var focused: Bool
    @Binding var selectedKey: KeyEquivalent?
    
    var body: some View {
        Form {
            VStack {
                ProgressView()
                Text("Activate your external switch")
                    .font(.title2)
                Text("""
                 External switches can be a bluetooth or wired device such as a keyboard, controller or switch
                 """)
                .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
        }
        .focusable()
        .focused($focused)
        .onKeyPress { press in
            selectedKey = press.key
            self.presentationMode.wrappedValue.dismiss()
            return .handled
        }
        .onAppear {
            focused = true
        }
    }
}

struct AddSwitch: View {
    @EnvironmentObject var accessOptions: AccessOptions
    @Environment(\.presentationMode) var presentationMode
    
    @State var switchName = ""
    @State var selectedKey: KeyEquivalent?
    @State var tapAction: Action = .next
    @State var doubleAction: Action = .none
    @State var holdAction: Action = .none
    
    @State var id: UUID?
    
    var isButtonEnabled: Bool {
        if switchName == "" { return true }
        if selectedKey == nil { return true }
        
        return false
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(content: {
                    TextField("Switch Name", text: $switchName, prompt: Text("Required"))
                }, header: {
                    Text("Switch Name")
                })
                Section(content: {
                    if let unwrappedKey = selectedKey {
                        HStack {
                            Text("Selected Key")
                            Spacer()
                            Text(keyToDisplay(unwrappedKey))
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    NavigationLink(destination: {
                        DetectSwitch(selectedKey: $selectedKey)
                    }, label: {
                        Label("Detect Switch", systemImage: "button.programmable.square")
                    })

                }, header: {
                    Text("Switch Key")
                }, footer: {
                    // swiftlint:disable:next line_length
                    Text("Let Echo know what switch you want to use by pressing it. If you change your mind you can reset the chosen switch.")
                })
                
                Section(content: {
                    Picker("Single Tap", selection: $tapAction) {
                        ForEach(Action.tapCases) { action in
                            Text(action.display)
                        }
                    }.pickerStyle(.navigationLink)
                    Picker("Hold", selection: $holdAction) {
                        ForEach(Action.holdCases) { action in
                            Text(action.display)
                        }
                    }.pickerStyle(.navigationLink)
                }, header: {
                   Text("Actions")
                }, footer: {
                    Text("These are the actions that will happen when you tap or hold your switch")
                })
                
                if id != nil {
                    Section(content: {
                        Button(action: {
                            if let unwrappedKey = selectedKey, let unwrappedId = id {
                                accessOptions.updateSwitch(
                                    id: unwrappedId,
                                    name: switchName,
                                    key: unwrappedKey,
                                    tapAction: tapAction,
                                    holdAction: holdAction
                                )
                            }
                            
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Save Changes")
                        })
  
                        .disabled(isButtonEnabled)
                        Button(action: {
                            if let unwrappedId = id {
                                accessOptions.deleteSwitch(id: unwrappedId)
                            }
                            
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Label("Delete Switch", systemImage: "trash")
                                .foregroundColor(.red)
                        })
                        
                    }, footer: {
                        Text("A switch name and switch key must be entered before you can save changes switch.")
                    })
                } else {
                    Section(content: {
                        Button(action: {
                            if let unwrappedKey = selectedKey {
                                accessOptions.addSwitch(
                                    name: switchName,
                                    key: unwrappedKey,
                                    tapAction: tapAction,
                                    holdAction: holdAction
                                )
                            }
                            
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Add New Switch")
                        })
                        .frame(maxWidth: .infinity, alignment: .center)
                        .disabled(isButtonEnabled)
                    }, footer: {
                        Text("A switch name and switch key must be entered before you can save the new switch.")
                    })
                }

            }
            
            .toolbar {
                if id == nil {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Cancel")
                        })
                    }
                }
            }
        }
        .navigationTitle("Switch: \(switchName)")

    }
}

private struct PreviewWrapperAdd: View {
    @State var sheetState: Bool = true
    @StateObject var accessOptions = AccessOptions()
    
    var body: some View {
        
        Button(action: {
            sheetState.toggle()
        }, label: {
            Text("Open")
        })
            .sheet(isPresented: $sheetState) {
                AddSwitch()
                    .environmentObject(accessOptions)
            }
        
    }
}

private struct PreviewWrapperEdit: View {
    @State var sheetState: Bool = true
    @StateObject var accessOptions = AccessOptions()
    
    var body: some View {
        
        NavigationStack {
            Text("Main Page")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    navigationDestination(isPresented: .constant(true), destination: {
                        AddSwitch(
                            switchName: "My Switch",
                            selectedKey: .upArrow,
                            tapAction: .next,
                            id: UUID()
                        )
                            .environmentObject(accessOptions)
                            
                    })
                    
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}

struct AddSwitch_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        PreviewWrapperAdd()
        PreviewWrapperEdit()

    }
}
