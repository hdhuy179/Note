import UIKit
import RxSwift
import RxCocoa
import Domain

final class EditPostViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var viewModel: EditPostViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let dri = BehaviorSubject<String>(value: "a")
//        dri.asDriverOnErrorJustComplete().drive(onNext: { (str) in
//                self.titleTextField.text = str + " 2 "
//            }).disposed(by: disposeBag)
////        dri.asDriverOnErrorJustComplete().drive(onNext: { (str) in
////                self.titleTextField.text = str + " 4 "
////            }).disposed(by: disposeBag)
//        titleTextField.rx.controlEvent(.editingChanged).withLatestFrom(titleTextField.rx.text.orEmpty).bind { (str) in
//            dri.onNext(str + " 1 ")
//        }.disposed(by: disposeBag)
////        titleTextField.rx.text.orEmpty.bind { (str) in
////            dri.onNext(str + " 3 ")
////        }.disposed(by: disposeBag)
//        return
//
        let deleteTrigger = deleteButton.rx.tap.flatMap {
            return Observable<Void>.create { observer in

                let alert = UIAlertController(title: "Delete Post",
                    message: "Are you sure you want to delete this post?",
                    preferredStyle: .alert
                )
                let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ -> () in observer.onNext(()) })
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(yesAction)
                alert.addAction(noAction)

                self.present(alert, animated: true, completion: nil)

                return Disposables.create()
            }
        }
        
//        titleTextField.rx.text.orEmpty.subscribe { (event) in
//            print("Logger title: ",event)
//        }.disposed(by: disposeBag)
//
//        detailsTextView.rx.text.orEmpty.subscribe { (event) in
//            print("Logger details: ",event)
//        }.disposed(by: disposeBag)
        
        let input = EditPostViewModel.Input(
            editTrigger: editButton.rx.tap.asDriver(),
            deleteTrigger: deleteTrigger.asDriverOnErrorJustComplete(),
            title: titleTextField.rx.text.orEmpty.asDriver(),
            details:  detailsTextView.rx.text.orEmpty.asDriver()
            //detailsTextView.rx.didChange.withLatestFrom(detailsTextView.rx.text.orEmpty).asDriverOnErrorJustComplete()
        )

        let output = viewModel.transform(input: input)

//        output.post.drive(onNext: { (event) in
//                print("Logger VC output post: ",event)
//            }).disposed(by: disposeBag)
        
//        output.post.drive(onNext: { (post) in
//            print("Logger VC output post:", post)
//        }, onCompleted: {
//            print("logger VC out post complete")
//        }) {
//            print("logger VC out post dispose")
//        }.disposed(by: disposeBag)
        
        [output.editButtonTitle.drive(editButton.rx.title),
        output.editing.drive(titleTextField.rx.isEnabled),
        output.editing.drive(detailsTextView.rx.isEditable),
        output.post.drive(postBinding),
        output.save.drive(),
        output.saveEnable.drive(editButton.rx.isEnabled),
        output.error.drive(errorBinding),
        output.delete.drive()]
            .forEach({$0.disposed(by: disposeBag)})
        
        
    }

    var postBinding: Binder<Post> {
        
        return Binder(self, binding: { (vc, post) in
//            print("vao day")
            print("Logger VC binder: ", post)
            vc.titleTextField.text = post.title
            vc.detailsTextView.text = post.body
            vc.title = post.title
        })
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, _) in
            let alert = UIAlertController(title: "Save Error",
                                          message: "Something went wrong",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss",
                                       style: UIAlertAction.Style.cancel,
                                       handler: nil)
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        })
    }
}



extension Reactive where Base: UITextView {
    var isEditable: Binder<Bool> {
        return Binder(self.base, binding: { (textView, isEditable) in
            textView.isEditable = isEditable
        })
    }
}
