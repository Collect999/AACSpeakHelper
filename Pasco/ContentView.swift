//
//  ContentView.swift
//  Pasco
//
//  Created by Gavin Henderson on 14/07/2023.
//

import SwiftUI
import Combine

class SelectionState: ObservableObject {
    @Published var items = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
    ]
    @Published var index = 0
    @Published var enteredText = "text"
    
    func next(scrollControl: ScrollViewProxy?) {
        let newIndex = index + 1
        let newIndexWrapped = newIndex % items.count
        self.index = newIndexWrapped
        
        if let unrwappedScroll = scrollControl {
            withAnimation {
                unrwappedScroll.scrollTo(newIndexWrapped, anchor: .center)
            }
        }
    }
    
    func select() {
        let currentIndex = self.index % items.count
        self.enteredText = self.enteredText + items[currentIndex]
    }
    
}

struct ContentView: View {
    
    @StateObject var selection = SelectionState();
    
    var body: some View {
        ScrollViewReader { scrollControl in
            
            
            VStack{
                HStack {
                    Button(action: { selection.next(scrollControl: scrollControl) }, label: { Text("Next") })
                    Button(action: { selection.select() }, label: { Text("Select") })
                }
                GeometryReader { geoReader in
                    ScrollView {
                        
                        VStack{}.padding(.top, geoReader.size.height/2)
                        ForEach(Array(selection.items.enumerated()), id: \.element) { index, letter in
                            HStack {
                                if(index == selection.index) {
                                    Text("--> " + letter)
                                        .bold()
                                        .padding()
                                } else {
                                    Text(letter)
                                        .padding()
                                }
                            }.id(index)
                            
                        }
                        VStack{}.padding(.bottom, geoReader.size.height/2)

                    }
                }
                
                
                Text(selection.enteredText)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
