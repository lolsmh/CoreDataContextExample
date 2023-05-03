//
//  ProjectVM.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import Foundation
import Combine
import UIKit

typealias ProjectSnapshot = NSDiffableDataSourceSnapshot<ProjectSection, ProjectTaskVM>

protocol ProjectVM {
	var snapshotPublisher: AnyPublisher<ProjectSnapshot, Never> { get }
	var projectName: String { get }
	
	func createNewTask(name: String)
	func deleteTask(taskId: String)
	func setTaskDescription(taskId: String, description: String?)
}

final class ProjectVMImpl: ProjectVM {
	
	let projectName: String
	var snapshotPublisher: AnyPublisher<ProjectSnapshot, Never> {
		snapshotSubject.eraseToAnyPublisher()
	}

	private let tasksService: TasksService
	private let projectsService: ProjectsService
	private let projectId: String
	private let snapshotSubject = CurrentValueSubject<ProjectSnapshot, Never>(.init())
	private var subscriptions = [AnyCancellable]()
	
	init(
		tasksService: TasksService,
		projectsService: ProjectsService,
		projectId: String
	) {
		self.tasksService = tasksService
		self.projectsService = projectsService
		self.projectId = projectId
		self.projectName = projectsService.fetchProject(projectId: projectId)?.name ?? "Потерянныый проект"
		
		updateData()
	}
	
	func createNewTask(name: String) {
		tasksService.createNewTask(
			projectId: projectId,
			name: name
		)
		.sink { [weak self] in
			self?.updateData()
		}
		.store(in: &subscriptions)
	}
	
	func deleteTask(taskId: String) {
		tasksService.deleteTask(taskId: taskId)
			.sink { [weak self] in
				self?.updateData()
			}
			.store(in: &subscriptions)
	}
	
	func setTaskDescription(taskId: String, description: String?) {
		tasksService.changeTaskDescription(
			taskId: taskId,
			description: description
		)
			.sink { [weak self] in
				self?.updateData()
			}
			.store(in: &subscriptions)
	}
	
	private func updateData() {
		var snapshot = ProjectSnapshot()
		let tasks = tasksService.fetchTasks(projectId: projectId)
		let items = tasks.map(ProjectTaskVM.init)
		
		snapshot.appendSections([.tasks])
		snapshot.appendItems(items, toSection: .tasks)
		
		snapshotSubject.send(snapshot)
	}
}
