//
//  ContainerSplitView.swift
//  VibeChecker
//
//  Created by Toph Allen on 4/14/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import SwiftUI

struct ContainerSplitView: View {
    var outlineTree: OutlineTree
    @State var selectedItem: OutlineNode? = nil
    
    init(items: [Container]) {
        outlineTree = OutlineTree(representedObjects: items, name: "Playlists")
        for item in outlineTree.rootNode.childrenFoldersFirst! {
            print(item.name)
        }    }
    
    var body: some View {
        NavigationView {
            OutlineSection(selectedItem: $selectedItem).environmentObject(outlineTree)
                .frame(minWidth: 192, idealWidth: 192, maxWidth: 256, maxHeight: .infinity)
                .debug()
            if selectedItem?.item is Playlist {
                PlaylistDetail(playlist: selectedItem!.item! as! Playlist)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                EmptyView ()
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
