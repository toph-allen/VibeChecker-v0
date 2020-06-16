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


struct ContainerList: View {
    var containers: [Container]
    @Binding var selectedItem: Container?
    
    var body: some View {
        List(selection: $selectedItem) {
            ForEach(containers, id: \.id) { container in
                ContainerRow(container: container).tag(container)
            }
        }
    }
}

