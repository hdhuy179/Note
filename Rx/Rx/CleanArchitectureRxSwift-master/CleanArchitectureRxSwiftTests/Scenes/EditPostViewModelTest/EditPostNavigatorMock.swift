//
//  EditPostNavigatorMock.swift
//  CleanArchitectureRxSwiftTests
//
//  Created by HuyHoangDinh on 9/29/20.
//  Copyright © 2020 sergdort. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain
@testable import CleanArchitectureRxSwift

class EditPostNavigatorMock: EditPostNavigator {
    
    var toPost_Called = false
    
    func toPosts() {
        toPost_Called = true
    }
    
}
