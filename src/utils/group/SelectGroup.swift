import Cocoa
/**
 * NOTE: this class also works great with RadioBullets
 * NOTE: Remember to add the selectGroup instance to the view so that the event works correctly // :TODO: this is a bug try to fix it
 * NOTE: Use the SelectGroupModifier and SelectGroupParser for Modifing and parsing the SelectGroup
 * TODO: You could add a SelectGroupExtension class that adds Modifing and parsing methods to the SelectGroup instance!
 * EXAMPLE: (IMPORTANT: We use the EventLib instead now)
 * let radioButtonGroup = RadioButtonGroup([rb1,rb2, rb3]);
 * NSNotificationCenter.defaultCenter().addObserver(radioButtonGroup, selector: "onSelect:", name: SelectGroupEvent.select, object: radioButtonGroup)
 * func onSelect(sender: AnyObject) { Swift.print("Event: " + ((sender as! NSNotification).object as ISelectable).isSelected}
 */
class SelectGroup:EventSender{
    var selectables:Array<ISelectable> = []
    var selected:ISelectable?
    init(_ selectables:Array<ISelectable>, _ selected:ISelectable? = nil){
        super.init()
        self.selected = selected
        addSelectables(selectables)
    }
    func addSelectables(selectables:Array<ISelectable>){
        selectables.forEach{addSelectable($0)}
    }
    /**
     * @Note use a weak ref so that we dont have to remove the event if the selectable is removed from the SelectGroup or view
     */
    func addSelectable(selectable:ISelectable) {
        if(selectable is IEventSender){ (selectable as! IEventSender).event = onEvent }
        selectables.append(selectable)
    }
    override func onEvent(event:Event){
        if(event.type == SelectEvent.select){
            self.event!(SelectGroupEvent(SelectGroupEvent.select,selected,self/*,self*/))
            selected = event.immediate as? ISelectable
            SelectModifier.unSelectAllExcept(selected!, selectables)
            //for s in selectables{ Swift.print("s.isSelected: " + "\(s.getSelected())") }
            super.onEvent(SelectGroupEvent(SelectGroupEvent.change,selected,self/*,self*/))
        }
        super.onEvent(event)//we don't want to block any event being passed through, so we forward all events right through the SelectGroup
    }
}