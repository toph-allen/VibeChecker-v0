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
    var track: Track
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(track.title ?? "").font(.title)
                    
                    Text("\(track.artistName ?? "") — \(track.albumTitle ?? "")")
                        .font(.subheadline)
                        .padding(.bottom)
                    
                    HStack {
                        Text("File:")
                        Text((track.location?.path ?? "No File Found") as String).truncationMode(.head)
                    }
                }
                Spacer()
                
            }
            .padding()
        }
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
