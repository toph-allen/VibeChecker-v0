//
//  Playlist+CoreDataProperties.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 4/22/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//
//

import Foundation
import CoreData


// MARK: Class definition
@objc(Playlist)
final public class Playlist: NSManagedObject {
    
}

// MARK: Properties
extension Playlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Playlist> {
        return NSFetchRequest<Playlist>(entityName: "Playlist")
    }

    @NSManaged public var id: UUID
    @NSManaged public var iTunesPersistentID: String? // PlaylistIDs are actually UInt64s, but does this work?
    @NSManaged public var kindValue: Int32
    @NSManaged public var name: String
    @NSManaged public var childPlaylists: Set<Playlist>?
    @NSManaged public var parentPlaylist: Playlist?
    @NSManaged public var tracksRelationships: Set<PlaylistTrack>?

}

// MARK: Generated accessors for children
extension Playlist {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: Playlist)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: Playlist)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: Set<Playlist>)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: Set<Playlist>)

}

// MARK: Generated accessors for tracksRelationships
extension Playlist {

    @objc(addTracksRelationshipsObject:)
    @NSManaged public func addToTracksRelationships(_ value: PlaylistTrack)

    @objc(removeTracksRelationshipsObject:)
    @NSManaged public func removeFromTracksRelationships(_ value: PlaylistTrack)

    @objc(addTracksRelationships:)
    @NSManaged public func addToTracksRelationships(_ values: Set<PlaylistTrack>)

    @objc(removeTracksRelationships:)
    @NSManaged public func removeFromTracksRelationships(_ values: Set<PlaylistTrack>)

}
