//
//  AllWordsViewController.swift
//  RandomWords
//
//  Created by Min-Su Kim on 2022/08/16.
//

import Foundation
import UIKit
import Combine
import NVActivityIndicatorView

final class AllWordsViewController: UIViewController {
  
  lazy var loadingIndicator = NVActivityIndicatorView(
    frame: .zero,
    type: .ballPulse,
    color: .white
  )
  
  lazy var titleLabel = UILabel().then {
    $0.text = "All Words"
    $0.textColor = .white
    $0.textAlignment = .center
  }
  
  lazy var tableView = UITableView().then {
    $0.register(WordCell.self, forCellReuseIdentifier: "WordCell")
    $0.delegate = self
    $0.dataSource = self
    $0.estimatedRowHeight = 100
    $0.rowHeight = UITableView.automaticDimension
    $0.backgroundColor = .clear
    $0.separatorStyle = .none
    $0.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
  }
  
  lazy var shuffleButton = MainButton(type: .system).then {
    $0.addTarget(self, action: #selector(shuffleButtonTapped), for: .touchUpInside)
    $0.setTitle("Shuffle", for: .normal)
  }
  
  let viewModel = AllWordsViewModel()
  
  var subscriptions = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setView()
    setConstraint()
    bind()
    
    viewModel.fetchWords()
  }
  
  private func bind() {
    viewModel.$words
      .receive(on: RunLoop.main)
      .sink { words in
        self.tableView.reloadData()
      }
      .store(in: &subscriptions)
    
    viewModel.$showingLoading
      .receive(on: RunLoop.main)
      .sink { showingLoading in
        if showingLoading {
          self.loadingIndicator.startAnimating()
        } else {
          self.loadingIndicator.stopAnimating()
        }
        self.setEnableShuffleButton(isEnabled: !showingLoading)
      }
      .store(in: &subscriptions)
    
    viewModel.wordTappedAction
      .sink { word in
        print(word)
      }
      .store(in: &subscriptions)
  }
  
  private func setView() {
    view.backgroundColor = .black
    
    view.addSubview(titleLabel)
    view.addSubview(tableView)
    view.addSubview(shuffleButton)
    view.addSubview(loadingIndicator)
  }
  
  private func setConstraint() {
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.trailing.equalToSuperview().offset(-24)
      make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(24)
    }
    
    tableView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.bottom.equalToSuperview()
    }
    
    shuffleButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.trailing.equalToSuperview().offset(-24)
      make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-24)
    }
    
    loadingIndicator.snp.makeConstraints { make in
      make.width.height.equalTo(32)
      make.centerX.centerY.equalToSuperview()
    }
  }
}

extension AllWordsViewController {
  @objc private func shuffleButtonTapped() {
    viewModel.shuffle()
  }
  
  private func setEnableShuffleButton(isEnabled: Bool) {
    shuffleButton.isEnabled = isEnabled
    if isEnabled {
      shuffleButton.backgroundColor = .systemPink
    } else {
      shuffleButton.backgroundColor = .lightGray
    }
  }
}

extension AllWordsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.words.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as! WordCell
    cell.configure(viewModel.words[indexPath.item])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = viewModel.words[indexPath.item]
    viewModel.wordTappedAction.send(item)
  }
}
