//
////
////  Playlist.swift
////  VibeChecker-macOS
////
////  Created by Toph Allen on 5/18/20.
////  Copyright © 2020 Toph Allen. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//
//
//// Parent class for VibeChecker containers
//class ContainerBase: Object, Identifiable {
//    @objc dynamic var id = UUID().uuidString
//    @objc dynamic var name = ""
//    @objc dynamic var iTunesPersistentID: String? = nil
//    
//    @objc dynamic var parent: Folder? = nil
//    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
//}
//
//// Folders contain Containers
//class Folder: ContainerBase {
//    let children = LinkingObjects(fromType: ContainerBase.self, property: "parent")
//}
//
//// Playlists contain Tracks
//class Playlist: ContainerBase {
//    let tracks = List<Track>()
//}
//
//class ContainerClasses: Object {
//    dynamic var folder: Folder? = nil
//    dynamic var playlist: Playlist? = nil
//}
//
//class Container: Object, OutlineRepresentable {
//    @objc var value: ContainerClasses? = nil
//    
//    var name: String {
//        if value?.playlist != nil {
//            return value!.playlist.name
//        } else if value.folder != nil {
//            return value.folder.name
//        }
//    }
//    
//    var children: [OutlineRepresentable.Type]?
//    
//    var parent: OutlineRepresentable.Type?
//    
//    static func == (lhs: Container, rhs: Container) -> Bool {
//        <#code#>
//    }
//}
//
//
//
//
//
//
//
//
//// For use if I go with a different solution
//enum PlaylistKind: String {
//    case folder, regular, smart, other
//    
//    func imageName() -> String {
//        switch self {
//        case .folder:
//            return "folder"
//        default:
//            return "music.note.list"
//        }
//    }
//}
