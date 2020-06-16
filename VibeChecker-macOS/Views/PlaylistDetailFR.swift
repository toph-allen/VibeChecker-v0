//
//  PlaylistDetailFR.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 6/16/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import SwiftUI

struct PlaylistDetailFR: View {
    @Environment(\.managedObjectContext) var moc
    var playlist: Playlist
    @FetchRequest var tracks: FetchedResults<PlaylistTrack>
    @State private var selectedTrack: Track?
    
    init(playlist: Playlist) {
        self.playlist = playlist
        let predicate = NSPredicate(format: "playlist = %@", playlist)
        self._tracks = FetchRequest(
            entity: PlaylistTrack.entity(),
            sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)],
            predicate: predicate
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(playlist.name ?? "").font(.title)
                Text("Parent Playlist: \(playlist.parent?.name ?? "")")
                Text("ID: \(playlist.id?.uuidString ?? "")")
                Text("iTunes ID: \(playlist.iTunesPersistentID ?? "")")
            }.padding()
            NavigationView {
                TrackList(tracks: Array(tracks), selectedTrack: self.$selectedTrack)
                TrackDetail(track: self.selectedTrack)
            }
        }
    }
}

