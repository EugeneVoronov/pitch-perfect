//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Eugene Voronov on 2015-04-10.
//  Copyright (c) 2015 Eugene Voronov. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl    = filePathUrl
        self.title          = title
    }
}
