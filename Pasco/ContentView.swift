// Generic TODOs
/// TODO Add translation strings in
/// TODO Split up files
/// TODO Allow for long taps
/// TODO Make actions clear

import SwiftUI
import Combine
import SQLite

// This is slow an ineffecient
// It brute forces the dictionary every time
// It should do some kind of binary search ideally
// It also only does next letter, no full word
// It also has no consideration for weight of a word. Obscure words are equal to common words
// No error handling
// Probably very poor SQLite practice, i reckon it might drop the connection
class SlowAndBadPrediciton: PredictionEngine {
    var dbConn: Connection?
    var wordsTable: SQLite.Table?
    
    init() {
        do {
            let path = Bundle.main.path(forResource: "dictionary", ofType: "sqlite")!
            let db = try Connection(path, readonly: true)
            let words = Table("words")
            
            self.dbConn = db
            self.wordsTable = words
            
            

        } catch {
            print (error)
        }
    }
    
    func predict(enteredText: String) -> Array<String> {
        guard let db = dbConn else { return [] }
        guard let words = wordsTable else { return [] }
        
        let alphabet = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z".components(separatedBy: ",")
        let alphabetScores: [String: Int] = [:]
        
        let prefix = "he"
        
        do {
            let wordExpression = Expression<String>("word")

            let query = words.filter(wordExpression.like(prefix + "%"))
            
            for word in try db.prepare(query) {
                let nextCharPos = prefix.count + 1
                
            }
            
        } catch {
            print(error)
            return alphabet
        }
        
        return alphabet.sorted {
            var firstScore = alphabetScores[$0, default: 0]
            var secondScore = alphabetScores[$1, default: 0]
            
            return firstScore > secondScore
        }
    }
    
    
}


// This is a 'prediction' engine that randomly shuffles letters
class RandomPrediction: PredictionEngine {
    var alphabet: Array<String>
    var words: Array<String>
    
    init() {
        words = ["This", "is", "word", "I", "suggest","more"]
        alphabet = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z".components(separatedBy: ",")
    }
    
    func predict(enteredText: String) -> Array<String> {
        if(enteredText == "") {
            return "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z".components(separatedBy: ",")
        }
        
        alphabet.shuffle()
        words.shuffle()
        return words + alphabet
    }
}

protocol PredictionEngine {
    func predict(enteredText: String) -> Array<String>
}

class DeleteItem: ItemProtocol, Identifiable {
    var id = UUID()
    var displayText: String
    
    init(_ display: String) {
        self.displayText = display
    }

    func select(enteredText: String) -> String {
        return ""
    }
    
    func isPredicted() -> Bool {
        return false
    }
}

class BackspaceItem: ItemProtocol, Identifiable {
    var id = UUID()
    var displayText: String
    
    init(_ display: String) {
        self.displayText = display
    }

    func select(enteredText: String) -> String {
        if enteredText == "" { return "" }
        
        // `removeLast` annoyingly mutates the string
        // which means we have to do this copy nonsense
        var mutableCopy = enteredText
        mutableCopy.removeLast()
        return mutableCopy
    }
    
    func isPredicted() -> Bool {
        return false
    }
}


class LetterItem: ItemProtocol, Identifiable {
    var id = UUID()
    var letter: String
    var displayText: String
    var predicted: Bool
    
    init(_ letter: String) {
        self.letter = letter
        self.displayText = letter
        self.predicted = false
    }
    
    init(_ letter: String, isPredicted: Bool) {
        self.letter = letter
        self.displayText = letter
        self.predicted = isPredicted
    }
    
    init(_ letter: String, display: String) {
        self.letter = letter
        self.displayText = display
        self.predicted = false
    }
    
    init(_ letter: String, display: String, isPredicted: Bool) {
        self.letter = letter
        self.displayText = display
        self.predicted = isPredicted

    }
    
    func isPredicted() -> Bool {
        return self.predicted
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
    func isPredicted() -> Bool
}

// We need this kinda annoying container due to: https://stackoverflow.com/questions/73773884/any-identifiable-cant-conform-to-identifiable
struct Item: Identifiable{
    var details: any ItemProtocol
    var id: UUID { details.id }
    
    init(letter: String) {
        self.details = LetterItem(letter)
    }
    
    init(letter: String, isPredicted: Bool) {
        self.details = LetterItem(letter, isPredicted: isPredicted)

    }
    
    init(letter: String, display: String) {
        self.details = LetterItem(letter, display: display)
    }
    
    init(actionType: ItemActionType, display: String){
        if actionType == .delete {
            self.details = DeleteItem(display)
        } else if actionType == .backspace {
            self.details = BackspaceItem(display)
        } else {
            self.details = LetterItem("An error occurred")
        }
    }
    
    enum ItemActionType {
        case delete, backspace
    }
}

/// TODO: 'SelectionState' is a bad name
class SelectionState: ObservableObject {
    @Published var items: Array<Item>
    @Published var selectedUUID: UUID
    @Published var enteredText = ""
    
    var predictor: PredictionEngine
    
    init() {
        predictor = SlowAndBadPrediciton()
        items = [
            Item(letter:" ", display: "<Space>"),
            Item(actionType: .delete, display: "<Clear>"),
            Item(actionType: .backspace, display: "<Backspace>")
        ]
        selectedUUID = UUID()
        
        let predictions = predictor.predict(enteredText: enteredText)
        let predictedItems = predictions.map { currentPrediction in
            return Item(letter: currentPrediction, isPredicted: true)
            
        }
        
        items = items + predictedItems
        
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
        
        let predictions = predictor.predict(enteredText: enteredText)
        let predictedItems = predictions.map { currentPrediction in
            return Item(letter: currentPrediction, isPredicted: true)
            
        }
        
        items = items.filter { item in
            return !item.details.isPredicted()
        }
        
        items = items + predictedItems

        
        
        self.reset()
        
        if let unrwappedScroll = scrollControl {
            withAnimation {
                unrwappedScroll.scrollTo(self.selectedUUID, anchor: .center)
            }
        }
    }
    
}

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

struct ContentView: SwiftUI.View {
    @StateObject var selection = SelectionState();
    
    var body: some SwiftUI.View {
        ScrollViewReader { scrollControl in
            VStack{
                HStack {
                    Button(action: { selection.next(scrollControl: scrollControl) }, label: { Text("Next") })
                    Button(action: { selection.select(scrollControl: scrollControl) }, label: { Text("Select") })
                }
                HStack {
                    Text(">")
                    
                    GeometryReader { geoReader in
                        ScrollView() {
                            VStack(alignment: .leading) {
                                ForEach(selection.items) { item in
                                    HStack{
                                        if(item.id == selection.selectedUUID) {
                                            Text(item.details.displayText)
                                                .padding()
                                                .bold()
                                            
                                        } else {
                                            Text(item.details.displayText)
                                                .padding()
                                            
                                        }
                                    }.id(item.id)
                                    
                                }
                            }.padding(.vertical, geoReader.size.height/2)
                            
                        }.onAppear {
                            scrollControl.scrollTo(selection.selectedUUID, anchor: .center)
                        }.scrollDisabled(true)

                    }
                }
                .contentShape(Rectangle())
                .padding()
                .onTapGesture {
                    selection.next(scrollControl: scrollControl)
                }
                .swipe(right: {
                    selection.select(scrollControl: scrollControl)
                })
                
                
                Text(selection.enteredText)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ContentView()
    }
}
