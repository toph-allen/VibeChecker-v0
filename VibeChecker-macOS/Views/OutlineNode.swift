//
//  OutlineNode.swift
//  OutlineView
//
//  Created by Toph Allen on 4/13/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation

// Added "open" param in hacky way cos this is gonna be thrown away eventually
class OutlineNode: ObservableObject, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var selectable: Bool = true
    @Published var item: Container?
    @Published var children: [OutlineNode]?
    @Published var parent: OutlineNode?
    @Published var open: Bool = false
    
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
    
    static func == (lhs: OutlineNode, rhs: OutlineNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(item: Container, parent: OutlineNode? = nil, open: Bool = false) {
        self.item = item
        self.name = item.name ?? ""
        
        if let folder = item as? Folder {
            self.children = []
            if folder.children != nil {
                for case let child as Container in folder.children! {
                    self.children!.append(OutlineNode(item: child, parent: self, open: open))
                }
            }
        }
        
        if parent != nil {
            self.parent = parent
        }
        
        self.open = open
    }
    
    init(children: [OutlineNode]) {
        self.name = ""
        self.children = children
    }
}


class OutlineTree: ObservableObject {
    @Published var representedObjects: Set<Container>
    @Published var rootNode: OutlineNode
    var name: String?
    
    init(leaves: Set<Container>, name: String? = nil, openByDefault: Bool = false) {
        var ancestors: Set<Container> = []
        for leaf in leaves {
            ancestors = ancestors.union(leaf.ancestors)
        }
        let allObjects = leaves.union(ancestors)
        var rootChildren = allObjects.filter({
            let object = $0
            return object.parent == nil
        }).map({ representedObject in
            OutlineNode(item: representedObject, open: openByDefault)
        })
        // This is really hacky
        while rootChildren.count == 1 {
            if rootChildren[0].isLeaf == false && rootChildren[0].children != nil {
                rootChildren = rootChildren[0].children!
            }
        }
        self.representedObjects = allObjects
        self.rootNode = OutlineNode(children: rootChildren)
        self.name = name
    }
    
    init(representedObjects: [Container], name: String? = nil, openByDefault: Bool = false) {
        self.representedObjects = Set(representedObjects)
        let rootChildren = representedObjects.filter({
            let object = $0
            return object.parent == nil
        }).map({ representedObject in
            OutlineNode(item: representedObject, open: openByDefault)
        })
        self.rootNode = OutlineNode(children: rootChildren)
        self.name = name
    }
}



