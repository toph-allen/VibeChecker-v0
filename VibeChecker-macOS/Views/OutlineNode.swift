//
//  OutlineNode.swift
//  OutlineView
//
//  Created by Toph Allen on 4/13/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import Combine



// Maybe I need to move the equatable and hashable requirements to *here*, because then OutlineNode's equatable and hashable things will be based off of its .item. Like its `.hash()` function would just be `.item.hash()`?


class OutlineNode: ObservableObject, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var selectable: Bool = true
    @Published var item: Container?
    @Published var children: [OutlineNode] = []
    @Published var parent: OutlineNode?
    @Published var open: Bool = false
    @Published var level: CGFloat
    
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
        if item is Folder {
            return false
        } else {
            return true
        }
    }
    
    var visibleDescendants: [OutlineNode] {
        get {
            print("visibleDescendants")
            var descendants: [OutlineNode] = []
            guard (self.isLeaf == false && self.open == true) || self.level == -1 else {
                print("in that conditional")
                print(self.isLeaf)
                print(self.open)
                print(self.level == -1)
                return descendants
            }
            for child in children {
                print("adding a child to visibleDescendants")
                descendants.append(child)
                descendants.append(contentsOf: child.children)
            }
            return descendants
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
        
        // If we were given a parent, store it.
        if parent != nil {
            self.parent = parent
            self.level = parent!.level + 1
        } else {
            self.level = -1
        }
        
        // If represented objects have children, make child nodes, passing self as parent.
        if let folder = item as? Folder {
            if folder.children != nil {
                for case let child as Container in folder.children! {
                    self.children.append(OutlineNode(item: child, parent: self))
                }
            }
            children.sort { c1, c2 in
                if c1.isLeaf == c2.isLeaf {
                    return c1.name < c2.name
                } else {
                    return !c1.isLeaf && c2.isLeaf // This sorts the trues last?
                }
            }

        }
        

    }
    
    init(children: [OutlineNode]) {
        self.name = "ROOT"
        self.children = children
        self.level = -1
    }
}

// This change should make it so that I can initialize this with any random access collection.
class OutlineTree: ObservableObject {
    @Published var representedObjects: [Container]
    @Published var rootNode: OutlineNode

    var name: String?
    var visibleNodes: [OutlineNode] {
        get {
            return rootNode.visibleDescendants
        }
    }
    
    init(representedObjects: [Container], name: String? = nil) {
        print("Initializing an OutlineTree")
        self.representedObjects = representedObjects
        let rootChildren = representedObjects.filter({
            let object = $0
            return object.parent == nil
        }).map({ representedObject in
            OutlineNode(item: representedObject)
        })
        self.rootNode = OutlineNode.init(children: rootChildren)
        self.name = name
        for node in self.visibleNodes {
            print(node.name)
        }
        print(self.rootNode.name)
        print(self.rootNode.visibleDescendants)
    }
}



