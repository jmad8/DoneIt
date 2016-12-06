import UIKit

let π:CGFloat = CGFloat(M_PI)

@IBDesignable class GoalProgressControl: UIView {
    private var _progressCount : Int = 0
    private var _totalCount: Int = 10
    private var _progressStrokeWidth: CGFloat = 3.0
    private var _progressStrokeColor: UIColor = UIColor.themeA()
    private var _progressFillColor: UIColor = UIColor.themeE()
    private var _circleColor: UIColor = UIColor.themeA()
    private var _arcWidth: CGFloat?
    
    @IBInspectable var progressCount: Int {
        get {
            return _progressCount
        }
        set {
            if newValue > totalCount {
                _progressCount = totalCount
            } else if newValue < 0 {
                _progressCount = 0
            } else {
                _progressCount = newValue
            }
        }
    }
    
    @IBInspectable var totalCount: Int {
        get {
            return _totalCount
        }
        set {
            _totalCount = newValue
        }
    }
    
    @IBInspectable var progressStrokeWidth: CGFloat {
        get {
            return _progressStrokeWidth
        }
        set {
            if newValue > arcWidth/2 {
                _progressStrokeWidth = arcWidth/2
            } else if newValue < 0 {
                _progressStrokeWidth = 0
            } else {
                _progressStrokeWidth = newValue
            }
        }
    }
    
    @IBInspectable var progressStrokeColor: UIColor {
        get {
            return _progressStrokeColor
        }
        set {
            _progressStrokeColor = newValue
        }
    }
    
    @IBInspectable var progressFillColor: UIColor {
        get {
            return _progressFillColor
        }
        set {
            _progressFillColor = newValue
        }
    }
    
    @IBInspectable var circleColor: UIColor {
        get {
            return _circleColor
        }
        set {
            _circleColor = newValue
        }
    }
    
    @IBInspectable var arcWidth: CGFloat {
        get {
            return _arcWidth ?? min(bounds.width, bounds.height)/4
        }
        set {
            _arcWidth = newValue
        }
    }
    
    private let BackgroundCircleName : String = "backgroundCircle"
    private let BeginningPointName : String = "beginningPoint"
    private let EndingPointName : String = "endingPoint"
    private let OuterOutlineName : String = "outerOutline"
    private let InnerOutlineName : String = "innerOutline"
    private let ProgressCircleName : String = "progressCircle"
    
    private var BackgroundCircleLayer: CAShapeLayer? {
        get {
            return getSublayerByName(sublayerName: BackgroundCircleName)
        }
    }
    
    private var BeginningPointLayer: CAShapeLayer? {
        get {
            return getSublayerByName(sublayerName: BeginningPointName)
        }
    }
    
    private var EndingPointLayer: CAShapeLayer? {
        get {
            return getSublayerByName(sublayerName: EndingPointName)
        }
    }
    
    private var OuterOutlineLayer: CAShapeLayer? {
        get {
            return getSublayerByName(sublayerName: OuterOutlineName)
        }
    }
    
    private var InnerOutlineLayer: CAShapeLayer? {
        get {
            return getSublayerByName(sublayerName: InnerOutlineName)
        }
    }
    
    private var ProgressCircleLayer: CAShapeLayer? {
        get {
            return getSublayerByName(sublayerName: ProgressCircleName)
        }
    }
    
    private func getSublayerByName(sublayerName: String) -> CAShapeLayer? {
        if let sublayers = layer.sublayers {
            let subsublayers = sublayers.filter({ (sublayer: CALayer) -> Bool in
                return sublayer.name == sublayerName
            })
            
            if subsublayers.count > 0 {
                return subsublayers[0] as? CAShapeLayer
            }
        }
        return nil
    }
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = min(bounds.width, bounds.height)/2
        
        //Draw background circle
        let backgroundCircle = UIBezierPath(arcCenter: center,
                                            radius: radius - arcWidth/2,
                                            startAngle: 0,
                                            endAngle: 2*π,
                                            clockwise: true)
        
        let circleLayer = CAShapeLayer()
        circleLayer.name = BackgroundCircleName
        circleLayer.path = backgroundCircle.cgPath
        circleLayer.strokeColor = circleColor.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = arcWidth
        layer.addSublayer(circleLayer)
        
        let startAngle: CGFloat = 3 * π / 2
        let outlineEndAngle = GetOutlineEndAngle()
        
        //        //Draw beginning circle
        //        let beginningCenter = CGPoint(x: center.x, y: center.y - radius + arcWidth/2)
        //        let beginningPoint = UIBezierPath(arcCenter: beginningCenter, radius: arcWidth/2 - progressStrokeWidth/2, startAngle: 0, endAngle: 2*π, clockwise: true).cgPath
        //
        //        let beginningPointLayer = CAShapeLayer()
        //        beginningPointLayer.name = BeginningPointName
        //        beginningPointLayer.path = beginningPoint
        //        beginningPointLayer.strokeColor = progressStrokeColor.cgColor
        //        beginningPointLayer.fillColor = progressFillColor.cgColor
        //        beginningPointLayer.lineWidth = progressStrokeWidth
        //        layer.addSublayer(beginningPointLayer)
        //
        //        //Draw ending circle
        //        let endingCenter = getEndingPointRect()
        //        let endingPoint = UIBezierPath(arcCenter: endingCenter, radius: arcWidth/2 - progressStrokeWidth/2, startAngle: 0, endAngle: 2*π, clockwise: true).cgPath
        //
        //        let endingPointLayer = CAShapeLayer()
        //        endingPointLayer.name = EndingPointName
        //        endingPointLayer.path = endingPoint
        //        endingPointLayer.strokeColor = progressStrokeColor.cgColor
        //        endingPointLayer.fillColor = progressFillColor.cgColor
        //        endingPointLayer.lineWidth = progressStrokeWidth
        //        layer.addSublayer(endingPointLayer)
        
        
        //Draw progress circle
        let progressCircle = UIBezierPath(arcCenter: center,
                                          radius: radius - arcWidth/2,
                                          startAngle: startAngle + 0.000000000001,
                                          endAngle: startAngle,
                                          clockwise: true).cgPath
        
        let progressCircleLayer = CAShapeLayer()
        progressCircleLayer.name = ProgressCircleName
        progressCircleLayer.path = progressCircle
        progressCircleLayer.strokeColor = progressFillColor.cgColor
        progressCircleLayer.fillColor = UIColor.clear.cgColor
        progressCircleLayer.lineWidth = arcWidth - progressStrokeWidth*2
        progressCircleLayer.strokeStart = 0.0
        progressCircleLayer.strokeEnd = outlineEndAngle / (2 * π)
        layer.addSublayer(progressCircleLayer)
        
        
        //        //Draw outer outline
        //        let outerOutline = UIBezierPath(arcCenter: center,
        //                                       radius: radius - progressStrokeWidth/2,
        //                                       startAngle: startAngle + 0.000000000001,
        //                                       endAngle: startAngle,
        //                                       clockwise: true).cgPath
        //
        //        let outerOutlineLayer = CAShapeLayer()
        //        outerOutlineLayer.name = OuterOutlineName
        //        outerOutlineLayer.path = outerOutline
        //        outerOutlineLayer.strokeColor = progressStrokeColor.cgColor
        //        outerOutlineLayer.fillColor = UIColor.clear().cgColor
        //        outerOutlineLayer.lineWidth = progressStrokeWidth
        //        outerOutlineLayer.strokeStart = 0.0
        //        outerOutlineLayer.strokeEnd = outlineEndAngle / (2 * π)
        //        layer.addSublayer(outerOutlineLayer)
        //
        //        let innerOutline = UIBezierPath(arcCenter: center,
        //                                       radius: radius - arcWidth + (progressStrokeWidth/2),
        //                                       startAngle: startAngle + 0.000000000001,
        //                                       endAngle: startAngle,
        //                                       clockwise: true).cgPath
        //
        //        let innerOutlineLayer = CAShapeLayer()
        //        innerOutlineLayer.name = InnerOutlineName
        //        innerOutlineLayer.path = innerOutline
        //        innerOutlineLayer.strokeColor = progressStrokeColor.cgColor
        //        innerOutlineLayer.fillColor = UIColor.clear().cgColor
        //        innerOutlineLayer.lineWidth = progressStrokeWidth
        //        innerOutlineLayer.strokeStart = 0.0
        //        innerOutlineLayer.strokeEnd = outlineEndAngle / (2 * π)
        //        layer.addSublayer(innerOutlineLayer)
    }
    
    private func GetOutlineEndAngle() -> CGFloat {
        return 2 * π / CGFloat(totalCount) * CGFloat(progressCount)
    }
    
    func moveProgress(progressIncrement: Int, animate: Bool){
        //        let oldProgressCount = progressCount
        progressCount += progressIncrement
        
        if progressCount < 0 {
            progressCount = 0
        }
        
        if let layer = ProgressCircleLayer {
            if animate {
                //                layer.removeAllAnimations()
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.fromValue = layer.strokeEnd
                //                (2 * π / totalCount * CGFloat(oldProgressCount)) / (2 * π)
                layer.strokeEnd = GetOutlineEndAngle() / (2 * π)
                animation.toValue = layer.strokeEnd
                animation.duration = 0.5
                animation.repeatCount = 1
                animation.fillMode = kCAFillModeForwards
                //                animation.isRemovedOnCompletion = false
                animation.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
                //                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                
                layer.add(animation, forKey: animation.keyPath)
            } else {
                layer.strokeEnd = GetOutlineEndAngle() / (2 * π)
                layer.displayIfNeeded()
            }
        }
        
        
        //        if (animate) {
        //            UIView.animate(withDuration: 5, animations: move)
        //        }
    }
    
    func getEndingPointRect() -> CGPoint {
        let radius: CGFloat = min(bounds.width, bounds.height)/2
        let val = GetOutlineEndAngle() + π/2
        let s = sin(val) * (radius - arcWidth/2)
        let c = cos(val) * (radius - arcWidth/2)
        
        let endingCenter = CGPoint(x: bounds.width/2 - c, y: bounds.height/2 - s)
        return endingCenter
    }
    
    private func move() {
        //        self.alpha = self.alpha * 0
        let strokeEnd = GetOutlineEndAngle() / (2 * π)
        ProgressCircleLayer?.strokeEnd = strokeEnd
        //        OuterOutlineLayer?.strokeEnd = strokeEnd
        //        InnerOutlineLayer?.strokeEnd = strokeEnd
        //        let point = getEndingPointRect()
        //        EndingPointLayer?.bounds = CGRect(x: point.x, y: point.y, width: EndingPointLayer!.bounds.size.width, height: EndingPointLayer!.bounds.size.height)
        
    }
}
