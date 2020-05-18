//
//  Track.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 5/18/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import RealmSwift

class Track: Object {
    @objc dynamic var id = UUID().uuidString
    
    // Core metadata
    @objc dynamic var title: String = ""
    @objc dynamic var album: String? = nil
    @objc dynamic var artist: String? = nil
    let trackNumber = RealmOptional<Int>()
    
    // Files and corresponding objects
    @objc dynamic var location: URL? = nil
    let iTunesPersistentID = RealmOptional<Int64>()
    
    // Other metadata
    @objc dynamic var addedDate: Date? = nil
    var beatsPerMinute = RealmOptional<Int>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}
