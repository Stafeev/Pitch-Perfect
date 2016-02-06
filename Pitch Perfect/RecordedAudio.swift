//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Artem Stafeev on 5/31/15.
//  Copyright (c) 2015 Artem Stafeev. All rights reserved.
//

import Foundation
class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!
    init(title: String, filePathUrl: NSURL) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
}