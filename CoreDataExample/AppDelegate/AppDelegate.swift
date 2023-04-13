//
//  AppDelegate.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	// MARK: - Internal Properties
	
	var window: UIWindow?
	
	// MARK: - Internal Methods
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		
		window = UIWindow()
		window?.backgroundColor = .white
		let projectsService = ProjectsServiceImpl()
		let viewModel = ProjectListVMImpl(projectsService: projectsService)
		let rootViewController = ProjectListVC(viewModel: viewModel)
		let navigationController = UINavigationController(rootViewController: rootViewController)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
		return true
	}
}

