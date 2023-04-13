//
//  ProjectListItemCell.swift
//  CoreDataExample
//
//  Created by Daniil on 13/4/23.
//

import UIKit
import SnapKit

final class ProjectListItemCell: UITableViewCell {
	
	// MARK: - Private Properties
	
	private lazy var titleLabel = makeTitleLabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		setupUI()
	}
	
	private func setupUI() {
		
		backgroundColor = .white
		contentView.addSubview(titleLabel)
		
		titleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(16)
			make.top.bottom.equalToSuperview().inset(8)
		}
	}
	
	func configured(viewModel: ProjectListItemVM) -> Self {
		titleLabel.text = viewModel.title
		
		return self
	}
}

// MARK: - Factory

private extension ProjectListItemCell {
	func makeTitleLabel() -> UILabel {
		let label = UILabel()
		
		label.textColor = .black
		label.numberOfLines = .zero
		label.font = .boldSystemFont(ofSize: 18)
		
		return label
	}
}
