//
//  Track+CoreDataProperties.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 3/25/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//
//

import Foundation
import CoreData


extension Track {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var trackNumber: Int64
    @NSManaged public var album: Album?
    @NSManaged public var artist: Artist?
    @NSManaged public var playlists: NSSet?
    @NSManaged public var vibes: NSSet?

}

// MARK: Generated accessors for playlists
extension Track {

    @objc(addPlaylistsObject:)
    @NSManaged public func addToPlaylists(_ value: PlaylistTracks)

    @objc(removePlaylistsObject:)
    @NSManaged public func removeFromPlaylists(_ value: PlaylistTracks)

    @objc(addPlaylists:)
    @NSManaged public func addToPlaylists(_ values: NSSet)

    @objc(removePlaylists:)
    @NSManaged public func removeFromPlaylists(_ values: NSSet)

}

// MARK: Generated accessors for vibes
extension Track {

    @objc(addVibesObject:)
    @NSManaged public func addToVibes(_ value: Vibe)

    @objc(removeVibesObject:)
    @NSManaged public func removeFromVibes(_ value: Vibe)

    @objc(addVibes:)
    @NSManaged public func addToVibes(_ values: NSSet)

    @objc(removeVibes:)
    @NSManaged public func removeFromVibes(_ values: NSSet)

}
