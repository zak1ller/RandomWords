//
//  MainButton.swift
//  RandomWords
//
//  Created by Min-Su Kim on 2022/08/16.
//

import Foundation
import UIKit

final class MainButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setView()
    setConstraint()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setView() {
    self.setTitleColor(.white, for: .normal)
    self.backgroundColor = .systemPink
    self.layer.cornerRadius = 8
  }
  
  private func setConstraint() {
    self.snp.makeConstraints { make in
      make.height.equalTo(56)
    }
  }
}

