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

// This takes a list of tracks and displays them. There is currently no sorting logic or anything.
struct PlaylistList: View {

    #if DEBUG // FIXME: This is the biggest fucking hack!
    var playlists: [Playlist]
    #else
    var playlists: FetchedResults<Playlist> // seems to have to be this to work with tagging and state
    #endif
    @Binding var selectedPlaylist: Playlist?
    
    var body: some View {
        List(selection: $selectedPlaylist) {
            ForEach(playlists, id: \.id) {playlist in
                PlaylistRow(playlist: playlist).tag(playlist)
            }
        }
    }
}


#if DEBUG
struct PlaylistList_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let allPlaylistsRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        let playlists = try! moc.fetch(allPlaylistsRequest)


        return PlaylistList(playlists: playlists, selectedPlaylist: .constant(playlists[0]))
            .previewLayout(.fixed(width: 300, height: 400))
    }
}
#endif
