//
//  WordViewController.swift
//  RandomWords
//
//  Created by Min-Su Kim on 2022/08/16.
//

import UIKit
import Combine

class WordViewController: UIViewController {
  
  let viewModel: WordViewModel = WordViewModel()
  var subscriptions = Set<AnyCancellable>()
  
  lazy var titleLabel = UILabel().then {
    $0.text = "Word"
    $0.textColor = .white
    $0.textAlignment = .center
  }
  
  lazy var centerStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .fill
    $0.spacing = 16
  }
  
  lazy var randomWordLabel = UILabel().then {
    $0.isUserInteractionEnabled = true
    $0.text = "dummy data"
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 25, weight: .heavy)
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  lazy var reloadButton = UIButton(type: .system).then {
    $0.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
    $0.setTitle("Reload", for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
    setConstraint()
    bind()
    viewModel.fetchWord()
  }
  
  private func bind() {
    viewModel.$word
      .receive(on: RunLoop.main)
      .sink { word in
        if word.isEmpty {
          self.randomWordLabel.text = "..."
        } else {
          self.randomWordLabel.text = word
        }
      }
      .store(in: &subscriptions)
  }
  
  private func setView() {
    view.backgroundColor = .black
    
    view.addSubview(titleLabel)
    view.addSubview(centerStackView)
    
    centerStackView.addArrangedSubview(randomWordLabel)
    centerStackView.addArrangedSubview(reloadButton)
  }
  
  private func setConstraint() {
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.trailing.equalToSuperview().offset(-24)
      make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(24)
    }
    
    centerStackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.trailing.equalToSuperview().offset(-24)
      make.centerY.equalToSuperview()
    }
    
    randomWordLabel.snp.makeConstraints { make in
      make.height.equalTo(40)
    }
  }
}

extension WordViewController {
  @objc private func reloadButtonTapped() {
    viewModel.fetchWord(isReload: true)
  }
}
