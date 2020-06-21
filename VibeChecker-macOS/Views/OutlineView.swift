//
//  OutlineView.swift
//  OutlineView
//
//  Created by Toph Allen on 4/13/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//
import Foundation
import SwiftUI
import Introspect

func imageName(for container: Container) -> String {
    let prefix: String
    switch container {
    case is Folder:
        prefix = "folder"
    case is Playlist:
        prefix = "music.note.list"
    case is Vibe:
        prefix = "tag"
    default:
        prefix = ""
    }
    return prefix + ".13-regular-medium"
}

// This view handles displaying the contents of each row for its object. Clicking its arrow image also toggles a node's open state.
struct OutlineRow: View {
    @ObservedObject var node: OutlineNode
    
    @ViewBuilder
    var body: some View {
        HStack(spacing: 0) {
            if !node.isLeaf {
                ZStack { // This and the Rectangle() are a hack to make the clickable area of the triangle bigger.
                    Image(node.open == false ? "arrowtriangle.right.fill.13-regular-small" : "arrowtriangle.down.fill.13-regular-small")
                        .renderingMode(.template)
                        .foregroundColor(Color.secondary)
                        .frame(width: 20, height: 20)
                    Rectangle()
                        .opacity(0.001)
                        .frame(width: 20, height: 24)
                        .layoutPriority(-1)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.node.open.toggle()
                    }
                }
            } else {
                Image("arrowtriangle.right.fill.13-regular-small")
                    .opacity(0)
                    .frame(width: 20, height: 20)
            }

            
            Image(imageName(for: node.item!))
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .padding(.leading, -3)
            
            Text(node.name)
                .lineLimit(1) // If lineLimit is not specified, non-leaf names will wrap
                .truncationMode(.tail)
                .allowsTightening(true)
                .padding(.leading, 3)
//
            Spacer()
        }
        .frame(height: 16)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .padding(.leading, node.level * 17)
    }
}


struct OutlineSection: View {
    @EnvironmentObject var outlineTree: OutlineTree  // We need to keep the tree outside of the object itself.
    @Binding var selectedItem: OutlineNode? // Maybe this could be a value for a subtree?

    
    var body: some View {
        List(selection: $selectedItem) {
            // The padding in the section header is there to adjust for the inset hack.
//            Section(header: Text(self.outlineTree.name ?? ""))
            ForEach(outlineTree.visibleNodes, id: \.id) { node in
                OutlineRow(node: node)
            }
        }
        .listStyle(SidebarListStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.leading, -8)
    }
}
