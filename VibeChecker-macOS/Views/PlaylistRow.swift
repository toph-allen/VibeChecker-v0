//
//  PlaylistRow.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 4/6/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

struct PlaylistRow: View {
    var playlist: Playlist
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if playlist.kindEnum == .folder {
                    Image("folder")
                    // .resizable()
                } else if playlist.kindEnum == .regular {
                    Image("music.note.list")
                    // .resizable()
                }
                Text(playlist.name ?? "")
                    // .fontWeight(.bold)
                    // .allowsTightening(true)
                    .frame(minWidth: 20)
            }
        }
        .padding(.vertical, 4)
    }
}


struct PlaylistRow_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let allPlaylistsRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        let playlist = (try! moc.fetch(allPlaylistsRequest).first)!
        
        
        return PlaylistRow(playlist: playlist).environment(\.managedObjectContext, moc)
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
