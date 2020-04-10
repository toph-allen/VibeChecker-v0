//
//  ContentView.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 3/19/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import SwiftUI
import CoreData


// struct ContentView: View {
//     var body: some View {
//         Text("Hello, World!")
//     }
// }




struct ContentView: View {
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
    @State private var selectedTrack: Track?

    var body: some View {
        NavigationView {
            TrackList(tracks: Array(tracks), selectedTrack: $selectedTrack)
                .listStyle(SidebarListStyle())

            if selectedTrack != nil {
                TrackDetail(track: selectedTrack!)
            }
        }.frame(minWidth: 640, minHeight: 480)
        .onAppear(perform: importITunesTracks) // Cannot appear on a variable definition
        .onAppear(perform: importITunesPlaylists) // Cannot appear on a variable definition
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
