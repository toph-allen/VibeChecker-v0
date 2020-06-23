//
//  ContentView.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 3/19/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import SwiftUI
import CoreData
import Combine


extension View {
    func debug() -> some View {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}


struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Vibe.entity(), sortDescriptors: [], predicate: nil) var vibes: FetchedResults<Vibe>
    @FetchRequest(entity: Playlist.entity(), sortDescriptors: [], predicate: nil) var playlists: FetchedResults<Playlist>

    var body: some View {
        ContainerSplitView(vibes: Set(vibes), playlists: Set(playlists))
            .frame(minWidth: 640, minHeight: 480)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
