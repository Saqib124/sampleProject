//
//  EntityTypes.swift
//  SampleProject
//
//  Created by Saqib Khan on 3/28/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import Foundation
/**
 Enum for holding different entity type names (Coredata Models)
 */
enum EntityTypes: String {
    case TrackInfo = "TrackInfo"
    //case Foo = "Foo"
    //case Bar = "Bar"
    
    static let getAll = [TrackInfo] //[Event, Foo,Bar]
}
