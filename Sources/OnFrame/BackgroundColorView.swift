//
//  BackgroundColorView.swift
//  OnFrame
//
//  Created by Kristian Trenskow on 24/10/2025.
//

#if canImport(UIKit)

import UIKit

typealias BackgroundColorView = UIView

#elseif canImport(AppKit)

import AppKit

class BackgroundColorView: NSView {

	var backgroundColor: NSColor?

	override func draw(
		_ dirtyRect: NSRect
	) {

		guard let backgroundColor = self.backgroundColor
		else { return super.draw(dirtyRect) }

		backgroundColor.setFill()
		dirtyRect.fill()

	}

}

#endif
