//
//  OnFrame.swift
//  OnFrame
//
//  Created by Kristian Trenskow on 24/04/2025.
//

import SwiftUI

@MainActor
struct OnFrameDisplayLinkView: UIViewRepresentable {

	let action: @MainActor @Sendable (TimeInterval, TimeInterval) -> Void

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

	func makeCoordinator() -> Coordinator {

		let coordinator = Coordinator(
			action: self.action)

		coordinator.displayLink = CADisplayLink(
			target: coordinator,
			selector: #selector(
				Coordinator.displayLinkAction(displayLink:)))

		return coordinator

	}

	func makeUIView(context: Context) -> UIView {

		let view = UIView()

		view.backgroundColor = .clear

		return view

	}

	func updateUIView(
		_ uiView: UIView,
		context: Context
	) {}

}

@MainActor
struct OnFrameModifier: ViewModifier {

	@State private var lastTimeStamp: TimeInterval = 0

	let action: (@MainActor @Sendable (TimeInterval, TimeInterval) -> Void)?

	init(
		action: (@MainActor @Sendable (TimeInterval, TimeInterval) -> Void)?
	) {
		self.action = action
	}

	func body(content: Content) -> some View {
		content
			.background(
				OnFrameDisplayLinkView(
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
		_ action: (@MainActor @Sendable (TimeInterval, TimeInterval) -> Void)? = nil
	) -> some View {
		self.modifier(
			OnFrameModifier(
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
