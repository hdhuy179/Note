//
//  CreatePostViewModelTests.swift
//  CleanArchitectureRxSwiftTests
//
//  Created by HuyHoangDinh on 9/29/20.
//  Copyright © 2020 sergdort. All rights reserved.
//

import XCTest
import Domain
import RxSwift
import RxCocoa
import RxBlocking
@testable import CleanArchitectureRxSwift
class CreatePostViewModelTests: XCTestCase {

    var createPostNavigator: CreatePostNagivatorMock!
    var allPostUseCase: PostsUseCaseMock!
    var viewModel: CreatePostViewModel!
    
    let disposeBag = DisposeBag()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        createPostNavigator = CreatePostNagivatorMock()
        allPostUseCase = PostsUseCaseMock()
        viewModel = CreatePostViewModel(createPostUseCase: allPostUseCase, navigator: createPostNavigator)
    }
    
    func test_transform_cancelTriggerEmited() {
        let cancelTrigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(_cancelTrigger: cancelTrigger.asDriverOnErrorJustComplete()))
        
        output.dismiss.drive().disposed(by: disposeBag)
        output.saveEnabled.drive().disposed(by: disposeBag)
        cancelTrigger.onNext(())
        
        XCTAssertTrue(createPostNavigator.toPost_Called)
        
        XCTAssertFalse(allPostUseCase.posts_Called)
        XCTAssertFalse(allPostUseCase.delete_Called)
        XCTAssertFalse(allPostUseCase.save_Called)
    }
    
    func test_transform_saveTriggerInvoked_emptyTitleAndEmptyDetails() {
        let saveTrigger = PublishSubject<Void>()
        let title = Driver.of("")
        let details = Driver.of("")
        let output = viewModel.transform(input: createInput(_saveTrigger: saveTrigger.asDriverOnErrorJustComplete(), _title: title, _details: details))
        
        output.dismiss.drive().disposed(by: disposeBag)
        saveTrigger.onNext(())
        
        XCTAssertFalse(createPostNavigator.toPost_Called)
        
        XCTAssertFalse(allPostUseCase.posts_Called)
        XCTAssertFalse(allPostUseCase.delete_Called)
        XCTAssertFalse(allPostUseCase.save_Called)
    }
    
    func test_transform_saveTriggerInvoked_titleAndDetailsNotEmit() {
           let saveTrigger = PublishSubject<Void>()
           
           let output = viewModel.transform(input: createInput(_saveTrigger: saveTrigger.asDriverOnErrorJustComplete()))
           
           output.dismiss.drive().disposed(by: disposeBag)
           saveTrigger.onNext(())
           
           XCTAssertFalse(createPostNavigator.toPost_Called)
           
           XCTAssertFalse(allPostUseCase.posts_Called)
           XCTAssertFalse(allPostUseCase.delete_Called)
           XCTAssertFalse(allPostUseCase.save_Called)
       }
    
    func test_transform_saveTriggerInvoked_emptyDetails() {
        let saveTrigger = PublishSubject<Void>()
        let title = Driver.of("123")
        let detail = Driver.of("")
        let output = viewModel.transform(input: createInput(_saveTrigger: saveTrigger.asDriverOnErrorJustComplete(), _title: title, _details: detail))
        
        output.dismiss.drive().disposed(by: disposeBag)
        saveTrigger.onNext(())
        
        XCTAssertFalse(createPostNavigator.toPost_Called)
        
        XCTAssertFalse(allPostUseCase.posts_Called)
        XCTAssertFalse(allPostUseCase.delete_Called)
        XCTAssertFalse(allPostUseCase.save_Called)
    }
    
    func test_transform_saveTriggerInvoked_detailsNotEmit() {
        let saveTrigger = PublishSubject<Void>()
        let title = Driver.of("123")
        let output = viewModel.transform(input: createInput(_saveTrigger: saveTrigger.asDriverOnErrorJustComplete(), _title: title))
        
        output.dismiss.drive().disposed(by: disposeBag)
        saveTrigger.onNext(())
        
        XCTAssertFalse(createPostNavigator.toPost_Called)
        
        XCTAssertFalse(allPostUseCase.posts_Called)
        XCTAssertFalse(allPostUseCase.delete_Called)
        XCTAssertFalse(allPostUseCase.save_Called)
    }
    
    func test_transform_saveTriggerInvoked_emptyTitle() {
        let saveTrigger = PublishSubject<Void>()
        let details = Driver.of("123")
        let title = Driver.of("")
        let output = viewModel.transform(input: createInput(_saveTrigger: saveTrigger.asDriverOnErrorJustComplete(), _title: title, _details: details))
        
        output.dismiss.drive().disposed(by: disposeBag)
        saveTrigger.onNext(())
        
        XCTAssertFalse(createPostNavigator.toPost_Called)
        
        XCTAssertFalse(allPostUseCase.posts_Called)
        XCTAssertFalse(allPostUseCase.delete_Called)
        XCTAssertFalse(allPostUseCase.save_Called)
    }
    
    func test_transform_saveTriggerInvoked_titleNotEmit() {
        let saveTrigger = PublishSubject<Void>()
        let details = Driver.of("123")
        let output = viewModel.transform(input: createInput(_saveTrigger: saveTrigger.asDriverOnErrorJustComplete(), _details: details))
        
        output.dismiss.drive().disposed(by: disposeBag)
        saveTrigger.onNext(())
        
        XCTAssertFalse(createPostNavigator.toPost_Called)
        
        XCTAssertFalse(allPostUseCase.posts_Called)
        XCTAssertFalse(allPostUseCase.delete_Called)
        XCTAssertFalse(allPostUseCase.save_Called)
    }
    
    func test_transform_saveTriggerInvoked_detailsAndTitle() {
        let saveTrigger = PublishSubject<Void>()
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        
        let output = viewModel.transform(input: createInput(_saveTrigger: saveTrigger.asDriverOnErrorJustComplete(), _title: title.asDriverOnErrorJustComplete(), _details: details.asDriverOnErrorJustComplete()))
        
        output.dismiss.drive().disposed(by: disposeBag)
        title.onNext("123")
        details.onNext("123")
        saveTrigger.onNext(())
        
        XCTAssertTrue(createPostNavigator.toPost_Called)
        
        XCTAssertFalse(allPostUseCase.posts_Called)
        XCTAssertFalse(allPostUseCase.delete_Called)
        XCTAssertTrue(allPostUseCase.save_Called)
    }
    
    
    func test_transform_emptyTitleAndEmptyDetailsEmitInvoked_saveEnableEmited() {
        let title = Driver.of("")
        let details = Driver.of("")
        let output = viewModel.transform(input: createInput(_title: title, _details: details))
        
        output.saveEnabled.drive().disposed(by: disposeBag)
        
        let expected = try! output.saveEnabled.toBlocking().first()!
        
        XCTAssertEqual(expected, false)
    }
    
    func test_transform_fullTitleAndDetailsEmitInvoked_saveEnableEmited() {
        let title = Driver.of("123")
        let details = Driver.of("456")
        let output = viewModel.transform(input: createInput(_title: title, _details: details))
        
        output.saveEnabled.drive().disposed(by: disposeBag)
        
        let expected = try! output.saveEnabled.toBlocking().first()!
        
        XCTAssertEqual(expected, true)
    }
    
    func test_transform_emptyTitleEmitedInvoked_saveEnableEmited() {
        let title = Driver.of("")
        let details = Driver.of("123")
        let output = viewModel.transform(input: createInput(_title: title, _details: details))
        
        output.saveEnabled.drive().disposed(by: disposeBag)
        
        let expected = try! output.saveEnabled.toBlocking().first()!
        
        XCTAssertEqual(expected, false)
    }
    
    func test_transform_titleNotEmitInvoked_saveEnableEmited() {
        let details = Driver.of("123")
        let output = viewModel.transform(input: createInput(_details: details))
        
        let expectation = self.expectation(description: "Waiting for save enable emit")
        expectation.isInverted = true
        output.saveEnabled.asObservable().bind { result in
            if result {
                expectation.fulfill()
            }
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_transform_emptyDetailsEmitedInvoked_saveEnableEmited() {
        let title = Driver.of("123")
        let details = Driver.of("")
        let output = viewModel.transform(input: createInput(_title: title, _details: details))
        
        output.saveEnabled.drive().disposed(by: disposeBag)
        
        let expected = try! output.saveEnabled.toBlocking().first()!
        
        XCTAssertEqual(expected, false)
    }
    
    func test_transform_detailsNotEmitInvoked_saveEnableEmited() {
        let title = Driver.of("123")
        let output = viewModel.transform(input: createInput(_title: title))
        
        let expectation = self.expectation(description: "Waiting for save enable emit")
        expectation.isInverted = true
        output.saveEnabled.asObservable().bind { result in
            if result {
                expectation.fulfill()
            }
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func createInput(_cancelTrigger: Driver<Void> = Driver.never(),
                     _saveTrigger: Driver<Void> = Driver.never(),
                     _title: Driver<String> = Driver.never(),
                     _details: Driver<String> = Driver.never()) -> CreatePostViewModel.Input {
        return CreatePostViewModel.Input(cancelTrigger: _cancelTrigger, saveTrigger: _saveTrigger, title: _title, details: _details)
    }

}
