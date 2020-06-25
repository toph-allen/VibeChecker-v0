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

struct TrackDetail: View {
    @State var track: Track
    @FetchRequest(entity: Vibe.entity(), sortDescriptors: [], predicate: nil) var vibes: FetchedResults<Vibe>
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(track.title ?? "No Track Selected").font(.title)
                    
                    Text("\(track.artistName ?? "Unknown Artist") — \(track.albumTitle ?? "Unknown Album")")
                        .font(.subheadline)
                        .padding(.bottom)
                    
                    HStack {
                        Text("File:")
                        Text((track.location?.path ?? "") as String).truncationMode(.head)
                    }
                    DetailOutlineSection(items: OutlineTree(leaves: Set(vibes), name: "Vibes", openByDefault: true), track: $track)

                }
                Spacer()
                
            }
            .padding()
        }
        .frame(minWidth: 320, idealWidth: 640, maxWidth: .infinity, minHeight: 240, idealHeight: 320, maxHeight: .infinity)
        // .navigationBarTitle(Text(track.title ?? ""), displayMode: .inline)
    }
}


struct TrackDetail_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let allTracksRequest: NSFetchRequest<Track> = Track.fetchRequest()
        let track = (try! moc.fetch(allTracksRequest).first)!


        return TrackDetail(track: track).environment(\.managedObjectContext, moc)
        .previewLayout(.fixed(width: 500, height: 500))
    }
}
