import Cocoa

//Continue here:
    //Add support for Selected state for items in FastList, when you spoof you should assert selectedness, probably store selectedness in dataprovider
        //Seems slower now
        //store selected index in another place than dataProvider, as setting and unsetting 1000's of times when you perform a click isnt good. 
        //Rather store the prevSelected and curSelected and only alter these values in the dp
    //test the FastList with rubberband
    //test the FastList with 1000's of items
class SliderFastList:FastList,ISliderList {
    var slider:VSlider?
    var sliderInterval:CGFloat?
    override func resolveSkin() {
        super.resolveSkin()
        sliderInterval = floor(ListParser.itemsHeight(self) - height)/itemHeight// :TODO: use ScrollBarUtils.interval instead?// :TODO: explain what this is in a comment
        slider = addSubView(VSlider(itemHeight,height,0,0,self))
        let thumbHeight:CGFloat = SliderParser.thumbSize(height/ListParser.itemsHeight(self), slider!.height)
        slider!.setThumbHeightValue(thumbHeight)//<--TODO: Rather set the thumbHeight on init?
    }
    override func scrollWheel(theEvent:NSEvent) {
        scroll(self,theEvent)//forward the event to the extension
        super.scrollWheel(theEvent)//forward the event other delegates higher up in the stack
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
