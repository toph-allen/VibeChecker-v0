//
//  TrackRow.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 4/4/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

struct PlaylistDetail: View {
    var playlist: Playlist
    @State private var selectedTrack: Track?

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(playlist.name ?? "").font(.title)
                Text("Parent Playlist: \(playlist.parent?.name ?? "")")
            }.padding()
        TrackList(tracks: playlist.tracks, selectedTrack: $selectedTrack)
        }
    }
}


struct PlaylistDetail_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let allPlaylistsRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        let playlist = (try! moc.fetch(allPlaylistsRequest).first)!


        return PlaylistDetail(playlist: playlist).environment(\.managedObjectContext, moc)
        .previewLayout(.fixed(width: 500, height: 500))
    }
}
