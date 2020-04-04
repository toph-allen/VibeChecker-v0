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
struct TrackList: View {
    var tracks: [Track]
    @Binding var selectedTrack: Track?
    
    var body: some View {
        List(tracks, selection: $selectedTrack) {
            track in
            TrackRow(track: track).tag(track)
        }
    }
}


struct TrackList_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let allTracksRequest: NSFetchRequest<Track> = Track.fetchRequest()
        let tracks = try! moc.fetch(allTracksRequest)




        return TrackList(tracks: tracks,
                         selectedTrack: .constant(tracks[0])).environment(\.managedObjectContext, moc)
    }
}
