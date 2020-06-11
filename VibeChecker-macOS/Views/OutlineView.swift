//
//  OutlineView.swift
//  OutlineView
//
//  Created by Toph Allen on 4/13/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//
import Foundation
import SwiftUI
import Combine


// This view handles displaying the contents of each row for its object. Clicking its arrow image also toggles a node's open state.
struct OutlineRow: View {
    @ObservedObject var node: OutlineNode
    var level: CGFloat
    
    @ViewBuilder
    var body: some View {
        HStack {
            if !node.isLeaf {
                ZStack { // This and the Rectangle() are a hack to make the clickable area of the triangle bigger.
                    Image(node.open == false ? "arrowtriangle.right.fill.13-regular-small" : "arrowtriangle.down.fill.13-regular-small")
                        .renderingMode(.template)
                        .foregroundColor(Color.secondary)
                        .frame(width: 16, height: 16)
                    Rectangle()
                        .opacity(0.001)
                        .frame(width: 18, height: 24)
                        .layoutPriority(-1)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.node.open.toggle()
                    }
                }
            } else {
                Image("arrowtriangle.right.fill.13-regular-small")
                    .opacity(0)
                    .frame(width: 16, height: 16)
            }

            
            Image(!node.isLeaf ? "folder.13-regular-medium" : "music.note.list.13-regular-medium")
                .renderingMode(.template)
                .frame(width: 16, height: 16)
                .padding(.leading, -4)
            
            Text(node.name)
                .lineLimit(1) // If lineLimit is not specified, non-leaf names will wrap
                .truncationMode(.tail)
                .allowsTightening(true)
            
            Spacer()
        }
        .frame(height: 16)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .padding(.leading, level * 20)
        .debug()
    }
}


struct OutlineBranch: View {
    @ObservedObject var node: OutlineNode
    @Binding var selectedItem: OutlineNode?
    var level: CGFloat
    
    @ViewBuilder
    var body: some View {
        VStack(spacing: 2) { // spacing: 2 is what List uses
            if level == -1 {
                EmptyView()
                    .debug() // the root node is at
            } else {
                // VStack { // we might not need this to be in a VStack
                if node == selectedItem {
                    OutlineRow(node: node, level: level)
                        .background(Color.accentColor)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                } else {
                    OutlineRow(node: node, level: level)
                        .debug()
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
                }.debug()
                // .padding(.leading, node.isRoot ? 0 : 24)
                
                // FIXME: Animation is super-jank
                // .transition(.move(edge: .top))
                // .animation(.linear(duration: 0.1))
            }
        }
    }
}


struct OutlineSection: View {
    @EnvironmentObject var outlineTree: OutlineTree  // We need to keep the tree outside of the object itself.
    @Binding var selectedItem: OutlineNode? // Maybe this could be a value for a subtree?
    
    // init(items: [T], selectedItem: Binding<NodeType?>) {
    //     self.outlineTree = OutlineTree(representedObjects: items)
    //     self._selectedItem = selectedItem
    // }
    
    // init(outlineTree: OutlineTree, selected
    
    var body: some View {
        List {
            // The padding in the section header is there to adjust for the inset hack.
            Section(header: Text(self.outlineTree.name ?? "").padding(.leading, 8)) {
                OutlineBranch(node: self.outlineTree.rootNode, selectedItem: self.$selectedItem, level: -1)
            }
            .collapsible(false)
        }
        .listStyle(SidebarListStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.leading, -8)
        // A hack for list row insets not working. This hack also applies to the section header though.
    }
}


