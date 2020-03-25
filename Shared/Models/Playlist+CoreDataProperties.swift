//
//  Playlist+CoreDataProperties.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 3/25/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//
//

import Foundation
import CoreData


extension Playlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Playlist> {
        return NSFetchRequest<Playlist>(entityName: "Playlist")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var playlistTracks: NSSet?

}

// MARK: Generated accessors for playlistTracks
extension Playlist {

    @objc(addPlaylistTracksObject:)
    @NSManaged public func addToPlaylistTracks(_ value: PlaylistTracks)

    @objc(removePlaylistTracksObject:)
    @NSManaged public func removeFromPlaylistTracks(_ value: PlaylistTracks)

    @objc(addPlaylistTracks:)
    @NSManaged public func addToPlaylistTracks(_ values: NSSet)

    @objc(removePlaylistTracks:)
    @NSManaged public func removeFromPlaylistTracks(_ values: NSSet)

}
