//
//  TaskCell.swift
//  CoreDataExample
//
//  Created by Daniil on 13/4/23.
//

import UIKit
import SnapKit

final class TaskCell: UITableViewCell {
	
	private lazy var titleLabel = makeTitleLabel()
	private lazy var subtitleLabel = makeSubtitleLabel()
	private lazy var stackView = makeStackView()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		setupUI()
	}
	
	func configured(viewModel: ProjectTaskVM) -> Self {
		titleLabel.text = viewModel.title
		subtitleLabel.text = viewModel.description
		
		return self
	}
	
	private func setupUI() {
		contentView.addSubview(stackView)
		
		stackView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(16)
			make.top.bottom.equalToSuperview().inset(8)
		}
		
		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(subtitleLabel)
	}
}

// MARK: - Factory

private extension TaskCell {
	func makeTitleLabel() -> UILabel {
		let label = UILabel()
		
		label.textColor = .black
		label.numberOfLines = .zero
		label.font = .boldSystemFont(ofSize: 18)
		
		return label
	}
	
	func makeSubtitleLabel() -> UILabel {
		let label = UILabel()
		
		label.textColor = .gray
		label.numberOfLines = .zero
		label.font = .systemFont(ofSize: 12)
		
		return label
	}
	
	func makeStackView() -> UIStackView {
		let stackView = UIStackView()
		
		stackView.axis = .vertical
		stackView.spacing = 4
		
		return stackView
	}
}
