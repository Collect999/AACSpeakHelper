import SwiftUI
import Combine

struct ContentView: SwiftUI.View {
    @EnvironmentObject var voiceEngine: VoiceEngine
    @EnvironmentObject var items: ItemsList
    @EnvironmentObject var accessOptions: AccessOptions
    @EnvironmentObject var scanOptions: ScanningOptions
    
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
                            Text(">")
                            
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
                                }
                            },
                            down: {
                                if accessOptions.allowSwipeGestures {
                                    items.next(userInteraction: true)
                                }
                            },
                            left: {
                                if accessOptions.allowSwipeGestures {
                                    items.backspace(userInteraction: true)
                                }
                            },
                            right: {
                                if accessOptions.allowSwipeGestures {
                                    items.select(userInteraction: true)
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
                .navigationTitle("Echo: Auditory Scanning")
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
                    items.allowScanning()
                    if scanOptions.scanOnAppLaunch {
                        items.startScanning()
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
