//
//  ContentView.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 3/19/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

//
// struct ContentView: View {
//     var body: some View {
//         Text("Hello, World!")
//             .frame(minWidth: 640, minHeight: 480)
//     }
// }


extension View {
    func debug() -> some View {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}

// This is a service object
final class TracksImportService {
    let importButtonTaps = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        importButtonTaps
            .sink { _ in
                importITunesTracks()
            }
            .store(in: &subscriptions)
    }
}

struct ContentView: View {
    
    @State private var selectedPlaylist: Playlist?
    var importService = TracksImportService()
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Playlist.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Playlist.name, ascending: true)], predicate: nil)
    var playlists: FetchedResults<Playlist>

    var body: some View {
        Group {
            if playlists.isEmpty {
                Button.init("Import", action: {
                    self.importService.importButtonTaps.send()
                })
            } else {
                NavigationView {
                    PlaylistList(playlists: playlists, selectedPlaylist: $selectedPlaylist)
                        .listStyle(SidebarListStyle())
                    
                    if selectedPlaylist != nil {
                        // TrackDetail(track: selectedPlaylist!)
                        Text("Selected playlist: \(selectedPlaylist!.name ?? "[No Name]")")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }.frame(minWidth: 640, minHeight: 480)
        .debug()
        // .onAppear(perform: importITunesTracks) // Cannot appear on a variable definition
        // .onAppear(perform: importITunesPlaylists) // Cannot appear on a variable definition
    }
}


// struct ContentView_Previews: PreviewProvider {
//     static var previews: some View {
//         ContentView()
//     }
// }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
