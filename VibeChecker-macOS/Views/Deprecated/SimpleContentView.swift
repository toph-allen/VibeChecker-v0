//
//  ContainerSplitView.swift
//  VibeChecker
//
//  Created by Toph Allen on 4/14/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import SwiftUI


import SwiftUI

struct SimpleContentView: View {
    @FetchRequest(entity: Container.entity(), sortDescriptors: [], predicate: nil) var containers: FetchedResults<Container>
    @State var selectedItem: Container? = nil
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            ContainerList(containers: Array(containers), selectedItem: $selectedItem)
            if selectedItem is Playlist {
                PlaylistDetail(playlist: selectedItem as! Playlist)
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
