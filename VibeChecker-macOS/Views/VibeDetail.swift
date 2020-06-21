//
//  VibeDetail.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 6/16/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import SwiftUI

struct VibeDetail: View {
    var vibe: Vibe
    @State private var selectedTrack: Track?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Text(vibe.name ?? "")
                    .font(.title)
                Text("Vibe • \(vibe.tracks?.count ?? 0) track\(vibe.tracks?.count == 1 ? "" : "s")")
                    .font(.callout)
                    .foregroundColor(Color.secondaryLabel)
            }.padding()
            Divider()
            NavigationView {
                TrackList(tracks: self.vibe.tracks as? Set<Track>, selectedTrack: self.$selectedTrack)
                if selectedTrack != nil {
                    TrackDetail(track: self.selectedTrack)
                } else {
                    Text("No Track Selected")
                        .font(.title)
                        .fontWeight(.light)
                        .foregroundColor(.tertiaryLabel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(VisualEffectView(material: .appearanceBased, blendingMode: .behindWindow))
                    
                }
            }
        }
    }
}


