// Generic TODOs
/// TODO Add translation strings in
/// TODO Make prediction work in more languages
/// TODO Allow for long taps
/// TODO Make spaces visible
/// TODO Add clipboard and share options
/// TODO Add arrow keys
/// TODO Joystick mode?
/// TODO Swipe with inertia
/// TODO figure out double press
/// TODO Needs to work with voice over
/// TODO needs to be switch accessible

/**
 Description of default behaviour:
 After each letter you type out: read back the current word one charcter at a time. Prefix it with 'Current word'
 After each word read out the current sentance. Prefix it with 'current sentance'
 
 * The prefixes should be toggleable in the settings but lets keep them on by default
 */


import SwiftUI
import Combine



/// TODO: 'SelectionState' is a bad name
class SelectionState: ObservableObject {
    @Published var items: Array<Item>
    @Published var selectedUUID: UUID
    @Published var enteredText = ""
    
    var textToSpeech = TextToSpeech()
    
    var predictor: PredictionEngine
    
    var undoItem: Item
    
    
    init() {
        predictor = SlowAndBadPrediciton()
        undoItem = Item(actionType: .backspace, display: "Undo", textToSpeech: textToSpeech)
        items = [
            Item(letter:"·", display: "Space", speakText: "Space"),
            undoItem,
            Item(actionType: .finish, display: "Finish", textToSpeech: textToSpeech)
        ]
        selectedUUID = UUID()
        
        let predictions = predictor.predict(enteredText: enteredText)
        
        items = predictions + items
        
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
    
    func back() {
        move(moveBy: -1, reset: false)
    }
    
    func move(moveBy: Int = 1, reset: Bool = false) {
        let currentIndex = self.getIndexOfSelectedItem()
        var newIndex = (currentIndex + moveBy) % items.count
        
        if reset == true {
            newIndex = 0
        }
        
        let wrappedIndex = newIndex < 0 ? items.count + newIndex : newIndex
        
        let newItem = items[wrappedIndex]
        
        
        selectedUUID = newItem.id
        
        textToSpeech.speak(newItem.details.speakText) {}
    }
    
    /***
     Move onto the next item in the list
     */
    func next(reset: Bool = false) {
        move(moveBy: 1, reset: reset)
    }
    
    func backspace() {
        select(overrideItem: undoItem)
    }
    
    /***
     Select the current item in the list
     
     'Select' will perform different actions depending on the item that is currently focused
     */
    func select(overrideItem: Item? = nil) {
        let currentItem = overrideItem ?? items[getIndexOfSelectedItem()]
        
        currentItem.details.select(enteredText: enteredText) { newText in
            self.enteredText = newText
            
            let predictions = self.predictor.predict(enteredText: self.enteredText)
            
            self.items = self.items.filter { item in
                return !item.details.isPredicted()
            }
            
            self.items = predictions + self.items
            
            
            self.next(reset: true)
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

/***
    Renders a ScrollView and keeps the given UUID always in the center of the scroll area
 */
struct ScrollLock<Content: View>: SwiftUI.View {
    @Binding var selectedUUID: UUID
    @ViewBuilder var content: Content
    
    var body: some View {
        ScrollViewReader { scrollControl in
            content
                .onChange(of: selectedUUID) { newUUID in
                    withAnimation {
                        scrollControl.scrollTo(newUUID, anchor: .center)
                    }
                }.onAppear {
                    scrollControl.scrollTo(selectedUUID, anchor: .center)
                }.scrollDisabled(true)
        }
    }
}

struct ContentView: SwiftUI.View {
    @StateObject var selection = SelectionState();
    
    // Thanks to https://sarunw.com/posts/move-view-around-with-drag-gesture-in-swiftui/
    @State private var location: CGPoint = CGPoint(x: 300, y: 200)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
    var body: some SwiftUI.View {
        ScrollLock(selectedUUID: $selection.selectedUUID) {
            
            ZStack {
                ZStack {
                    VStack(spacing: .zero) {
                        HStack(spacing: .zero)  {
                            
                            Spacer()
                            Button {
                                print("Up")
                                selection.back()
                            } label: {
                                Image("SingleArrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .offset(CGSize(width: 0, height: 3))
                            }
                            Spacer()
                            
                        }
                        HStack(spacing: .zero)  {
                            
                            
                            Button {
                                print("Left")
                                selection.backspace()
                            } label: {
                                Image("SingleArrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .rotationEffect(.degrees(-90))
                            }
                            Spacer()
                            Button {
                                print("Right")
                                selection.select()
                            } label: {
                                Image("SingleArrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .rotationEffect(.degrees(90))
                            }
                            
                        }
                        
                        HStack(spacing: .zero)  {
                            
                            Spacer()
                            Button {
                                print("Down")
                                selection.next()

                            } label: {
                                Image("SingleArrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .rotationEffect(.degrees(180))
                                    .offset(CGSize(width: 0, height: -3))
                            }
                            Spacer()
                            
                        }
                    }
                    
                    
                    
                }
                .frame(width: 172.0, height: 172.0)
                .background(.white)
                .position(location)
                .zIndex(1)
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged { value in
                            var newLocation = startLocation ?? location
                            newLocation.x += value.translation.width
                            newLocation.y += value.translation.height
                            self.location = newLocation
                        }
                        .updating($startLocation) { (value, startLocation, transaction) in
                            startLocation = startLocation ?? location
                        }
                )
                
                
                
                VStack{
    
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
                                
                            }
                            
                        }
                    }
                    .contentShape(Rectangle())
                    .padding()
                    .onTapGesture {
                        selection.next()
                    }
                    .swipe(right: {
                        selection.select()
                    })
                    
                    
                    Text(selection.enteredText)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ContentView()
    }
}
