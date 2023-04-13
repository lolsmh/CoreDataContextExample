//
//  ProjectListItemVM.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import Foundation

struct ProjectListItemVM: Equatable, Identifiable, Hashable {
	let id: String
	let title: String
	
	init(project: ProjectCoreDataEntity) {
		id = project.projectId
		title = project.name
	}
}
