import Domain
import RxSwift
import RxCocoa

final class EditPostViewModel: ViewModelType {
    private let post: Post
    private let useCase: PostsUseCase
    private let navigator: EditPostNavigator

    init(post: Post, useCase: PostsUseCase, navigator: EditPostNavigator) {
        self.post = post
        self.useCase = useCase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let editing = input.editTrigger.scan(false) { editing, _ in
            return !editing
        }.startWith(false)

        let saveTrigger = editing.skip(1) //we dont need initial state
                .filter { $0 == false }
                .mapToVoid()
        
        let titleAndDetails = Driver.combineLatest(input.title.startWith(post.title), input.details.startWith(post.body))
        
        let post = Driver.combineLatest(Driver.just(self.post), titleAndDetails) { (post, titleAndDetails) -> Post in
            
            let post = Post(body: titleAndDetails.1 , title: titleAndDetails.0 , uid: post.uid, userId: post.userId, createdAt: post.createdAt)
//            print("Logger:", post, "\n")
            return post
        }.startWith(self.post)
        
        let editButtonTitle = editing.map { editing -> String in
            return editing == true ? "Save" : "Edit"
        }
        let savePost = saveTrigger
                .withLatestFrom(post)
//                .filter {
//                    return !$0.title.isEmpty && !$0.body.isEmpty
//                }
                .flatMapLatest { post in
                    return self.useCase.save(post: post)
                            .trackError(errorTracker)
                            .asDriverOnErrorJustComplete()
                }
        
        let saveEnable = titleAndDetails.map {
            return !$0.isEmpty && !$1.isEmpty
        }.startWith(true)
        
        let deletePost = input.deleteTrigger.withLatestFrom(post)
            .flatMapLatest { post in
                return self.useCase.delete(post: post)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }.do(onNext: {
                self.navigator.toPosts()
            })

        return Output(editButtonTitle: editButtonTitle,
                save: savePost,
                saveEnable: saveEnable,
                delete: deletePost,
                editing: editing,
                post: post,
                error: errorTracker.asDriver())
    }
}

extension EditPostViewModel {
    struct Input {
        let editTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
        let title: Driver<String>
        let details: Driver<String>
    }

    struct Output {
        let editButtonTitle: Driver<String>
        let save: Driver<Void>
        let saveEnable: Driver<Bool>
        let delete: Driver<Void>
        let editing: Driver<Bool>
        let post: Driver<Post>
        let error: Driver<Error>
    }
}
