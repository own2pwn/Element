import Cocoa

class GraphicModifier {
    /**
     * TODO: Fill and linestyle should be graphic spessific see original code
     */
    static func applyProperties(inout decoratable:IGraphicDecoratable,_ fillStyle:IFillStyle,_ lineStyle:ILineStyle?,_ offsetType:OffsetType)->IGraphicDecoratable {
        decoratable.graphic.fillStyle = fillStyle
        decoratable.graphic.lineStyle = lineStyle
        decoratable.graphic.lineOffsetType = offsetType
        return decoratable
    }
}