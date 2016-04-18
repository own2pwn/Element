import Foundation

class PathGraphic:SizeableDecorator{
    var path:IPath
    init(_ path:IPath, _ decoratable: IGraphicDecoratable = BaseGraphic(nil,LineStyle())) {
        self.path = path
        
        super.init(decoratable)
    }
    override func drawFill() {
        let cgPath = DisplayPathUtils.compile(CGPathCreateMutable(), path)
        let boundingBox:CGRect = CGPathGetPathBoundingBox(cgPath)/*there is also CGPathGetPathBoundingBox, CGPathGetBoundingBox, which works a bit different, the difference is probably just support for cruves etc*/
        /*fill*/

            graphic.fillShape.frame = boundingBox
            let offset = CGPoint(-boundingBox.x,-boundingBox.y)
            var offsetPath = path.copy()
            fillShape.path = CGPathModifier.translate(&offsetPath, offset.x, offset.y)
        
    }
    override func drawLine() {
        let boundingBox:CGRect = PathParser.boundingBox(graphic.fillShape.path, graphic.lineStyle!)/*regardless if the line is inside outside or centered, this will still work, as the path is already exapnded correctly*/
        graphic.lineShape.frame = boundingBox
        let offset = CGPoint(-boundingBox.x,-boundingBox.y)
        var offsetPath = graphic.fillShape.path.copy()
        graphic.lineShape.path = CGPathModifier.translate(&offsetPath, offset.x, offset.y)
        
    }
}