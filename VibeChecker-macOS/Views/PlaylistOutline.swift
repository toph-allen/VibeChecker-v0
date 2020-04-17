//
//  PlaylistOutline.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 4/4/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData


struct PlaylistOutlineBranch: View {
    var playlist: Playlist
    @State private var open = false
    @Binding var selectedPlaylist: Playlist?
    
    @ViewBuilder
    var body: some View {

        PlaylistRow(playlist: playlist)
        List(selection: $selectedPlaylist) {
            PlaylistRow(playlist: playlist)
                .tag(playlist)
                .onTapGesture {
                    self.open.toggle()
            }
            if open == true {
                ForEach(playlist.childList ?? [], id: \.id) { playlist in
                    PlaylistOutlineBranch(playlist: playlist, selectedPlaylist: self.$selectedPlaylist).tag(playlist)
                }
            }
        }
    }
}

// struct PlaylistOutlineBranch<T: RandomAccessCollection>: View where T.Element == Playlist {
// @Binding var selectedPlaylist: Playlist?


struct PlaylistOutline_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == \"2. Vibes\"")
        let playlists = try! moc.fetch(fetchRequest) as [Playlist]
        // let childList = (playlists[0].childList!) as [Playlist]

    
        // return Text("\(childList[0])")

        return PlaylistOutlineBranch(playlist: playlists[0], selectedPlaylist: .constant(playlists[0]))
            // .previewLayout(.fixed(width: 300, height: 400))
    }
}

