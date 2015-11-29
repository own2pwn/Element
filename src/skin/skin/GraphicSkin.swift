import Foundation


class GraphicSkin:Skin{
    override init(_ style:IStyle? = nil, _ state:String = "", _ element:IElement? = nil){
        super.init(style, state, element)
        decoratable = GraphicSkinParser.configure(self)/*this call is here because CGContext is only accessible after drawRect is called*/
    }
    override func drawRect(dirtyRect: NSRect) {
        Swift.print("GraphicSkin.drawRect()")
        decoratable.initialize()//runs trough all the different calls and makes the graphic in one go. (optimization)
    }
    /**
     * Required by super class
     */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(){
        
        
        //continue here, you need to figure out how to apply the new style to the current decoratable, look at the old code
        //you need to assert which decoratable it has etc

        
        //Swift.print("GraphicSkin.draw() NOT IMPLEMENTED YET")
        if(hasStateChanged || hasSizeChanged || hasStyleChanged){
            applyProperties(&decoratable);
        }
        super.draw();
        
    }
    func applyProperties(inout decoratable:IGraphicDecoratable){
        //Swift.print("GraphicSkin.applyProperties() NOT IMPLEMENTED YET")
        GraphicModifier.applyProperties(&decoratable, StylePropertyParser.fillStyle(self), StylePropertyParser.lineStyle(self), StylePropertyParser.lineOffsetType(self));/*color or gradient*/
    }
}