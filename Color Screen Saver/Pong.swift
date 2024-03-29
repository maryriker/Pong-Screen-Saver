//
//  Color Screen Saver View.swift
//  Color Screen Saver
//
//  Created by Mary Margaret Riker on 8/6/19.
//  Copyright © 2019 Mary Margaret Riker. All rights reserved.
//

import Foundation

import ScreenSaver

class Pong: ScreenSaverView {
    
    // MARK: - Initialization
    private var ballPosition: CGPoint = .zero
    private var ballVelocity: CGVector = .zero
    private var paddlePosition: CGFloat = 0
    private let ballRadius: CGFloat = 15
    private let paddleBottomOffset: CGFloat = 100
    private let paddleSize = NSSize(width: 60, height: 20)
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        ballPosition = CGPoint(x: frame.width / 2, y: frame.height / 2)
        ballVelocity = initialVelocity()
    }
    
    private func initialVelocity() -> CGVector {
        let desiredVelocityMagnitude: CGFloat = 10
        let xVelocity = CGFloat.random(in: 2.5...7.5)
        let xSign: CGFloat = Bool.random() ? 1 : -1
        let yVelocity = sqrt(pow(desiredVelocityMagnitude, 2) - pow(xVelocity, 2))
        let ySign: CGFloat = Bool.random() ? 1 : -1
        return CGVector(dx: xVelocity * xSign, dy: yVelocity * ySign)
    }
    
    private func ballisOOB() -> (xAxis: Bool, yAxis: Bool) {
        let xAxisOOB = ballPosition.x - ballRadius <= 0 || ballPosition.x + ballRadius >= bounds.width
        let yAxisOOB = ballPosition.y - ballRadius <= 0 || ballPosition.y + ballRadius >= bounds.height
        return (xAxisOOB, yAxisOOB)
    }
    
    private func ballHitPaddle() -> Bool {
        let xBounds = (lower: paddlePosition - paddleSize.width / 2,
                      upper: paddlePosition + paddleSize.width / 2)
        let yBounds = (lower: paddleBottomOffset - paddleSize.height / 2,
                       upper: paddleBottomOffset + paddleSize.height / 2)
        return ballPosition.x >= xBounds.lower && ballPosition.x <= xBounds.upper &&         ballPosition.y - ballRadius >= yBounds.lower && ballPosition.y -              ballRadius <= yBounds.upper
    }
    
    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func draw(_ rect: NSRect) {
        // Draw a single frame in this function
        drawBackground(.white)
        drawBall()
        drawPaddle()
    }
    
    private func drawBackground(_ color: NSColor) {
        let background = NSBezierPath(rect: bounds)
        color.setFill()
        background.fill()
        
    }
    
    private func drawBall() {
        let ballRect = NSRect(x: ballPosition.x - ballRadius, y: ballPosition.y - ballRadius, width: ballRadius * 2, height: ballRadius)
        let ball = NSBezierPath(roundedRect: ballRect, xRadius: ballRadius, yRadius: ballRadius)
        NSColor.black.setFill()
        ball.fill()
    }
    
    private func drawPaddle() {
        let paddleRect = NSRect(x: paddlePosition - paddleSize.width / 2, y: paddleBottomOffset - paddleSize.height / 2, width: paddleSize.width, height: paddleSize.height)
        let paddle = NSBezierPath(rect: paddleRect)
        NSColor.black.setFill()
        paddle.fill()
    }
    
    override func animateOneFrame() {
        super.animateOneFrame()
        
        let oobAxes = ballisOOB()
        if  oobAxes.xAxis {
            ballVelocity.dx *= -1
        }
        
        if oobAxes.yAxis {
            ballVelocity.dy *= -1
            
        }
        
        let paddleContact = ballHitPaddle()
        if paddleContact {
            ballVelocity.dy *= -1
            
        }
        
        ballPosition.x += ballVelocity.dx
        ballPosition.y += ballVelocity.dy
        paddlePosition = ballPosition.x
        
        setNeedsDisplay(bounds)
        
        // Update the "state" of the screensaver in this function
    }
    
}
