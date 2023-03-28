//
//  Renderer.swift
//  WWDCExample
//
//  Created by 김주영 on 2023/03/27.
//

import Foundation

protocol Renderer {
    func moveTo(_ p: CGPoint)
    func lineTo(_ p: CGPoint)
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
    
    func circleAt(center: CGPoint, radius: CGFloat)
}

struct TestRenderer: Renderer {
    func moveTo(_ p: CGPoint) { print("moveTo(\(p.x), \(p.y)") }
    
    func lineTo(_ p: CGPoint) { print("moveTo(\(p.x), \(p.y)") }
    
    func arcAt(center: CGPoint, radius: CGFloat,
               startAngle: CGFloat, endAngle: CGFloat) {
        print("arcAt(\(center), radius: \(radius),"
              + " startAngle \(startAngle), endAngle: \(endAngle)")
    }
}


// 그리기 요소에 대한 공통 인터페이스
protocol Drawable {
    func draw(renderer: Renderer)
//    func isEqualTo(other: Drawable) -> Bool
}

struct Polygon: Drawable {
    var corners: [CGPoint] = []
    
    func draw(renderer: Renderer) {
        renderer.moveTo(corners.last!)
        for p in corners {
            renderer.lineTo(p)
        }
    }
}

// => 모두 값 타입으로 이루어짐 protocol, struct, CGPoint

struct Circle: Drawable {
    var center: CGPoint
    var radius: CGFloat
    
    func draw(renderer: Renderer) {
        renderer.arcAt(center: center, radius: radius, startAngle: 0.0, endAngle: 2 * 3.14)
    }
}

struct Diagram: Drawable {
    var elements: [Drawable] = []
    
    func draw(renderer: Renderer) {
        for f in elements {
            f.draw(renderer: renderer)
        }
    }
}

var circle = Circle(center: CGPoint(x: 187.5, y: 333.5), radius: 93.5)
var triangle = Polygon(corners: [
    CGPoint(x: 187.5, y: 427.25),
    CGPoint(x: 268.69, y: 286.635),
    CGPoint(x: 106.31, y: 286.635)])

var diagram = Diagram(elements: [circle, triangle])
diagram.draw(renderer: Renderer())


// 원래 존재하는 타입이 새롭게 준수하도록
extension CGContext: Renderer {
    func moveTo(_ p: CGPoint) {
        CGContextMoveToPoint(self, position.x, position.y)
    }
    
    func lineTo(_ p: CGPoint) {
        CGContextAddLineToPoint(self, position.x, position.y)
    }
    
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        let arc = CGPathCreateMutable()
        CGPathAddArc(arc, nil, c.x, c.y, radius, startAngle, endAngle, true)
        CGContextAddPath(self, arc)
    }
}

diagram.elements.append(diagram)
// 프로토콜을 더 많이 분리할 수록 모든 것을 더 테스트할 수 있다


//struct Bubble: Drawable {
//    func draw(renderer: Renderer) {
//        renderer.arcAt(center: center, radius: radius, startAngle: 0.0, endAngle: 2 * 3.14)
//    }
//}
// 이렇게 또 만드는 대신 프로토콜 extension을 활용
// 모든 타입이 요구사항을 준수하게 할 수 있음

extension Renderer {
    func circleAt(center: CGPoint, radius: CGFloat) {
        arcAt(center: center, radius: radius, startAngle: 0, endAngle: 2 * 3.14)
    }
    
    func rectangleAt(edges: CGRect) { }
}

let r: Renderer = TestRenderer()
r.circleAt(center: CGPoint(x: 0 , y: 0), radius: 1)
r.rectangleAt(edges: .init())
// 모든 것이 요구사항(required)일 필요는 없음


extension Drawable where Self: Equatable {
    func isEqualTo(other: Drawable) -> Bool {
        if let o = other as? Self { return self == o }
        return false
    }
}
