//
//  EditPostViewModelTest.swift
//  CleanArchitectureRxSwiftTests
//
//  Created by HuyHoangDinh on 9/29/20.
//  Copyright © 2020 sergdort. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import Domain
import RxCocoa
@testable import CleanArchitectureRxSwift
class EditPostViewModelTest: XCTestCase {
    
    var allPostUseCaseMock: PostsUseCaseMock!
    var editPostNavigatorMock: EditPostNavigatorMock!
    var viewModel: EditPostViewModel!
    
    let disposeBag = DisposeBag()
    
    let post = Post(body: "123", title: "1212312312")
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        allPostUseCaseMock = PostsUseCaseMock()
        editPostNavigatorMock = EditPostNavigatorMock()
        viewModel = EditPostViewModel(post: post, useCase: allPostUseCaseMock, navigator: editPostNavigatorMock)
    }
    // chưa ấn edit
    func test_transform_editNotEmitInvoked_editButtonTitleEmit() {
        let editTrigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete()))
        output.editButtonTitle.drive().disposed(by: disposeBag)
        let newTitle = try! output.editButtonTitle.toBlocking().first()!
        
        XCTAssertEqual(newTitle, "Edit")
    }
    // ấn edit 1 lần
    func test_transform_editTriggerInvoked_editButtonTitleEmit() {
        let editTrigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete()))
        output.editButtonTitle.drive().disposed(by: disposeBag)
        editTrigger.onNext(())
        let newTitle = try! output.editButtonTitle.toBlocking().first()!
        
        XCTAssertEqual(newTitle, "Save")
        
        XCTAssertEqual(editPostNavigatorMock.toPost_Called, false)

    }
    //ấn edit 2 lần
    func test_transform_editTriggerTwoTimesInvoked_editButtonTitleEmit() {
        let editTrigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete()))
        output.editButtonTitle.drive().disposed(by: disposeBag)
        editTrigger.onNext(())
        editTrigger.onNext(())
        let newTitle = try! output.editButtonTitle.toBlocking().first()!
        
        XCTAssertEqual(newTitle, "Edit")
    }
    
    //sửa bình thường: ấn edit, sửa title và details, ấn save
    func test_transform_editTriggerInvoked_titleEmittedWithTitleAndDetailsEmitted() {
        let editTrigger = PublishSubject<Void>()
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete(),
                                                            _title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        
        output.save.drive().disposed(by: disposeBag)
        
        editTrigger.onNext(())
        title.onNext("123")
        details.onNext("3333")
        editTrigger.onNext(())
        
        XCTAssertEqual(allPostUseCaseMock.save_Called, true)
    }
    
    // ấn sửa và save nhưng không thay đổi title và details
    func test_transform_editTriggerInvoked_titleEmittedWithOutTitleAndDetailsEmitted() {
        let editTrigger = PublishSubject<Void>()
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete(),
                                                            _title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        
        output.save.drive().disposed(by: disposeBag)

        editTrigger.onNext(())
        editTrigger.onNext(())
        
        XCTAssertEqual(allPostUseCaseMock.save_Called, true)
    }
    
    //ấn sửa, thay đổi title và details nhưng không save
    func test_transform_editTriggerInvoked_saveNotEmitted() {
        let editTrigger = PublishSubject<Void>()
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete(),
                                                            _title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        
        output.save.drive().disposed(by: disposeBag)

        editTrigger.onNext(())
        title.onNext("123")
        details.onNext("3333")
        
        XCTAssertEqual(allPostUseCaseMock.save_Called, false)
    }
    
    // ấn sửa và save nhưng không thay đổi title
    func test_transform_editTriggerInvoked_titleEmittedWithOutTitleEmitted() {
        let editTrigger = PublishSubject<Void>()
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete(),
                                                            _title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        
        output.save.drive().disposed(by: disposeBag)

        editTrigger.onNext(())
        details.onNext("123")
        editTrigger.onNext(())
        
        XCTAssertEqual(allPostUseCaseMock.save_Called, true)
    }
    
    // ấn sửa và save nhưng không thay đổi title
    func test_transform_editTriggerInvoked_titleEmittedWithOutDetailsEmitted() {
        let editTrigger = PublishSubject<Void>()
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete(),
                                                            _title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        
        output.save.drive().disposed(by: disposeBag)

        editTrigger.onNext(())
        title.onNext("123")
        editTrigger.onNext(())
        
        XCTAssertEqual(allPostUseCaseMock.save_Called, true)
    }
    
//    // title và detail không rỗng
//    func test_transform_titleAndDetailNotEmit_titleAndDetailNotEmptyInvoked_saveButton_Enable() {
//
//        let title = PublishSubject<String>()
//        let details = PublishSubject<String>()
//
//        let output = viewModel.transform(input: createInput(_title: title.asDriverOnErrorJustComplete(),
//                                                            _details: details.asDriverOnErrorJustComplete()))
//        output.saveEnable.drive().disposed(by: disposeBag)
//        let expected = try! output.saveEnable.toBlocking().first()!
//
//        XCTAssertEqual(expected, true)
//    }
//
    
    // title và detail không rỗng
    func test_transform_titleAndDetailEmit_titleAndDetailNotEmptyInvoked_saveButton_Enable() {

        let title = PublishSubject<String>()
        let details = PublishSubject<String>()

        let output = viewModel.transform(input: createInput(_title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        title.onNext("123")
        details.onNext("323")

        let expected = try! output.saveEnable.toBlocking().first()!

        XCTAssertEqual(expected, true)
    }
    
    // title không rỗng
    func test_transform_titleEmptyAndDetailNotEmpty_saveButton_Enable() {
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        let output = viewModel.transform(input: createInput(_title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        output.saveEnable.drive().disposed(by: disposeBag)
        title.onNext("")
        details.onNext("32321")
        
        let expected = try! output.saveEnable.toBlocking().first()!
        
        XCTAssertEqual(expected, false)
    }
    
    // detail không rỗng
    func test_transform_titleNotEmptyAndDetailEmpty_saveButton_Enable() {
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        let output = viewModel.transform(input: createInput(_title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        output.saveEnable.drive().disposed(by: disposeBag)
        title.onNext("asdasd")
        details.onNext("")
        
        let expected = try! output.saveEnable.toBlocking().first()!
        
        XCTAssertEqual(expected, false)
    }
    
    // detail và title rỗng
    func test_transform_titleAndDetailEmpty_saveButton_Enable() {
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        let output = viewModel.transform(input: createInput(_title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        output.saveEnable.drive().disposed(by: disposeBag)
        title.onNext("")
        details.onNext("")
        
        let expected = try! output.saveEnable.toBlocking().first()!
        
        XCTAssertEqual(expected, false)
    }
    
    // ấn sửa, xoá hết title, ấn save
//    func test_transform_editTriggerInvoked_deleteAllTitleText() {
//        let editTrigger = PublishSubject<Void>()
//        let title = PublishSubject<String>()
//        let details = PublishSubject<String>()
//        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete(),
//                                                            _title: title.asDriverOnErrorJustComplete(),
//                                                            _details: details.asDriverOnErrorJustComplete()))
//        
//        output.save.drive().disposed(by: disposeBag)
//        output.post.drive().disposed(by: disposeBag)
//        output.editing.drive().disposed(by: disposeBag)
//        editTrigger.onNext(())
//        title.onNext("")
//        details.onNext("3333")
//        editTrigger.onNext(())
//        
//        XCTAssertEqual(allPostUseCaseMock.save_Called, false)
//    }
    
    // xoá thành công
    func test_transform_deleteTriggerInvoked_deletePostEmitted() {
        let deleteTrigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(_deleteTrigger: deleteTrigger.asDriverOnErrorJustComplete()))
        
        output.delete.drive().disposed(by: disposeBag)
        deleteTrigger.onNext(())
        
        XCTAssertEqual(editPostNavigatorMock.toPost_Called, true)
        
        XCTAssertEqual(allPostUseCaseMock.delete_Called, true)
        XCTAssertEqual(allPostUseCaseMock.posts_Called, false)
        XCTAssertEqual(allPostUseCaseMock.save_Called, false)
    }
    
    //không ấn edit emit đang không edit
    func test_transform_editNotTriggerInvoked_editingEmit() {
        let editTrigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete()))
        
        output.editing.drive().disposed(by: disposeBag)
        
        let expected = try! output.editing.toBlocking().first()!
        
        XCTAssertEqual(expected, false)
    }
    
    //ấn edit emit đang edit
    func test_transform_editTriggerInvoked_editingEmit() {
        let editTrigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete()))
        
        output.editing.drive().disposed(by: disposeBag)
        editTrigger.onNext(())
        
        let expected = try! output.editing.toBlocking().first()!
        
        XCTAssertEqual(expected, true)
    }
    
    //ấn edit rồi ấn save -> emit đang không edit
    func test_transform_editTriggerSecondTimesInvoked_editingEmit() {
        let editTrigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete()))
        
        output.editing.drive().disposed(by: disposeBag)
        editTrigger.onNext(())
        editTrigger.onNext(())
        let expected = try! output.editing.toBlocking().first()!
        
        XCTAssertEqual(expected, false)
    }
    
    //title emit -> post emit
    func test_transform_titleEmitInvoked_postEmited() {
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        let output = viewModel.transform(input: createInput(_title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        output.post.drive().disposed(by: disposeBag)
        title.onNext("acbc")
        
        let expectedPost = Post(body: post.body, title: "acbc", uid: post.uid, userId: post.userId, createdAt: post.createdAt)
        let postResult = try! output.post.toBlocking().first()!
        
        XCTAssertEqual(expectedPost, postResult)
    }
    
    //detail emit -> post emit
    func test_transform_detailEmitInvoked_postEmited() {
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        let output = viewModel.transform(input: createInput(_title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        output.post.drive().disposed(by: disposeBag)
        details.onNext("acbc")
        
        let expectedPost = Post(body: "acbc", title: post.title, uid: post.uid, userId: post.userId, createdAt: post.createdAt)
        let postResult = try! output.post.toBlocking().first()!
        
        XCTAssertEqual(expectedPost, postResult)
    }
    
    //title emit -> post emit
    func test_transform_detailAndTitleEmitInvoked_postEmited() {
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        let output = viewModel.transform(input: createInput(_title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        output.post.drive().disposed(by: disposeBag)
        details.onNext("acbc")
        title.onNext("acbc")
        
        let expectedPost = Post(body: "acbc", title: "acbc", uid: post.uid, userId: post.userId, createdAt: post.createdAt)
        let postResult = try! output.post.toBlocking().first()!
        
        XCTAssertEqual(expectedPost, postResult)
    }
    
    //title và details không emit -> post emit
    func test_transform_detailAndTitleNotEmitInvoked_postEmited() {
        let title = PublishSubject<String>()
        let details = PublishSubject<String>()
        let output = viewModel.transform(input: createInput(_title: title.asDriverOnErrorJustComplete(),
                                                            _details: details.asDriverOnErrorJustComplete()))
        output.post.drive().disposed(by: disposeBag)
        
        let expectedPost = Post(body: post.body, title: post.title, uid: post.uid, userId: post.userId, createdAt: post.createdAt)
        let postResult = try! output.post.toBlocking().first()!
        
        XCTAssertEqual(expectedPost, postResult)
    }
    
    func test_transform_saveTriggerError_trackError() {
        let editTrigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(_editTrigger: editTrigger.asDriverOnErrorJustComplete()))
        
        allPostUseCaseMock.save_ReturnValue = Observable.error(TestError.test)
        
        output.save.drive().disposed(by: disposeBag)
        output.error.drive().disposed(by: disposeBag)
        
        editTrigger.onNext(())
        editTrigger.onNext(())
        
        let error = try! output.error.toBlocking().first()!
        
        XCTAssertNotNil(error)
    }
    
    func test_transform_deleteTriggerError_trackError() {
        let deleteTrigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(_deleteTrigger: deleteTrigger.asDriverOnErrorJustComplete()))
        
        allPostUseCaseMock.delete_ReturnValue = Observable.error(TestError.test)
        
        output.delete.drive().disposed(by: disposeBag)
        output.error.drive().disposed(by: disposeBag)
        
        deleteTrigger.onNext(())
        
        let error = try! output.error.toBlocking().first()!
        
        XCTAssertNotNil(error)
    }
    
    func createInput(_editTrigger: Driver<Void> = Driver.never(),
                     _deleteTrigger: Driver<Void> = Driver.never(),
                     _title: Driver<String> = Driver.never(),
                     _details: Driver<String> = Driver.never()) -> EditPostViewModel.Input {
        
        return EditPostViewModel.Input(editTrigger: _editTrigger, deleteTrigger: _deleteTrigger, title: _title, details: _details)
    }
}
