//
//  ProjectListView.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import UIKit
import SnapKit

final class ProjectListView: UIView {
	
	// MARK: - Internal Properties
	
	private(set) lazy var tableView = makeTableView()
	
	// MARK: - Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		setupUI()
	}
	
	// MARK: - Private Properties
	
	private func setupUI() {
		
		addSubview(tableView)
		
		tableView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(snp.topMargin)
			make.bottom.equalTo(snp.bottomMargin)
		}
	}
}

// MARK: - Factory

private extension ProjectListView {
	
	func makeTableView() -> UITableView {
		
		let tableView = UITableView()
		
		tableView.backgroundColor = .clear
		
		return tableView
	}
}
