//
//  MainWindowTitlebar.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 4/11/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import SwiftUI

struct ToolbarButtonView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Track.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Track.artistName, ascending: true),
            NSSortDescriptor(keyPath: \Track.albumTitle, ascending: true),
            NSSortDescriptor(keyPath: \Track.trackNumber, ascending: true)
        ],
        predicate: nil)
    var tracks: FetchedResults<Track>
    
    @FetchRequest(entity: Playlist.entity(), sortDescriptors: [])
    var playlists: FetchedResults<Playlist>
    
    @ViewBuilder
    var body: some View {
        ZStack {
            Color.clear
            HStack {
                if playlists.isEmpty {
                    Button(action: {
                        importEverything()
                    }) {
                        Text("Import Everything").offset(x: 0, y: 1)
                    }
                } else {
                    Button(action: {
                        deleteEverything()
                    }) {
                        Text("Delete Everything").offset(x: 0, y: 1)
                    }
                }
            }.font(.caption)
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
    }
}


struct MainWindowTitlebar_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World!")
    }
}


// This is a service object

// final class TracksImportService {
//     let importButtonTaps = PassthroughSubject<Void, Never>()
//     private var subscriptions = Set<AnyCancellable>()
//
//     init() {
//         importButtonTaps
//             .sink { _ in
//                 importITunesTracks()
//         }
//         .store(in: &subscriptions)
//     }
// }

// You use it in a button like this:
// Button.init("Import", action: {
//    self.importService.importButtonTaps.send()
// })
