import Cocoa

class SliderFastList:FastList,ISliderList {
    var slider:VSlider?
    var sliderInterval:CGFloat?
    override func resolveSkin() {
        super.resolveSkin()
        sliderInterval = floor(ListParser.itemsHeight(self) - height)/itemHeight// :TODO: use SliderParser.interval instead?// :TODO: explain what this is in a comment
        slider = addSubView(VSlider(itemHeight,height,0,0,self))
        let thumbHeight:CGFloat = SliderParser.thumbSize(height/ListParser.itemsHeight(self), slider!.height)
        slider!.setThumbHeightValue(thumbHeight)//<--TODO: Rather set the thumbHeight on init?
    }
    override func scrollWheel(event:NSEvent) {
        scroll(event)/*forwards the event to the extension method*/
        super.scrollWheel(event)/*forwards the event other delegates higher up in the stack*/
    }
    func onSliderChange(sliderEvent:SliderEvent){/*Handler for the SliderEvent.change*/
        ListModifier.scrollTo(self,sliderEvent.progress)
    }
    override func onEvent(event:Event) {
        if(event.assert(SliderEvent.change, slider)){onSliderChange(event.cast())}/*events from the slider*/
        super.onEvent(event)
    }
    /**
     * TODO: This must be implemented in the future, see SliderList for instructions
     */
    override func setSize(width:CGFloat, _ height:CGFloat) {
        super.setSize(width, height)
    }
}
