//
//  AddSwitch.swift
//  Echo
//
//  Created by Gavin Henderson on 10/10/2023.
//

import Foundation
import SwiftUI

struct InlineTextField: View {
    @Binding var text: String
    var label: String
    var placeholder: String = "Required"
    
    var body: some View {
        Form {
            TextField(text: $text, prompt: Text("Required")) {
                Text("Username")
            }
            SecureField(text: $text, prompt: Text("Required")) {
                Text("Password")
            }
        }
//        HStack {
//            LabeledContent(label) {
//                TextField(
//                    text: $text,
//                    prompt: Text(placeholder)af
//                ) {
//                    Text(label)
//                }
//            }
//            Button(action: {
//                
//            }, label: {
//                Image(systemName: "chevron.right")
//            })
//        }
    }
}

struct AddSwitch: View {
    @Binding var sheetState: Bool
    @State var switchName = ""
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button(action: {
                    sheetState.toggle()
                }, label: {
                    Text("Cancel")
                })
            }
            GroupBox {
                InlineTextField(
                    text: $switchName,
                    label: "Switch Name"
                )
                
            }
            Button(action: {
                sheetState.toggle()
            }, label: {
                Text("Add Switch")
            }).buttonStyle(.borderedProminent)
            Spacer()
        }.padding()
    }
}

private struct PreviewWrapper: View {
    @State var sheetState: Bool = true

    var body: some View {
        
        Button(action: {
            sheetState.toggle()
        }, label: {
            Text("Open")
        })
            .sheet(isPresented: $sheetState) {
                AddSwitch(sheetState: $sheetState)
            }
        
    }
}

struct AddSwitch_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        PreviewWrapper().preferredColorScheme(.light)
        PreviewWrapper().preferredColorScheme(.dark)

    }
}
