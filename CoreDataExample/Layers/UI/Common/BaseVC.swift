//
//  BaseVC.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import UIKit

open class BaseVC<RootView: UIView>: UIViewController, HasRootView {
	
	// MARK: - Initialization/Deinitialization
	
	public init() {
		guard type(of: self) != BaseVC.self else {
			fatalError("Create subclass of an abstract class '\(String(describing: BaseVC.self))'")
		}
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable, message: "init(coder:) has not been implemented")
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle methods
	
	override open func loadView() {
		view = RootView()
	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		bindUI()
	}

	// MARK: - Public methods

	/// Called in `viewDidLoad` call before `bindUI` call.
	/// Override this method to setup UI.
	/// Default implementation does nothing.
	open func setupUI() {}
	
	/// Called in `viewDidLoad` call after `setupUI` call.
	/// Override this method to bind VM.
	/// Default implementation does nothing.
	open func bindUI() {}
}
