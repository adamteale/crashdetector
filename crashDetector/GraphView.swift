import UIKit

@IBDesignable class GraphView: UIView {
    
    
    //1 - the properties for the gradient
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    

    //Array of UserAccelerationEntry entries
    var graphPoints:[UserAccelerationEntry] = []
    
    
    var xaxisEntries : [Double] = []
    var yaxisEntries : [Double] = []
    var zaxisEntries : [Double] = []
    

    override func drawRect(rect: CGRect) {
        generateGraph(rect, userAccelerationEntryX: self.xaxisEntries, userAccelerationEntryY: self.yaxisEntries, userAccelerationEntryZ: self.zaxisEntries)
    }
    
    
    func generateGraph(rect: CGRect, userAccelerationEntryX: [Double], userAccelerationEntryY: [Double], userAccelerationEntryZ: [Double]){
        
        let width = rect.width
        let height = rect.height
        
        //set up background clipping area
        let path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSize(width: 8.0, height: 8.0))

        path.addClip()
        
        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        
        //6 - draw the gradient
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context,
            gradient,
            startPoint,
            endPoint,
            CGGradientDrawingOptions(
            ))
        
        
        let margin:CGFloat = 20.0
        
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        
        let columnXPoint = { (column:Int) -> CGFloat in
            print("Hola X")
            //Calculate gap between points
            var spacer = CGFloat(0.0)
            
            if userAccelerationEntryX.count > 1{
                spacer = (width - margin*2 - 4) / CGFloat((userAccelerationEntryX.count - 1))
            }else{
                spacer = (width - margin*2 - 4)
            }

            var x : CGFloat = CGFloat(column) * spacer
            x += margin + 2

            return x
        }
        

        func setupAxis(pointsArray: [Double], strokeColour: UIColor){
            var maxValue = 0.0
            
            for aUserAccelerationEntry in pointsArray{
                if aUserAccelerationEntry > maxValue{
                    maxValue = aUserAccelerationEntry
                }
            }
            
            let columnYPoint = { (graphPoint:Int) -> CGFloat in
                var y : CGFloat
                if graphPoint <= 0{
                    y = 0
                }else{
                    y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
                }
                y = graphHeight + topBorder - y // Flip the graph
                return y
            }
            
            // draw the line graph
            
            strokeColour.setStroke()
            strokeColour.setFill()
            
            if pointsArray.count > 0{
                
                //set up the points line
                let graphPath = UIBezierPath()

                //go to start of line
//                graphPath.moveToPoint(CGPoint(x:columnXPoint(0), y:columnYPoint(Int(pointsArray[0]))))
                
                graphPath.moveToPoint(CGPoint(x:columnXPoint(0), y:columnYPoint(Int(pointsArray[0]))))

                //add points for each item in the pointsArray array
                //at the correct (x, y) for the point
                for i in 1..<pointsArray.count {
                    let nextPoint = CGPoint(x:columnXPoint(i), y:columnYPoint(Int(pointsArray[i])))
                    graphPath.addLineToPoint(nextPoint)
                }
                
                //Create the clipping path for the graph gradient
                
                //1 - save the state of the context (commented out for now)
                CGContextSaveGState(context)
                
//                //2 - make a copy of the path
//                let clippingPath = graphPath.copy() as! UIBezierPath
//                
//                //3 - add lines to the copied path to complete the clip area
//                clippingPath.addLineToPoint(CGPoint(
//                    x: columnXPoint(pointsArray.count - 1),
//                    y:height))
//                clippingPath.addLineToPoint(CGPoint(
//                    x:columnXPoint(0),
//                    y:height))
//                clippingPath.closePath()
//                
//                //4 - add the clipping path to the context
//                clippingPath.addClip()
//                
//                let highestYPoint = columnYPoint(Int(maxValue))
//                startPoint = CGPoint(x:margin, y: highestYPoint)
//                endPoint = CGPoint(x:margin, y:self.bounds.height)
//                
//                CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions())
                
                CGContextRestoreGState(context)
                
                graphPath.lineWidth = 2.0
                graphPath.stroke()
                
                //Draw the circles on top of graph stroke
                for i in 0..<pointsArray.count {
                    var point = CGPoint(x:columnXPoint(i), y:columnYPoint(Int(pointsArray[i])))
                    point.x -= 5.0/2
                    point.y -= 5.0/2
                    
                    let circle = UIBezierPath(ovalInRect:CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
                    circle.fill()
                }
            }
        }

        
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        
        
        setupAxis(xaxisEntries, strokeColour:UIColor.redColor())
        setupAxis(yaxisEntries, strokeColour:UIColor.yellowColor())
        setupAxis(zaxisEntries, strokeColour:UIColor.blueColor())
        
        
        
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
        linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y:topBorder))
        
        //center line
        linePath.moveToPoint(CGPoint(x:margin, y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin, y:graphHeight/2 + topBorder))
        
        //bottom line
        linePath.moveToPoint(CGPoint(x:margin, y:height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin, y:height - bottomBorder))
        
        //Colour lines
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
            
        
    }
    
    
    
//    func addDataToGraphPoints(dataObj:[UserAccelerationEntry]){

    func addDataToGraphPoints(
        userAccelerationEntryX: [Double],
        userAccelerationEntryY: [Double],
        userAccelerationEntryZ: [Double],
        maxX: Double,
        maxY: Double,
        maxZ: Double){
            
        self.xaxisEntries = userAccelerationEntryX
        self.yaxisEntries = userAccelerationEntryY
        self.zaxisEntries = userAccelerationEntryZ
        
        self.setNeedsDisplay()
    
    }
    
    
    
}