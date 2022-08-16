//
//  ViewController.swift
//  RandomWords
//
//  Created by Min-Su Kim on 2022/08/15.
//

import UIKit

class HomeViewController: UIViewController {
  
  lazy var buttonStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .fill
    $0.spacing = 16
  }
  
  lazy var allWordsButton = MainButton(type: .system).then {
    $0.addTarget(self, action: #selector(allWordsTapped), for: .touchUpInside)
    $0.setTitle("All Words", for: .normal)
  }
  
  lazy var wordButton = MainButton(type: .system).then {
    $0.addTarget(self, action: #selector(wordTapped), for: .touchUpInside)
    $0.setTitle("Word", for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
    setConstraint()
  }
  
  private func setView() {
    view.addSubview(buttonStackView)
    
    buttonStackView.addArrangedSubview(allWordsButton)
    buttonStackView.addArrangedSubview(wordButton)
  }
  
  private func setConstraint() {
    buttonStackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.trailing.equalToSuperview().offset(-24)
      make.centerY.equalToSuperview()
    }
    
    allWordsButton.snp.makeConstraints { make in
      make.height.equalTo(56)
    }
    
    wordButton.snp.makeConstraints { make in
      make.height.equalTo(56)
    }
  }
}

extension HomeViewController {
  @objc func allWordsTapped() {
    let vc = AllWordsViewController()
    vc.modalPresentationStyle = .formSheet
    self.present(vc, animated: true)
  }
  
  @objc func wordTapped() {
    let vc = WordViewController()
    vc.modalPresentationStyle = .formSheet
    self.present(vc, animated: true)
  }
}

