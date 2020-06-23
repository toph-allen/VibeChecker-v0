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


struct OutlineRow: View {
    @ObservedObject var node: OutlineNode
    var level: CGFloat
    
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
        .padding(.leading, level * 17)
    }
}


struct OutlineBranch: View {
    @ObservedObject var node: OutlineNode
    @Binding var selectedItem: OutlineNode?
    var level: CGFloat
    
    @ViewBuilder
    var body: some View {
        VStack(spacing: 2) {
            if level == -1 {
                EmptyView()
            } else {
                if node == selectedItem {
                    OutlineRow(node: node, level: level)
                        .background(Color.accentColor)
                        .foregroundColor(Color.white)
                } else {
                    OutlineRow(node: node, level: level)
                        .onTapGesture {
                            if self.node.selectable == true {
                                self.selectedItem = self.node
                            }
                    }
                }
                // }
            }
            if node.isLeaf == false && (node.open == true || level == -1) {
                ForEach(node.childrenFoldersFirst!, id: \.id) { node in
                    OutlineBranch(node: node, selectedItem: self.$selectedItem, level: self.level + 1)
                }
            }
        }
    }
}


struct OutlineSection: View {
    @EnvironmentObject var outlineTree: OutlineTree  // We need to keep the tree outside of the object itself.
    @Binding var selectedItem: OutlineNode? // Maybe this could be a value for a subtree?
    
    var body: some View {
        Section(header: Text(self.outlineTree.name ?? "").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 14))) {
            OutlineBranch(node: self.outlineTree.rootNode, selectedItem: self.$selectedItem, level: -1)
        }
        .collapsible(false)
    }
}


