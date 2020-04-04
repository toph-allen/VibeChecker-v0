//
//  ContentView.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 3/19/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import SwiftUI

let moc = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
let allTracksRequest: NSFetchRequest<Track> = Track.fetchRequest()
var tracks = try! moc.fetch(allTracksRequest)

struct ContentView: View {
    @State private var selectedTrack: Track?

    var body: some View {
        NavigationView {
            TrackList(tracks: tracks, selectedTrack: $selectedTrack)
                .listStyle(SidebarListStyle())
            
            if selectedTrack != nil {
                TrackDetail(track: selectedTrack!)
            }
        }.onAppear(perform: importITunesTracks) // Cannot appear on a variable definition

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
