import Foundation

class Decoratable:IDecoratable{
    var decoratable:IDecoratable
    init(_ decoratable:IDecoratable){
        self.decoratable = decoratable;
    }
    func initialize(){
        fill()
    }
    func fill(){
        decoratable.fill();
    }
    /*
     * Forces a redraw of the graphics
     */
    func clear(){
        decoratable.clear();
    }
    func line(){
        decoratable.line();
    }
    func drawFill() {
        decoratable.drawFill();
    }
    func drawLine() {
        decoratable.drawLine();
    }
    func beginFill() {// :TODO: rename to applyFill? its more consistent with applyLine
        decoratable.beginFill();
    }
    func applyLineStyle(graphics:Graphics,_ lineStyle:ILineStyle) {// :TODO: rename to applyLine?
        fatalError("NOT IMPLEMENTED YET")
        //decoratable.applyLineStyle(self,lineStyle);
    }
    /**
     * Returns _decoratable.graphic
     * @Note: we use decoratable.graphic to get to the graphics object, regardless of how many layers of decorators above.
     */
    func getShape()-> Shape {
        return decoratable.getShape();
    }
}