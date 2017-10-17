//
//  ViewController.swift
//  PieChartAnimation
//
//  Created by Siavash on 17/10/17.
//  Copyright © 2017 Nomble. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let frame = CGRect(x: 150, y: 150, width: 400, height: 400)
    var otherView = ACRCircleView(frame: CGRect(x: 40, y: 200, width: 300, height: 300))
    let chart = MCPieChartView.init(frame: CGRect(x: 40, y: 200, width: 310, height: 310))

    var animating = ACRCircleView(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
    var timer : Timer?
    var time : Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        chart.delegate = self
        chart.dataSource = self
        chart.isUserInteractionEnabled = false
        chart.tintColor = .clear
        chart.borderColor = .clear
//        chart.borderPercentage = 0.01
        chart.animationEnabled = false
        otherView.baseColor = #colorLiteral(red: 0.7475797534, green: 0.8137413859, blue: 0.9230439067, alpha: 1)
        otherView.tintColor = #colorLiteral(red: 0, green: 1, blue: 0.009308487177, alpha: 0.5)
        otherView.strokeWidth = otherView.bounds.width / 2
        view.addSubview(otherView)
        chart.selectedSliceColor = .blue
        chart.allowsMultipleSelection = true

        let middleCircle = UIView.init(frame: CGRect(x: 120, y: 120, width: 24, height: 24))
        middleCircle.backgroundColor = .red
        middleCircle.layer.cornerRadius = 12
        
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)

    }
    @objc func update() {
        time = time + 0.1
        if time >= 1.0 {
            otherView.progress = 1.0
//            chart.selectItem(at: 5)
            timer?.invalidate()
        } else {
            otherView.progress = CGFloat(time.truncatingRemainder(dividingBy: 1.0))
            
//            chart.selectItem(at: UInt((otherView.progress*3.0)))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController: MCPieChartViewDelegate, MCPieChartViewDataSource {
    func numberOfSlices(in pieChartView: MCPieChartView!) -> Int {
        return 5
    }
    
    func pieChartView(_ pieChartView: MCPieChartView!, valueForSliceAt index: Int) -> CGFloat {
        return 10
    }
    func pieChartView(_ pieChartView: MCPieChartView!, textForSliceAt index: Int) -> String! {
        return "YO"
    }
    func pieChartView(_ pieChartView: MCPieChartView!, didSelectSliceAt index: Int) {
        
    }
}

class ACRCircleView: UIView {
    
    // MARK: Configurable values
    var strokeWidth : CGFloat = 2.0 {
        didSet {
            basePathLayer.lineWidth = strokeWidth
            circlePathLayer.lineWidth = strokeWidth
        }
    }
    
    override var tintColor : UIColor! {
        didSet {
            circlePathLayer.strokeColor = tintColor.cgColor
        }
    }
    
    var baseColor : UIColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1) {
        didSet {
            basePathLayer.strokeColor = baseColor.cgColor
        }
    }
    
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if (newValue > 1.0) {
                circlePathLayer.strokeEnd = 1.0
            } else if (newValue < 0.0) {
                circlePathLayer.strokeEnd = 0.0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
    
    // MARK: Init
    private let basePathLayer = CAShapeLayer()
    private let circlePathLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configure()
    }
    
    func startAnimating() {
        var animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = 2 * M_PI
        // this might be too fast
        animation.duration = 1
        // HUGE_VALF is defined in math.h so import it
        animation.repeatCount = Float.infinity
        circlePathLayer.add(animation, forKey: "rotation")
    }
    
    func stopAnimating() {
        circlePathLayer.removeAnimation(forKey: "rotation")
    }
    
    // MARK: Internal
    private func configure() {
        
        basePathLayer.frame = bounds
        basePathLayer.lineWidth = strokeWidth
        basePathLayer.fillColor = UIColor.clear.cgColor
        basePathLayer.strokeColor = baseColor.cgColor
        basePathLayer.actions = ["strokeEnd": NSNull()]
        layer.addSublayer(basePathLayer)
        
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = strokeWidth
        circlePathLayer.fillColor = UIColor.clear.cgColor
        circlePathLayer.strokeColor = tintColor.cgColor
        // make optional for animated? See: http://stackoverflow.com/questions/21688363/change-cashapelayer-without-animation
        circlePathLayer.actions = ["strokeEnd": NSNull()]
        // rotate the layer negative 90deg to make it start at the top. 12 o'clock, default is 3 o'clock.
        circlePathLayer.transform = CATransform3DMakeRotation(-CGFloat(90.0 / 180.0 * M_PI), 0.0, 0.0, 1.0)
        layer.addSublayer(circlePathLayer)
        
        progress = 0
    }
    
    private func circleFrame() -> CGRect {
        // keep the circle inside the bounds
        let shorter = (bounds.width > bounds.height ? bounds.height : bounds.width) - strokeWidth
        var circleFrame = CGRect(x: 0, y: 0, width: shorter, height: shorter)
        circleFrame.origin.x = circlePathLayer.bounds.midX - circleFrame.midX
        circleFrame.origin.y = circlePathLayer.bounds.midY - circleFrame.midY
        return circleFrame
    }
    
    private func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        basePathLayer.frame = bounds
        basePathLayer.path = circlePath().cgPath
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().cgPath
    }
}

