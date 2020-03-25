//
//  Vibe+CoreDataProperties.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 3/25/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//
//

import Foundation
import CoreData


extension Vibe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vibe> {
        return NSFetchRequest<Vibe>(entityName: "Vibe")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var tracks: NSSet?

}

// MARK: Generated accessors for tracks
extension Vibe {

    @objc(addTracksObject:)
    @NSManaged public func addToTracks(_ value: Track)

    @objc(removeTracksObject:)
    @NSManaged public func removeFromTracks(_ value: Track)

    @objc(addTracks:)
    @NSManaged public func addToTracks(_ values: NSSet)

    @objc(removeTracks:)
    @NSManaged public func removeFromTracks(_ values: NSSet)

}
