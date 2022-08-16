//
//  WordCell.swift
//  RandomWords
//
//  Created by Min-Su Kim on 2022/08/16.
//

import UIKit

final class WordCell: UITableViewCell {
  
  lazy var wordLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 25, weight: .heavy)
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setView()
    setConstraint()
  }
  
  func configure(_ word: String) {
    wordLabel.text = word
  }
  
  private func setView() {
    contentView.backgroundColor = .black
    contentView.addSubview(wordLabel)
  }
  
  private func setConstraint() {
    wordLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.trailing.equalToSuperview().offset(-24)
      make.top.equalToSuperview().offset(16)
      make.bottom.equalToSuperview().offset(-16)
    }
  }
}
