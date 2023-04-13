//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import UIKit
import Combine

typealias ProjectDataSource = UITableViewDiffableDataSource<ProjectSection, ProjectTaskVM>

final class ProjectVC: BaseVC<ProjectView> {
	
	// MARK: - Private Properties
	
	private let viewModel: ProjectVM
	private lazy var dataSource = makeDataSource()
	private var subscriptions = [AnyCancellable]()
	
	init(viewModel: ProjectVM) {
		self.viewModel = viewModel
		
		super.init()
	}
	
	override func setupUI() {
		super.setupUI()
		
		title = viewModel.projectName
		rootView.tableView.register(cellType: TaskCell.self)
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
		
		let alert = UIAlertController(title: "Создать задачу", message: "Введите название задачи", preferredStyle: .alert)
		
		alert.addTextField { alertTextField in
			alertTextField.placeholder = "Название..."
		}
		
		let action = UIAlertAction(title: "Создать", style: .default) { [weak self] action in
			guard let taskName = alert.textFields?.first?.text else { return }
			
			self?.viewModel.createNewTask(name: taskName)
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	private func showEditDescriptionAlert(taskVM: ProjectTaskVM) {
		let alert = UIAlertController(
			title: taskVM.title,
			message: taskVM.description == nil ? "Введите описание" : "Отредактируйте описание",
			preferredStyle: .alert
		)
		
		alert.addTextField { textField in
			textField.placeholder = "Название..."
			textField.text = taskVM.description
		}
		
		let action = UIAlertAction(title: "Готово", style: .default) { [weak self] action in			
			self?.viewModel.setTaskDescription(taskId: taskVM.id, description: alert.textFields?.first?.text)
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}

extension ProjectVC: UITableViewDelegate {
	func tableView(
		_ tableView: UITableView,
		trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
			
			guard let taskId = self?.dataSource.itemIdentifier(for: indexPath)?.id else {
				completion(false)
				return
			}
			
			self?.viewModel.deleteTask(taskId: taskId)
			completion(true)
		}
		
		let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
		configuration.performsFirstActionWithFullSwipe = true
		
		return configuration
	}
	
	func tableView(
		_ tableView: UITableView,
		leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		let editDescriptionAction = UIContextualAction(style: .normal, title: "Описание") { [weak self] _, _, completion in
			guard let taskVM = self?.dataSource.itemIdentifier(for: indexPath) else {
				completion(false)
				return
			}
			
			self?.showEditDescriptionAlert(taskVM: taskVM)
			completion(true)
		}
		
		editDescriptionAction.backgroundColor = .blue
		
		let configuration = UISwipeActionsConfiguration(actions: [editDescriptionAction])
		configuration.performsFirstActionWithFullSwipe = true
		
		return configuration
	}
}

// MARK: - Factory

private extension ProjectVC {
	
	func makeDataSource() -> ProjectDataSource {
		ProjectDataSource(tableView: rootView.tableView) { tableView, indexPath, itemIdentifier in
			tableView.dequeueReusableCell(
				for: indexPath,
				cellType: TaskCell.self
			)
			.configured(viewModel: itemIdentifier)
		}
	}
}
