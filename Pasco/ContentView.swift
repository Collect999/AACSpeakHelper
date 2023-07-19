// Generic TODOs
/// TODO Add translation strings in
/// TODO Split up files

import SwiftUI
import Combine

var EnglishAlphabet: Array<Item> = [
    Item(letter:" ", display: "Space"),
    Item(actionType: .delete, display: "Delete"),
    Item(letter:"a"),
    Item(letter:"b"),
    Item(letter:"c"),
    Item(letter:"d"),
    Item(letter:"e"),
    Item(letter:"f"),
    Item(letter:"g"),
    Item(letter:"h"),
    Item(letter:"i"),
    Item(letter:"j"),
    Item(letter:"k"),
    Item(letter:"l"),
    Item(letter:"m"),
    Item(letter:"n"),
    Item(letter:"o"),
    Item(letter:"p"),
    Item(letter:"q"),
    Item(letter:"r"),
    Item(letter:"s"),
    Item(letter:"t"),
    Item(letter:"u"),
    Item(letter:"v"),
    Item(letter:"x"),
    Item(letter:"y"),
    Item(letter:"z")
]

class DeleteItem: ItemProtocol, Identifiable {
    var id = UUID()
    var displayText: String
    
    init(_ display: String) {
        self.displayText = display
    }

    func select(enteredText: String) -> String {
        return ""
    }
}

class LetterItem: ItemProtocol, Identifiable {
    var id = UUID()
    var letter: String
    var displayText: String
    
    init(_ letter: String) {
        self.letter = letter
        self.displayText = letter
    }
    
    init(_ letter: String, display: String) {
        self.letter = letter
        self.displayText = display
    }
    
    func select(enteredText: String) -> String {
        return enteredText + letter
    }
}

/// This is protocol of an item.
///
/// The reason this is a protocol is because we will define different types of item for example
/// we will want a 'LetterItem' and maybe a 'SentenceItem' and a 'ActionItem'
///
/// TODO: 'Item' is a bad name for a protocol
protocol ItemProtocol: Identifiable {
    var id: UUID { get }
    var displayText: String { get }
    func select(enteredText: String) -> String
}

// We need this kinda annoying container due to: https://stackoverflow.com/questions/73773884/any-identifiable-cant-conform-to-identifiable
struct Item: Identifiable{
    var details: any ItemProtocol
    var id: UUID { details.id }
    
    init(letter: String) {
        self.details = LetterItem(letter)
    }
    
    init(letter: String, display: String) {
        self.details = LetterItem(letter, display: display)
    }
    
    init(actionType: ItemActionType, display: String){
        if actionType == .delete {
            self.details = DeleteItem(display)
        } else {
            self.details = LetterItem("An error occurred")
        }
    }
    
    enum ItemActionType {
        case delete
    }
}

/// TODO: 'SelectionState' is a bad name
class SelectionState: ObservableObject {
    @Published var items: Array<Item>
    @Published var selectedUUID: UUID
    @Published var enteredText = ""
    
    init() {
        items = EnglishAlphabet
        selectedUUID = UUID()
        
        if let firstItem = items.first {
            selectedUUID = firstItem.id
        }
    }
    
    func reset() {
        if let firstItem = items.first {
            selectedUUID = firstItem.id
        }
    }
        
    private func getIndexOfSelectedItem() -> Int {
        let currentIndex = items.firstIndex(where: { $0.id == selectedUUID })
                
        return currentIndex ?? 0
    }
    
    /***
        Move onto the next item in the list
     
        Optionally takes scrollControl so that it can force the next item into the center of the viewport
        This relies on you setting the id of items in ScrollView using the index of the item
     */
    func next(scrollControl: ScrollViewProxy?) {
        let currentIndex = self.getIndexOfSelectedItem()
        let newIndex = (currentIndex + 1) % items.count
        
        let newItem = items[newIndex]
        
        selectedUUID = newItem.id
        
        if let unrwappedScroll = scrollControl {
            withAnimation {
                unrwappedScroll.scrollTo(self.selectedUUID, anchor: .center)
            }
        }
    }
    
    /***
        Select the current item in the list
     
        'Select' will perform different actions depending on the item that is currently focused
     */
    func select(scrollControl: ScrollViewProxy?) {
        let currentItem = items[getIndexOfSelectedItem()]
        
        let newText = currentItem.details.select(enteredText: enteredText)
        enteredText = newText
        
        self.reset()
        
        if let unrwappedScroll = scrollControl {
            withAnimation {
                unrwappedScroll.scrollTo(self.selectedUUID, anchor: .center)
            }
        }
    }
    
}


struct ContentView: View {
    @StateObject var selection = SelectionState();
    
    var body: some View {
        ScrollViewReader { scrollControl in
            VStack{
                HStack {
                    Button(action: { selection.next(scrollControl: scrollControl) }, label: { Text("Next") })
                    Button(action: { selection.select(scrollControl: scrollControl) }, label: { Text("Select") })
                }
                GeometryReader { geoReader in
                    ScrollView {
                        
                        VStack{}.padding(.top, geoReader.size.height/2)
                        ForEach(selection.items) { item in
                            HStack {
                                if(item.id == selection.selectedUUID) {
                                    Text(item.details.displayText + "<--")
                                        .bold()
                                        .padding()
                                } else {
                                    Text(item.details.displayText)
                                        .padding()
                                }
                            }.id(item.id)
                            
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
