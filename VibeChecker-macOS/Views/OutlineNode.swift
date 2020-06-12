//
//  OutlineNode.swift
//  OutlineView
//
//  Created by Toph Allen on 4/13/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation




// Maybe I need to move the equatable and hashable requirements to *here*, because then OutlineNode's equatable and hashable things will be based off of its .item. Like its `.hash()` function would just be `.item.hash()`?


class OutlineNode: ObservableObject, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var item: Container?
    var children: [OutlineNode]?
    var parent: OutlineNode?
    var selectable: Bool = true
    @Published var open: Bool = false
    
//    // Make it conform to identifiable etc. by using its item's properties
//    var id: UUID? {
//        get {
//            return self.item?.id
//        }
//    }
    
//    var name: String {
//        get {
//            return self.item?.name ?? ""
//        }
//    }
    
    var isLeaf: Bool {
        if item is Folder || children != nil {
            return false
        } else {
            return true
        }
    }
    
    var childrenFoldersFirst: [OutlineNode]? {
        get {
            guard self.children != nil else {
                return nil
            }
            return self.children!.sorted { c1, c2 in
                if c1.isLeaf == c2.isLeaf {
                    return c1.name < c2.name
                } else {
                    return !c1.isLeaf && c2.isLeaf // This sorts the trues last?
                }
            }
        }
    }
    
    // Should these also be defined using the item
    static func == (lhs: OutlineNode, rhs: OutlineNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(item: Container, parent: OutlineNode? = nil) {
        self.item = item
        self.name = item.name ?? ""
        
        // If represented objects have children, make child nodes, passing self as parent.
        if let folder = item as? Folder {
            self.children = []
            if folder.children != nil {
                for case let child as Container in folder.children! {
                    self.children!.append(OutlineNode(item: child, parent: self))
                }
            }
        }
        
        // If we were given a parent, store it.
        if parent != nil {
            self.parent = parent
        }
    }
    
    init(children: [OutlineNode]) {
        self.name = ""
        self.children = children
    }
}

// This change should make it so that I can initialize this with any random access collection.
class OutlineTree: ObservableObject {
//    var representedObjects: [Container]
    var rootNode: OutlineNode
    var name: String?
    
    init(representedObjects: [Container], name: String? = nil) {
//        self.representedObjects = representedObjects
        let rootChildren = representedObjects.filter({
            let object = $0
            return object.parent == nil
        }).map({ representedObject in
            OutlineNode(item: representedObject)
        })
        self.rootNode = OutlineNode(children: rootChildren)
        self.name = name
    }
}



