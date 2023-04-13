//
//  ProjectListVC.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import UIKit
import Combine

typealias ProjectListDataSource = UITableViewDiffableDataSource<ProjectListSection, ProjectListItemVM>

final class ProjectListVC: BaseVC<ProjectListView> {
	
	// MARK: - Private Properties
	
	private let viewModel: ProjectListVM
	private lazy var dataSource = makeDataSource()
	private var subscriptions = [AnyCancellable]()
	
	init(viewModel: ProjectListVM) {
		self.viewModel = viewModel
		
		super.init()
	}
	
	override func setupUI() {
		super.setupUI()
		
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "Список проектов"
		rootView.tableView.register(cellType: ProjectListItemCell.self)
		rootView.tableView.delegate = self
	}
	
	override func bindUI() {
		super.bindUI()
		
		viewModel.snapshotPublisher
			.sink { [weak self] snapshot in
				self?.dataSource.apply(snapshot)
			}
			.store(in: &subscriptions)
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(handleAddProjectButton)
		)
	}
	
	@objc
	private func handleAddProjectButton() {
		
		let alert = UIAlertController(title: "Создать проект", message: "Введите название проекта", preferredStyle: .alert)
		
		alert.addTextField { alertTextField in
			alertTextField.placeholder = "Название..."
		}
		
		let action = UIAlertAction(title: "Создать", style: .default) { [weak self] action in
			guard let projectName = alert.textFields?.first?.text else { return }
			
			self?.viewModel.createNewProject(name: projectName)
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}

extension ProjectListVC: UITableViewDelegate {
	func tableView(
		_ tableView: UITableView,
		trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completionHandler in
			
			guard let projectId = self?.dataSource.itemIdentifier(for: indexPath)?.id else {
				completionHandler(false)
				return
			}
			
			self?.viewModel.deleteProject(projectId: projectId)
			completionHandler(true)
		}
		
		let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
		configuration.performsFirstActionWithFullSwipe = false
		
		return configuration
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let projectId = dataSource.itemIdentifier(for: indexPath)?.id else {
			return
		}
		
		let tasksService = TasksServiceImpl()
		let projectsService = ProjectsServiceImpl()
		let projectVM = ProjectVMImpl(
			tasksService: tasksService,
			projectsService: projectsService,
			projectId: projectId
		)
		let viewController = ProjectVC(viewModel: projectVM)
		
		navigationController?.pushViewController(viewController, animated: true)
	}
}

// MARK: - Factory

private extension ProjectListVC {
	
	func makeDataSource() -> ProjectListDataSource {
		ProjectListDataSource(tableView: rootView.tableView) { tableView, indexPath, itemIdentifier in
			tableView.dequeueReusableCell(
				for: indexPath,
				cellType: ProjectListItemCell.self
			)
			.configured(viewModel: itemIdentifier)
		}
	}
}
