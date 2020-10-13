//
//  CreatePostNavigatorMock.swift
//  CleanArchitectureRxSwiftTests
//
//  Created by HuyHoangDinh on 9/29/20.
//  Copyright © 2020 sergdort. All rights reserved.
//

import Foundation
@testable import CleanArchitectureRxSwift

class CreatePostNagivatorMock: CreatePostNavigator {
    
    var toPost_Called = false
    
    func toPosts() {
        toPost_Called = true
    }
    
}
