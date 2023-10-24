import SwiftUI
import Combine

struct ContentView: SwiftUI.View {
    @EnvironmentObject var voiceEngine: VoiceEngine
    @EnvironmentObject var items: ItemsList
    @EnvironmentObject var accessOptions: AccessOptions
    @EnvironmentObject var scanOptions: ScanningOptions
    @EnvironmentObject var spelling: SpellingOptions
    @EnvironmentObject var analytics: Analytics
    
    @State var lastLangId: String?
    
    var body: some SwiftUI.View {
        NavigationStack {
            ScrollLock(selectedUUID: $items.selectedUUID) {
                
                ZStack {
                    if accessOptions.showOnScreenArrows {
                        OnScreenArrows(
                            up: { items.back(userInteraction: true) },
                            down: { items.next(userInteraction: true) },
                            left: { items.backspace(userInteraction: true) },
                            right: { items.select(userInteraction: true) }
                        )
                    }
                    if accessOptions.enableSwitchControl {
                        KeyPressController()
                    }
                    VStack {
                        
                        HStack {
                            Image(systemName: "chevron.right")
                            
                            GeometryReader { geoReader in
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        ForEach(items.items) { item in
                                            HStack {
                                                if item.id == items.selectedUUID {
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
                        .swipe(
                            up: {
                                if accessOptions.allowSwipeGestures {
                                    items.back(userInteraction: true)
                                    analytics.userInteraction(type: "Swipe", extraInfo: "UP")
                                }
                            },
                            down: {
                                if accessOptions.allowSwipeGestures {
                                    items.next(userInteraction: true)
                                    analytics.userInteraction(type: "Swipe", extraInfo: "DOWN")
                                }
                            },
                            left: {
                                if accessOptions.allowSwipeGestures {
                                    items.backspace(userInteraction: true)
                                    analytics.userInteraction(type: "Swipe", extraInfo: "LEFT")
                                }
                            },
                            right: {
                                if accessOptions.allowSwipeGestures {
                                    items.select(userInteraction: true)
                                    analytics.userInteraction(type: "Swipe", extraInfo: "RIGHT")
                                }
                            }
                        )
                        VStack {
                            Text(items.enteredText == "" ? " " : items.enteredText)
                                .padding(10)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color("lightGray"))
                        .shadow(radius: 1)

                    }
                }
            }
                .navigationTitle(
                    String(
                        localized: "Echo: Auditory Scanning",
                        comment: "The main navigation title for the whole app"
                    )
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink(destination: {
                            SettingsPage()
                        }, label: {
                            Image(systemName: "slider.horizontal.3").foregroundColor(.blue)
                        })
                        
                    }
                }
                .toolbarBackground(.visible, for: .navigationBar, .tabBar)
                .onDisappear {
                    items.cancelScanning()
                }
                .onAppear {
                    if let unwrappedLangId = lastLangId {
                        if unwrappedLangId != spelling.language.id {
                            items.clear(userInteraction: false)
                            lastLangId = spelling.language.id
                        }
                    } else {
                        lastLangId = spelling.language.id
                    }
                    
                    items.allowScanning()
                    if scanOptions.scanOnAppLaunch {
                        items.startScanningOnAppLaunch()
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ContentView().preferredColorScheme(.light)
        ContentView().preferredColorScheme(.dark)

    }
}
