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
        VStack(spacing: 2) { // spacing: 2 is what List uses
            if level == -1 {
                EmptyView()
            } else {
                // VStack { // we might not need this to be in a VStack
                if node == selectedItem {
                    OutlineRow(node: node, level: level)
                        .background(Color.accentColor)
                        .foregroundColor(Color.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
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
        ScrollView() {
            VStack(alignment: .leading, spacing: 0) {
            Text(self.outlineTree.name ?? "")
                .font(.system(size: 11, weight: .semibold, design: .default))
                .foregroundColor(Color.secondaryLabel)
                .padding(EdgeInsets(top: 8, leading: 9, bottom: 3, trailing: 0))
            OutlineBranch(node: self.outlineTree.rootNode, selectedItem: self.$selectedItem, level: -1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .padding(.top)
            }
        }
        .introspectScrollView { scrollView in
            print(scrollView.contentView.bounds.origin)
        }
        .background(VisualEffectView(material: .appearanceBased, blendingMode: .behindWindow))
        .offset(x: 0, y: 0)
//        .padding(.)
        // A hack for list row insets not working. This hack also applies to the section header though.
    }
}
    
//    var body: some View {
//        List {
//            // The padding in the section header is there to adjust for the inset hack.
//            Section(header: Text(self.outlineTree.name ?? "").padding(.leading, 8)) {
//                OutlineBranch(node: self.outlineTree.rootNode, selectedItem: self.$selectedItem, level: -1)
//            }
//            .collapsible(false)
//        }
//        .listStyle(SidebarListStyle())
//        .introspectTableView { tableView in
//            let scrollView = tableView.enclosingScrollView!
//            print(scrollView.automaticallyAdjustsContentInsets)
//            scrollView.automaticallyAdjustsContentInsets = false
//            print(scrollView.automaticallyAdjustsContentInsets)
//            print(scrollView.contentInsets)
//            scrollView.contentInsets = NSEdgeInsetsZero
//            print(scrollView.contentInsets)
//            scrollView.backgroundColor = NSColor.red
//            tableView.backgroundColor = NSColor.orange
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .padding(.leading, -8)
//        // A hack for list row insets not working. This hack also applies to the section header though.
//    }
//}


