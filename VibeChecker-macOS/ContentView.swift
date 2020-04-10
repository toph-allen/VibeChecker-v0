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


// struct ContentView: View {
//     var body: some View {
//         Text("Hello, World!")
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
    
    @State private var selectedTrack: Track?
    var importService = TracksImportService()
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Track.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Track.artistName, ascending: true),
            NSSortDescriptor(keyPath: \Track.albumTitle, ascending: true),
            NSSortDescriptor(keyPath: \Track.trackNumber, ascending: true)
        ],
        predicate: nil)
    var tracks: FetchedResults<Track>

    var body: some View {
        Group {
            if tracks.isEmpty {
                Button.init("Import", action: {
                    self.importService.importButtonTaps.send()
                })
            } else {
                NavigationView {
                    TrackList(tracks: tracks, selectedTrack: $selectedTrack)
                        .listStyle(SidebarListStyle())
                    
                    if selectedTrack != nil {
                        TrackDetail(track: selectedTrack!)
                    }
                }
            }
        }.frame(minWidth: 640, minHeight: 480)
        .debug()
        // .onAppear(perform: importITunesTracks) // Cannot appear on a variable definition
        // .onAppear(perform: importITunesPlaylists) // Cannot appear on a variable definition
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
