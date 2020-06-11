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


struct PlaylistList {
    var playlists: [Container]
    @Binding var selectedPlaylist: Container?
    
    var body: some View {
        List(selection: $selectedPlaylist) {
            ForEach(playlists, id: \.id) { playlist in
                PlaylistRow(playlist: playlist as! Playlist).tag(playlist)
            }
        }
    }
}





