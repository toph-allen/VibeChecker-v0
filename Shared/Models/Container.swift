//
//  Playlist.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 5/18/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import RealmSwift


// Parent class for VibeChecker containers
class Container: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    let parent = LinkingObjects(fromType: Folder.self, property: "children")
    
    let iTunesPersistentID = RealmOptional<Int64>()
}
