//
//  ViewRepresentable.swift
//  OnFrame
//
//  Created by Kristian Trenskow on 24/10/2025.
//

import SwiftUI

#if canImport(UIKit)
typealias PlatformViewRepresentable = UIViewRepresentable
typealias PlatformView = UIView
#elseif canImport(AppKit)
typealias PlatformViewRepresentable = NSViewRepresentable
typealias PlatformView = NSView
#endif

@MainActor
protocol ViewRepresentable: PlatformViewRepresentable {

	associatedtype PlatformViewType: PlatformView

	static func dismantleView(
		_ uiView: PlatformViewType,
		coordinator: Coordinator)

	func makeView(
		context: Context
	) -> PlatformViewType

	func updateView(
		_ view: PlatformViewType,
		context: Context)

}

extension ViewRepresentable {

	static func dismantleView(
		_ uiView: PlatformViewType,
		coordinator: Coordinator
	) { }

}

#if canImport(UIKit)

extension ViewRepresentable {

	static func dismantleUIView(
		_ uiView: PlatformViewType,
		coordinator: Coordinator
	) {
		Self.dismantleView(
			uiView,
			coordinator: coordinator)
	}

	func makeUIView(
		context: Context
	) -> PlatformViewType {
		return self.makeView(
			context: context)
	}

	func updateUIView(
		_ uiView: PlatformViewType,
		context: Context) {
			return self.updateView(
				uiView,
				context: context)
	}

}

#elseif canImport(AppKit)

extension ViewRepresentable {

	static func dismantleNSView(
		_ nsView: PlatformViewType,
		coordinator: Coordinator
	) {
		self.dismantleView(
			nsView,
			coordinator: coordinator)
	}

	func makeNSView(
		context: Context
	) -> PlatformViewType {
		return self.makeView(
			context: context)
	}

	func updateNSView(
		_ nsView: PlatformViewType,
		context: Context
	) {
		return self.updateView(
			nsView,
			context: context)
	}

}

#endif
