//
//  Playlist.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 4/6/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import CoreData
import iTunesLibrary

// enum PlaylistKind: Int32 {
//     case Folder, Regular, Smart
// }


enum PlaylistKind: Int32 {
    case folder, regular, smart, other
}

extension Playlist {
    var kindEnum: PlaylistKind {
        get { return PlaylistKind(rawValue: self.kind) ?? .other }
        set { self.kind = newValue.rawValue }
    }
}


extension Playlist: Identifiable {
    class func createFromiTunesMediaItem(from source: ITLibPlaylist, in moc: NSManagedObjectContext) -> Playlist {
        let playlist = NSEntityDescription.insertNewObject(forEntityName: "Playlist", into: moc) as! Playlist
        print("Creating playlist from  \(source.name)")

        switch source.kind {
        case .folder:
            playlist.kindEnum = .folder
        case .regular:
            playlist.kindEnum = .regular
        case .smart:
            playlist.kindEnum = .smart
        default:
            playlist.kindEnum = .other
        }
        playlist.iTunesPersistentID = source.persistentID.int64Value
        playlist.name = source.name

        return playlist
    }
}
