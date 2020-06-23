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
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Text(playlist.name ?? "")
                    .font(.title)
                Text("Playlist • \(playlist.playlistTracks?.count ?? 0) track\(playlist.playlistTracks?.count == 1 ? "" : "s")")
                    .font(.callout)
                    .foregroundColor(Color.secondaryLabel)
            }.padding()
            Divider()
            NavigationView {
                TrackList(tracks: self.playlist.playlistTracks as? Set<PlaylistTrack>, selectedTrack: self.$selectedTrack)
                if selectedTrack != nil {
                    TrackDetail(track: self.selectedTrack)
                } else {
                    Text("No Track Selected")
                        .font(.title)
                        .fontWeight(.light)
                        .foregroundColor(.tertiaryLabel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(VisualEffectView(material: .underWindowBackground, blendingMode: .behindWindow))

                }
            }
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
