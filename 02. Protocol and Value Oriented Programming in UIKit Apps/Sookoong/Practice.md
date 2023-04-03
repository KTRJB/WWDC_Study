```swift
//
//  ViewController.swift
//  Protocol and Value Oriented Programming in UIKit Apps
//
//  Created by 전민수 on 2023/04/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class ViewController: UIViewController {
//    private let myTouchView = UIView()
    private let myTouchView = TouchView("빨간색 View가 터치되었습니다")

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()

//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
//
//        myTouchView.addGestureRecognizer(tapGesture)
    }

//    @objc private func onTapGesture(sender: UITapGestureRecognizer) {
//        print("Tapped")
//    }

    private func setupLayout() {
        view.addSubview(myTouchView)

        myTouchView.backgroundColor = .red
        myTouchView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            myTouchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            myTouchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            myTouchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            myTouchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
}

protocol Tappable {
    var disposeBag: DisposeBag { get }

    func setTapAction(action: @escaping () -> Void)
}

extension Tappable where Self: UIView {
    func setTapAction(action: @escaping () -> Void) {
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                action()
            })
            .disposed(by: disposeBag)
    }
}

class TouchView: UIView, Tappable {
    var disposeBag = DisposeBag()

    private let message: String

    init(_ message: String) {
        self.message = message
        super.init(frame: .zero)

        setTapAction {
            print("메세지 출력: \(message)")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

```
