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

struct TrackRow: View {
    var track: Track
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(track.title ?? "")
                .fontWeight(.bold)
                .frame(minWidth: 20)
            Text(track.artistName ?? "")
                .font(.caption)
                .opacity(0.625)
        }
        .padding(.vertical, 4)
    }
}


struct TrackRow_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let allTracksRequest: NSFetchRequest<Track> = Track.fetchRequest()
        let track = (try! moc.fetch(allTracksRequest).first)!


        return TrackRow(track: track).environment(\.managedObjectContext, moc)
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
