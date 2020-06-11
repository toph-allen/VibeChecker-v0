//
//  ContentView.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 3/19/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

//
// struct ContentView: View {
//     var body: some View {
//         Text("Hello, World!")
//             .frame(minWidth: 640, minHeight: 480)
//     }
// }


extension View {
    func debug() -> some View {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}



struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Container.entity(), sortDescriptors: [], predicate: nil) var containers: FetchedResults<Container>

    var body: some View {
        ContainerSplitView(items: Array(containers)) // FIXME: I'm just doing what James suggested and converting to array lol
//            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .frame(minWidth: 640, minHeight: 480)
    }

        // .onAppear(perform: importITunesTracks) // Cannot appear on a variable definition
        // .onAppear(perform: importITunesPlaylists) // Cannot appear on a variable definition
}


// struct ContentView_Previews: PreviewProvider {
//     static var previews: some View {
//         ContentView()
//     }
// }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
