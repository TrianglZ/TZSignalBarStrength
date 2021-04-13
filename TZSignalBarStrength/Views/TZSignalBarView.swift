//
//  SignalBarView.swift
//  SignalBarStrength
//
//  Created by Rana Hossam on 07/04/2021.
//

import UIKit

public class TZSignalBarView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var firstBar: FillView!
    @IBOutlet weak var secondBar: FillView!
    @IBOutlet weak var thirdBar: FillView!
    @IBOutlet weak var fourthBar: FillView!
    @IBOutlet weak var fifthBar: FillView!
    @IBOutlet weak var firstContainer: UIView!
    @IBOutlet weak var secondContainer: UIView!
    @IBOutlet weak var thirdContainer: UIView!
    @IBOutlet weak var fourthContainer: UIView!
    @IBOutlet weak var fifthContainer: UIView!
    
    // MARK: - Variables
    private var fullColor: UIColor = .white
    private var mediumColor: UIColor = .white
    private var lowColor: UIColor = .white
    private var barColor = UIColor.clear
    private var signalStrength: Int = 3
    private var didAnimate = false
    private var duration: Double = 2 {
        didSet {
            if canAnimate && firstBar != nil {
                //                updateBarColors()
                //                updateBars()
                animateViews()
            }
        }
    }
    private var canAnimate = true
    
    // MARK: - Inspectables
    @IBInspectable public var fullStrengthColor: UIColor {
        get {
            firstBar.backgroundColor ?? .white
        }
        set {
            fullColor = newValue
            let views = [firstBar, secondBar, thirdBar, fourthBar, fifthBar]
            views.forEach {
                $0?.backgroundColor = newValue
            }
        }
    }
    
    @IBInspectable public var mediumStrengthColor: UIColor {
        get {
            firstBar.backgroundColor ?? .white
        }
        set {
            mediumColor = newValue
            let views = [firstBar, secondBar, thirdBar, fourthBar, fifthBar]
            views.forEach {
                $0?.backgroundColor = newValue
            }
        }
    }
    
    @IBInspectable public var lowStrengthColor: UIColor {
        get {
            firstBar.backgroundColor ?? .white
        }
        set {
            lowColor = newValue
            let views = [firstBar, secondBar, thirdBar, fourthBar, fifthBar]
            views.forEach {
                $0?.backgroundColor = newValue
            }
        }
    }
    
    @IBInspectable public var barCornerRadius: CGFloat {
        get {
            firstBar.layer.cornerRadius
        }
        set {
            let views = [firstBar, secondBar, thirdBar, fourthBar, fifthBar]
            views.forEach {
                $0?.layer.masksToBounds = true
                $0?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                $0?.layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
            }
        }
    }
    
    @IBInspectable public var barBorderColor: UIColor? {
        get {
            guard let color = firstBar.layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                firstBar.layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            let views = [firstBar, secondBar, thirdBar, fourthBar, fifthBar]
            views.forEach {
                $0?.layer.borderColor = newValue?.cgColor
            }
        }
    }
    
    @IBInspectable public var barBorderWidth: CGFloat {
        get {
            firstBar.layer.borderWidth
        }
        set {
            let views = [firstBar, secondBar, thirdBar, fourthBar, fifthBar]
            views.forEach {
                $0?.layer.borderWidth = newValue
            }
        }
    }
    
    @IBInspectable public var strength: Int {
        get {
            self.signalStrength
        }
        set {
            self.signalStrength = newValue
            self.barColor = getColor()
            updateBarColors()
            updateBars()
        }
    }
    
    @IBInspectable public var barSpacing: CGFloat {
        get {
            stackView.spacing
        }
        set {
            stackView.spacing = newValue
        }
    }
    
    @IBInspectable public var animationDuration: Double {
        get {
            duration
        }
        set {
            duration = newValue
        }
    }
    
    @IBInspectable public var allowAnimation: Bool {
        get {
            canAnimate
        }
        set {
            canAnimate = newValue
        }
    }
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// loads nib and adjusts its constraints.
    func commonInit() {
        if let mainBundle = Bundle(identifier: "com.trianglz.TZSignalBarStrength") {
            mainBundle.loadNibNamed("TZSignalBarView", owner: self, options: nil)
            contentView.fixInView(self)
        }
        updateBarColors()
        updateBars()
    }
    
    /// method that updates bars fll color according to the corressponsing strength color
    private func updateBarColors() {
        let views = [firstBar, secondBar, thirdBar, fourthBar, fifthBar]
        views.forEach {
            $0?.backgroundColor = barColor
        }
    }
    
    /// method that returns bars fill color according to the  strngth of the signal
    /// - Returns: corressponding strength color
    private func getColor() -> UIColor {
        if signalStrength >= 4 {
            return fullColor
        } else if signalStrength >= 2 {
            return mediumColor
        } else {
            return lowColor
        }
    }
    
    /// method that updates bars visibility according to the signal strength
    /// 1 -> only 1 bar is visible
    /// 2 -> 2 bars are visible ... etc
    private func updateBars() {
        updateVisibility(for: [firstContainer, secondContainer, thirdContainer, fourthContainer, fifthContainer], isHidden: true)
        if signalStrength == 1 {
            updateVisibility(for: [firstContainer], isHidden: false)
        } else if signalStrength == 2 {
            updateVisibility(for: [firstContainer, secondContainer], isHidden: false)
        } else if signalStrength == 3 {
            updateVisibility(for: [firstContainer, secondContainer, thirdContainer], isHidden: false)
        }  else if signalStrength == 4 {
            updateVisibility(for: [firstContainer, secondContainer, thirdContainer, fourthContainer], isHidden: false)
        } else {
            updateVisibility(for: [firstContainer, secondContainer, thirdContainer, fourthContainer, fifthContainer], isHidden: false)
        }
    }
    
    /// changes the singal bars' visibility
    /// - Parameter views: required views to update
    /// - Parameter isHidden: bool describing wether or not the bars should be hidden
    private func updateVisibility(for views: [UIView], isHidden: Bool) {
        views.forEach {
            $0.isHidden = isHidden
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    /// a method that adds a `fill` animation layer for each signal bar
    private func animateViews() {
        guard canAnimate && !didAnimate else { return }
        didAnimate = true
        let views = [firstBar, secondBar, thirdBar, fourthBar, fifthBar]
        views.enumerated().forEach { index, item in
            item?.animate(with: self.duration, radius: self.barCornerRadius, and: getColor())
        }
    }
}
