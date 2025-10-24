//
//  CADisplayLink.swift
//  OnFrame
//
//  Created by Kristian Trenskow on 24/10/2025.
//

import QuartzCore

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension CADisplayLink {

	@MainActor
	static func make(
		target: Any,
		selector: Selector
	) -> CADisplayLink? {

		#if canImport(UIKit)

		return CADisplayLink(
			target: target,
			selector: selector)

		#elseif canImport(AppKit)

		return NSApplication.shared
			.mainWindow?
			.displayLink(
				target: target,
				selector: selector)

		#endif

	}

}
