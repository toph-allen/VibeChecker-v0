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

// Maybe make the image an enum or use a switch statement

struct PlaylistRow: View {
    var playlist: Playlist
    

    var body: some View {
        HStack(alignment: .center) {
            Image("\(playlist.kind.imageName()).13-regular-medium")
                .renderingMode(.template)
                // // These seem to function as a block. Because I'm using icons of the correct size, I don't need to use them.
                // .resizable()
                // .aspectRatio(contentMode: .fit)
                // .fixedSize(horizontal: true, vertical: true)
                // .frame(width: 16, height: 16)
            Text(playlist.name)
                .truncationMode(.tail)
                // .fontWeight(.bold)
                .allowsTightening(true)
                .frame(alignment: .leading)
            Spacer()
        }
        .padding(.vertical, 2)
        // .frame(minWidth: 20)
    }
}


struct PlaylistRow_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let allPlaylistsRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        let playlist = (try! moc.fetch(allPlaylistsRequest)[0])
        
        
        return PlaylistRow(playlist: playlist).environment(\.managedObjectContext, moc)
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
