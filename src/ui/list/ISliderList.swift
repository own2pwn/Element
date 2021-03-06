import Cocoa

protocol ISliderList:IList {
    var slider:VSlider?{get}
    var sliderInterval:CGFloat?{get}
    func setProgress(progress:CGFloat)
}
extension ISliderList{
    /**
     * NOTE: Slider list and SliderFastList uses this method
     */
    func scroll(theEvent:NSEvent) {
        let progress:CGFloat = Utils.progress(theEvent.deltaY, self.sliderInterval!, self.slider!.progress)
        setProgress(progress) /*Sets the target item to correct y, according to the current scrollBar progress*/
        self.slider?.setProgressValue(progress)/*positions the slider.thumb*/
        if(theEvent.momentumPhase == NSEventPhase.Ended){self.slider!.thumb!.setSkinState("inActive")}
        else if(theEvent.momentumPhase == NSEventPhase.Began){self.slider!.thumb!.setSkinState(SkinStates.none)}//include may begin here
    }
}
private class Utils{
    /**
     * Returns the progress og the sliderList (used when we scroll with the scrollwheel/touchpad)
     */
    static func progress(deltaY:CGFloat,_ sliderInterval:CGFloat,_ sliderProgress:CGFloat)->CGFloat{
        let scrollAmount:CGFloat = (deltaY/30)/sliderInterval/*_scrollBar.interval*/
        var currentScroll:CGFloat = sliderProgress - scrollAmount/*the minus sign makes sure the scroll works like in OSX LION*/
        currentScroll = NumberParser.minMax(currentScroll, 0, 1)/*clamps the num between 0 and 1*/
        return currentScroll
    }
}