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
class Container: Object, Identifiable, OutlineRepresentable {
// WHYYYY can this not conform to the fucking protocol?
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var iTunesPersistentID: String? = nil
    
    @objc dynamic var parent: Container? = nil
    var children: [Container]? {
        return Array(LinkingObjects(fromType: Container.self, property: "parent"))
    }
    
    @objc dynamic var playlist: Playlist? = nil
    
    var hasContent: Bool {
        if playlist != nil {
            return true
        } else {
            return false
        }
    }

    override class func primaryKey() -> String? {
        return "id"
    }
}





// Playlists contain Tracks
class Playlist: Object {
    let tracks = List<Track>()
}


class Folder: Container, OutlineRepresentable {
    
    var children: [Container]? {
        return Array(LinkingObjects(fromType: Container.self, property: "parent"))
    }
    
    var hasContent: Bool {
        return false
    }
}








// For use if I go with a different solution
enum PlaylistKind: String {
    case folder, regular, smart, other
    
    func imageName() -> String {
        switch self {
        case .folder:
            return "folder"
        default:
            return "music.note.list"
        }
    }
}

