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


struct TrackList: View {
    var tracks: [Track]
    @Binding var selectedTrack: Track?
    
    init(tracks: [Track], selectedTrack: Binding<Track?>) {
        self.tracks = tracks
        self._selectedTrack = selectedTrack
    }
    
    init(tracks: [PlaylistTrack], selectedTrack: Binding<Track?>) {
        self.tracks = tracks.map({
            $0.track!
        })
        self._selectedTrack = selectedTrack
    }
    
    init(tracks: Set<PlaylistTrack>?, selectedTrack: Binding<Track?>) {
        if tracks == nil {
            self.tracks = []
        } else {
            self.tracks = tracks?
                .sorted(by: { $0.order < $1.order })
                .map({ $0.track }) as! [Track]
        }
        self._selectedTrack = selectedTrack
    }
    
    var body: some View {
        List(selection: $selectedTrack) {
            ForEach(tracks, id: \.id)  { track in
                TrackRow(track: track).tag(track)
            }
        }
        .frame(minWidth: 256, idealWidth: 320, maxWidth: 320)
    }
}



struct TrackList_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let allTracksRequest: NSFetchRequest<Track> = Track.fetchRequest()
        let tracks = try! moc.fetch(allTracksRequest)


        return TrackList(tracks: tracks, selectedTrack: .constant(tracks[0]))
            .previewLayout(.fixed(width: 300, height: 400))
    }
}

