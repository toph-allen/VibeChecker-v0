//
//  ContainerSplitView.swift
//  VibeChecker
//
//  Created by Toph Allen on 4/14/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import SwiftUI


import SwiftUI

struct ContainerSplitView: View {
    var vibes: OutlineTree
    var playlists: OutlineTree
    @State var selectedItem: OutlineNode? = nil
    
    init(vibes: Set<Vibe>, playlists: Set<Playlist>) {
        self.vibes = OutlineTree(leaves: vibes, name: "Vibes")
        self.playlists = OutlineTree(leaves: playlists, name: "Playlists")
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                List {
                    OutlineSection(selectedItem: $selectedItem).environmentObject(vibes)
                    OutlineSection(selectedItem: $selectedItem).environmentObject(playlists)
                }
            }
            .listStyle(SidebarListStyle())
            .padding(EdgeInsets(top: 0, leading: -18, bottom: 0, trailing: -14))
            .frame(minWidth: 192, idealWidth: 192, maxWidth: 256, maxHeight: .infinity)
            Group {
                if selectedItem?.item is Playlist {
                    PlaylistDetail(playlist: selectedItem!.item as! Playlist)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if selectedItem?.item is Vibe {
                    VibeDetail(vibe: selectedItem!.item as! Vibe)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("No Playlist Selected")
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

// struct SplitView_Previews: PreviewProvider {
//     static var previews: some View {
//         let item = exampleData()
//
//         return SplitView(rootItem: item)
//     }
// }

