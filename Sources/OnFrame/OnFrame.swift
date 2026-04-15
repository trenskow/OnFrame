//
//  OnFrame.swift
//  OnFrame
//
//  Created by Kristian Trenskow on 24/04/2025.
//

import SwiftUI

@MainActor
struct OnFrameDisplayLinkView: ViewRepresentable {

	class Coordinator {

		var displayLink: CADisplayLink? {
			didSet {
				oldValue?.invalidate()
				self.displayLink?.add(
					to: .main,
					forMode: .common)
			}
		}

		let action: @MainActor @Sendable (TimeInterval, TimeInterval) -> Void

		init(
			action: @MainActor @Sendable @escaping (TimeInterval, TimeInterval) -> Void
		) {
			self.action = action
		}

		deinit {
			self.displayLink = nil
		}

		@MainActor
		@objc func displayLinkAction(
			displayLink: CADisplayLink
		) {
			self.action(
				displayLink.timestamp,
				displayLink.targetTimestamp)
		}

	}

	let paused: Bool
	let action: @MainActor @Sendable (TimeInterval, TimeInterval) -> Void

	static func dismantleView(
		_ uiView: PlatformView,
		coordinator: Coordinator
	) {
		coordinator.displayLink = nil
	}

	func makeCoordinator() -> Coordinator {

		let coordinator = Coordinator(
			action: self.action)

		coordinator.displayLink = CADisplayLink.make(
			target: coordinator,
			   selector: #selector(
				   Coordinator.displayLinkAction(displayLink:)))

		return coordinator

	}

	func makeView(context: Context) -> PlatformView {

		let view = BackgroundColorView()

		view.backgroundColor = .clear

		return view

	}

	func updateView(
		_ uiView: PlatformView,
		context: Context
	) {
		context.coordinator.displayLink?.isPaused = self.paused
	}

}

@MainActor
struct OnFrameModifier: ViewModifier {

	@State private var lastTimeStamp: TimeInterval = 0

	private let paused: Bool
	private let action: (@MainActor @Sendable (TimeInterval, TimeInterval) -> Void)?

	init(
		paused: Bool,
		action: (@MainActor @Sendable (TimeInterval, TimeInterval) -> Void)?
	) {
		self.paused = paused
		self.action = action
	}

	func body(content: Content) -> some View {
		content
			.background(
				OnFrameDisplayLinkView(
					paused: self.paused,
					action: { oldTimeInterval, newTimeInterval in
						self.lastTimeStamp = newTimeInterval
						self.action?(oldTimeInterval, newTimeInterval)
					}))
			.environment(
				\.timestamp,
				 self.lastTimeStamp)
	}

}

extension View {

	@MainActor
	public func onFrame(
		paused: Bool = false,
		_ action: (@MainActor @Sendable (TimeInterval, TimeInterval) -> Void)? = nil
	) -> some View {
		self.modifier(
			OnFrameModifier(
				paused: paused,
				action: action))
	}

}

public struct TimestampKey: EnvironmentKey {
	public static let defaultValue: TimeInterval = 0
}

extension EnvironmentValues {

	public var timestamp: TimeInterval {
		get { self[TimestampKey.self] }
		set { self[TimestampKey.self] = newValue }
	}

}
