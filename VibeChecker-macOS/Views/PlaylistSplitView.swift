//
//  PlaylistSplitView.swift
//  VibeChecker
//
//  Created by Toph Allen on 4/14/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import SwiftUI

struct PlaylistSplitView<T: RandomAccessCollection>: View where T.Element == Playlist {
    var outlineTree: OutlineTree<Playlist, T>
    @State var selectedItem: OutlineNode<Playlist>? = nil
    
    init(items: T) {
        outlineTree = OutlineTree(representedObjects: items, name: "Playlists")
    }
    
    var body: some View {
        NavigationView {
            OutlineSection<Playlist, T>(selectedItem: $selectedItem).environmentObject(outlineTree)
                .frame(minWidth: 192, idealWidth: 192, maxWidth: 256, maxHeight: .infinity)
            if selectedItem != nil {
                PlaylistDetail(playlist: selectedItem!.representedObject!)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
