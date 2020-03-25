//
//  PlaylistTracks+CoreDataProperties.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 3/25/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//
//

import Foundation
import CoreData


extension PlaylistTracks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaylistTracks> {
        return NSFetchRequest<PlaylistTracks>(entityName: "PlaylistTracks")
    }

    @NSManaged public var order: Int64
    @NSManaged public var playlist: Playlist?
    @NSManaged public var track: Track?

}
