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


struct PlaylistList<T: RandomAccessCollection>: View where T.Element == Playlist {
    var playlists: T
    @Binding var selectedPlaylist: Playlist?
    
    var body: some View {
        List(selection: $selectedPlaylist) {
            ForEach(playlists, id: \.id) { playlist in
                PlaylistRow(playlist: playlist).tag(playlist)
            }
        }
    }
}



struct PlaylistList_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let allPlaylistsRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        let playlists = try! moc.fetch(allPlaylistsRequest)
        for playlist in playlists {
            print(playlist.name as Any)
        }


        return PlaylistList(playlists: playlists, selectedPlaylist: .constant(playlists[1]))
            .previewLayout(.fixed(width: 300, height: 400))
    }
}

