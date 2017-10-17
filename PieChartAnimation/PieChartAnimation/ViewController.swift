//
//  ViewController.swift
//  PieChartAnimation
//
//  Created by Siavash on 17/10/17.
//  Copyright © 2017 Nomble. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var timer : Timer?
    var time : Double = 0
    let animatedChart = ACRCircleView()
    lazy var middleCircle: UIView = {
       let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 12
        return v
    }()
    lazy var line1: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var line2: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var line3: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var line4: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var line5: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    private let kLineSize: CGSize = CGSize(width: 2, height: 100)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        animatedChart.baseColor = #colorLiteral(red: 0.7475797534, green: 0.8137413859, blue: 0.9230439067, alpha: 1)
        animatedChart.tintColor = #colorLiteral(red: 0, green: 1, blue: 0.009308487177, alpha: 0.5)
        animatedChart.strokeWidth = 100
        view.addSubview(animatedChart)
        animatedChart.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)

        view.addSubview(middleCircle)
        middleCircle.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        view.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.bottom.equalTo(middleCircle.snp.top)
            make.size.equalTo(kLineSize)
            make.centerX.equalTo(middleCircle)
        }

        line2.transform = CGAffineTransform(rotationAngle: CGFloat(Float(72).degreesToRadians))
        view.addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.size.equalTo(kLineSize)
            make.centerX.equalTo(middleCircle).offset(48)
            make.centerY.equalTo(middleCircle).offset(-16)
            
        }
        
        line3.transform = CGAffineTransform(rotationAngle: CGFloat(Float(144).degreesToRadians))
        view.addSubview(line3)
        line3.snp.makeConstraints { (make) in
            make.size.equalTo(kLineSize)
            make.centerX.equalTo(middleCircle).offset(36)
            make.centerY.equalTo(middleCircle).offset(48)
            
        }
        line4.transform = CGAffineTransform(rotationAngle: CGFloat(Float(216).degreesToRadians))
        view.addSubview(line4)
        line4.snp.makeConstraints { (make) in
            make.size.equalTo(kLineSize)
            make.centerX.equalTo(middleCircle).offset(-30)
            make.centerY.equalTo(middleCircle).offset(43)
            
        }
        
        line5.transform = CGAffineTransform(rotationAngle: CGFloat(Float(288).degreesToRadians))
        view.addSubview(line5)
        line5.snp.makeConstraints { (make) in
            make.size.equalTo(kLineSize)
            make.centerX.equalTo(middleCircle).offset(-48)
            make.centerY.equalTo(middleCircle).offset(-18)
            
        }
    }
    @objc func update() {
        time = time + 0.1
        if time >= 1.0 {
            animatedChart.progress = 1.0
            timer?.invalidate()
        } else {
            animatedChart.progress = CGFloat(time.truncatingRemainder(dividingBy: 1.0))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = 2 * Double.pi
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
        circlePathLayer.transform = CATransform3DMakeRotation(-CGFloat(90.0 / 180.0 * Double.pi), 0.0, 0.0, 1.0)
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
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
