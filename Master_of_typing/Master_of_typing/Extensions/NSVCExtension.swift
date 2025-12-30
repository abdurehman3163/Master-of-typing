//
//  AppDelegate.swift
//  AI Hashtag Generator
//
//  Created by Personal on 14/04/2025.
//

import AppKit


extension NSViewController {
    func addChildViewControllerWithSlideAnimation(_ controller: NSViewController) {
        addChild(controller)
        let initialFrame = view.bounds.offsetBy(dx: -view.bounds.width, dy: 0)
        let finalFrame = view.bounds
        controller.view.frame = initialFrame
        view.addSubview(controller.view)
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.5
            controller.view.animator().frame = finalFrame
        } completionHandler: { [weak self] in
            guard let self else { return }
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                controller.view.topAnchor.constraint(equalTo: view.topAnchor),
                controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    func addChildViewControllerWithAnimation(_ controller: NSViewController, to containerView: NSView) {
        addChild(controller)
        controller.view.wantsLayer = true
        var initialFrame = containerView.bounds
        initialFrame.origin.x = containerView.bounds.width
        controller.view.frame = initialFrame
        controller.view.autoresizingMask = [.width, .height]
        containerView.addSubview(controller.view)
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            controller.view.animator().frame = containerView.bounds
        }
    }
    func addChildToNavigation(_ controller: NSViewController) {
        addChild(controller)
        controller.view.wantsLayer = true
        var initialFrame = view.bounds
        initialFrame.origin.x = view.bounds.width
        controller.view.frame = initialFrame
        controller.view.autoresizingMask = [.width, .height]
        let finalFrame = view.bounds
        view.addSubview(controller.view)
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            controller.view.animator().frame = finalFrame
        }
    }
    func removeChildFromNavigation() {
        let finalFrame = view.frame.offsetBy(dx: view.bounds.width, dy: 0)
        NSAnimationContext.runAnimationGroup({ [weak self] context in
            guard let self else { return }
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            view.animator().frame = finalFrame
        }, completionHandler: { [weak self] in
            guard let self else { return }
            view.removeFromSuperview()
            removeFromParent()
        })
    }
    
    func removeChild() {
        view.removeFromSuperview()
        removeFromParent()
    }
}
