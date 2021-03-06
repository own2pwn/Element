import Cocoa

class RBSliderFastList:FastList,IRBSliderList{
    /*RubberBand*/
    var mover:RubberBand?
    var prevScrollingDeltaY:CGFloat = 0/*this is needed in order to figure out which direction the scrollWheel is going in*/
    var velocities:Array<CGFloat> = [0,0,0,0,0,0,0,0,0,0]/*represents the velocity resolution of the gesture movment*/
    var progressValue:CGFloat?//<--same as progress but unclamped (because RBSliderList may go beyond 0 to 1 values etc)
    /*Slider*/
    var slider:VSlider?
    private var sliderInterval:CGFloat?
    override func resolveSkin() {
        super.resolveSkin()
        /*RubberBand*/
        let frame = CGRect(0,0,width,height)/*represents the visible part of the content //TODO: could be ranmed to maskRect*/
        let itemsRect = CGRect(0,0,width,ListParser.itemsHeight(self))/*represents the total size of the content //TODO: could be ranmed to contentRect*/
        mover = RubberBand(Animation.sharedInstance,setProgress,frame,itemsRect)
        mover!.event = onEvent/*Add an eventHandler for the mover object, avoids logging missing eventHandler, this has no functionality in this class, but may have in classes that extends this class*/
        /*slider*/
        sliderInterval = floor(ListParser.itemsHeight(self) - height)/itemHeight// :TODO: use ScrollBarUtils.interval instead?// :TODO: explain what this is in a comment
        slider = addSubView(VSlider(itemHeight,height,0,0,self))
        let thumbHeight:CGFloat = SliderParser.thumbSize(height/ListParser.itemsHeight(self), slider!.height)
        slider!.setThumbHeightValue(thumbHeight)
        setProgress(0)/*<-not really needed, but nice to have while debugging*/
    }
    /**
     * PARAM value: is the final y value for the lableContainer
     */
    override func setProgress(value:CGFloat){
        //TODO: Use a precalculated itemsHeight instead of recalculating it on every setProgress call
        progressValue = value / -(ListParser.itemsHeight(self) - height)/*get the the scalar values from value.*/
        super.setProgress(progressValue!)
        slider!.setProgressValue(progressValue!)
    }
    /**
     * NOTE: this method overides the Native NSView scrollWheel method
     */
    override func scrollWheel(theEvent:NSEvent) {
        scroll(theEvent)//forward the event to the scrollExtension
        if(theEvent.phase == NSEventPhase.Changed){setProgress(mover!.result)}/*direct manipulation*/
        super.scrollWheel(theEvent)/*keep forwarding the scrollWheel event for NSViews higher up the hierarcy to listen to*/
    }
    /**
     * EventHandler for the Slider change event
     */
    func onSliderChange(sliderEvent:SliderEvent){
        ListModifier.scrollTo(self,sliderEvent.progress)
        mover!.value = lableContainer!.frame.y
    }
    func scrollWheelEnter(){//2. spring to refreshStatePosition
        //Swift.print("RBSliderFastList.scrollWheelEnter()" + "\(progressValue)")
        slider!.thumb!.fadeIn()
    }
    func scrollWheelExit(){
        //Swift.print("RBSliderFastList.scrollWheelExit()")
    }
    func scrollWheelExitedAndIsStationary(){
        //Swift.print("RBSliderFastList.scrollWheelExitedAndIsStationary() ")
        if(slider?.thumb?.getSkinState() == SkinStates.none){
            slider?.thumb?.fadeOut()
        }
    }
    func scrollAnimStopped(){
        //Swift.print("RBSliderList.scrollAnimStopped()")
        slider!.thumb!.fadeOut()
    }
    override func onEvent(event:Event) {
        if(event.assert(SliderEvent.change,slider)){
            onSliderChange(event.cast())
        }else if(event.assert(AnimEvent.stopped, mover!)){
            scrollAnimStopped()
        }
        super.onEvent(event)
    }
}
