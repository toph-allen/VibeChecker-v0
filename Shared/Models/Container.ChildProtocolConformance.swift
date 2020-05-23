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
class Container: Object, Identifiable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var iTunesPersistentID: String? = nil
    
    @objc dynamic var parent: Folder? = nil

    override class func primaryKey() -> String? {  
        return "id"
    }
}



class Folder: Container, OutlineRepresentable {
    var children: [OutlineRepresentable]? {
        let linkingFolders = LinkingObjects(fromType: Folder.self, property: "parent")
        let linkingPlaylists = LinkingObjects(fromType: Playlist.self, property: "parent")
        
    }
    
    var hasContent: Bool = false
}


// Playlists contain Tracks
class Playlist: Object {
    let tracks = List<Track>()
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

