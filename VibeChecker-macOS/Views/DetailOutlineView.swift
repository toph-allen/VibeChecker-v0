//
//  DetailOutlineView.swift
//  DetailOutlineView
//
//  Created by Toph Allen on 4/13/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import SwiftUI
import Introspect


struct DetailOutlineRow: View {
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


struct DetailOutlineBranch: View {
    @EnvironmentObject var track: Track
    @ObservedObject var node: OutlineNode
    @Binding var selectedItems: Set<Vibe>
    var level: CGFloat
    
    @ViewBuilder
    var body: some View {
        VStack(spacing: 2) {
            if level == -1 {
                EmptyView()
            } else {
                if node.item is Vibe {
                    if selectedItems.contains(self.node.item as! Vibe) {
                        DetailOutlineRow(node: node, level: level)
                            .background(Color.accentColor)
                            .foregroundColor(Color.white)
                            .onTapGesture {
                                track.removeFromVibes(node.item as! Vibe)
                            }
                    } else {
                        DetailOutlineRow(node: node, level: level)
                            .onTapGesture {
                                track.addToVibes(node.item as! Vibe)
                            }
                    }
                } else {
                    DetailOutlineRow(node: node, level: level)
                }
            }
            if node.isLeaf == false && (node.open == true || level == -1) {
                ForEach(node.childrenFoldersFirst!, id: \.id) { node in
                    DetailOutlineBranch(node: node, selectedItems: self.$selectedItems, level: self.level + 1)
                }
            }
        }
    }
}


struct DetailOutlineSection: View {
    var items: OutlineTree  // We need to keep the tree outside of the object itself.
    @Binding var track: Track
    @State var vibes: Set<Vibe>
    
    init(items: OutlineTree, track: Binding<Track>) {
        self.items = items
        self._track = track

        self._vibes = State(initialValue: track.wrappedValue.vibes as? Set<Vibe> ?? [])
        
    }
    
    
    var body: some View {
        Section(header: Text(self.items.name ?? "").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 14))) {
            DetailOutlineBranch(node: self.items.rootNode, selectedItems: $vibes, level: -1).environmentObject(track)
        }
        .collapsible(false)
    }
}


