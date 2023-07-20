type reCmp<'a> = React.component<'a>
type reElem = React.element
type reStyle = ReactDOM.Style.t

type reClipboardHnd = ReactEvent.Clipboard.t=>unit
type reCompositionHnd = ReactEvent.Composition.t=>unit
type reKeyboardHnd = ReactEvent.Keyboard.t=>unit
type reFocusHnd = ReactEvent.Focus.t=>unit
type reFormHnd = ReactEvent.Form.t=>unit
type reMouseHnd = ReactEvent.Mouse.t=>unit
type rePointerHnd = ReactEvent.Pointer.t=>unit
type reSelectionHnd = ReactEvent.Selection.t=>unit
type reTouchHnd = ReactEvent.Touch.t=>unit
type reUIHnd = ReactEvent.UI.t=>unit
type reWheelHnd = ReactEvent.Wheel.t=>unit
type reMediaHnd = ReactEvent.Media.t=>unit
type reImageHnd = ReactEvent.Image.t=>unit
type reAnimationHnd = ReactEvent.Animation.t=>unit
type reTransitionHnd = ReactEvent.Transition.t=>unit

let evt2str = strConsumer => evt => strConsumer(ReactEvent.Form.target(evt)["value"])
let evt2bool = boolConsumer => evt => boolConsumer(ReactEvent.Form.target(evt)["checked"])

external reElem2Obj: reElem => Js.Nullable.t<{..}> = "%identity"

@val external navigator: {..} = "navigator"

let copyToClipboard = (text:string):promise<unit> => {
    navigator["clipboard"]["writeText"](. text)
}

type mouseButton = Left | Middle | Right

type clickCallback = {
    btn:mouseButton,
    alt:bool,
    shift:bool,
    ctrl:bool,
    act:unit=>unit,
}

let mouseButtonToInt = (btn:mouseButton):int => {
    switch btn {
        | Left => 0
        | Middle => 1
        | Right => 2
    }
}

let clickClbkMake = (
    ~btn:mouseButton=Left,
    ~alt:bool=false,
    ~shift:bool=false,
    ~ctrl:bool=false,
    ~act:unit=>unit,
    ()
) => {
    { btn, alt, shift, ctrl, act, }
}

let clickHnd = (
    ~btn:mouseButton=Left,
    ~alt:bool=false,
    ~shift:bool=false,
    ~ctrl:bool=false,
    ~act:unit=>unit,
    ()
):(ReactEvent.Mouse.t => unit) => {
    evt => {
        if (
            evt->ReactEvent.Mouse.button === btn->mouseButtonToInt
            && evt->ReactEvent.Mouse.altKey === alt
            && evt->ReactEvent.Mouse.ctrlKey === ctrl
            && evt->ReactEvent.Mouse.shiftKey === shift
        ) {
            act()
        }
    }
}

let runClickCallback = (evt:ReactEvent.Mouse.t, clbk:clickCallback):unit => {
    if (
        evt->ReactEvent.Mouse.button === clbk.btn->mouseButtonToInt
        && evt->ReactEvent.Mouse.altKey === clbk.alt
        && evt->ReactEvent.Mouse.ctrlKey === clbk.ctrl
        && evt->ReactEvent.Mouse.shiftKey === clbk.shift
    ) {
        clbk.act()
    }
}

let clickHnd2 = ( clbk1:clickCallback, clbk2:clickCallback, ):(ReactEvent.Mouse.t => unit) => {
    evt => {
        runClickCallback(evt,clbk1)
        runClickCallback(evt,clbk2)
    }
}

let keyEnter = "Enter"
let keyEsc = "Escape"

type kbrdCallback = {
    key:string,
    alt:bool,
    shift:bool,
    ctrl:bool,
    act:unit=>unit,
}

let kbrdClbkMake = (
    ~key:string,
    ~alt:bool=false,
    ~shift:bool=false,
    ~ctrl:bool=false,
    ~act:unit=>unit,
    ()
) => {
    { key:key->Js_string2.toLowerCase, alt, shift, ctrl, act, }
}

let kbrdHnd = (
    ~key:string,
    ~alt:bool=false,
    ~shift:bool=false,
    ~ctrl:bool=false,
    ~act:unit=>unit,
    ()
):(ReactEvent.Keyboard.t => unit) => {
    let key = key->Js_string2.toLowerCase
    evt => {
        if (
            evt->ReactEvent.Keyboard.key->Js_string2.toLowerCase === key
            && evt->ReactEvent.Keyboard.altKey === alt
            && evt->ReactEvent.Keyboard.ctrlKey === ctrl
            && evt->ReactEvent.Keyboard.shiftKey === shift
        ) {
            act()
            evt->ReactEvent.Keyboard.stopPropagation
            evt->ReactEvent.Keyboard.preventDefault
        }
    }
}

let runKbrdCallback = (evt:ReactEvent.Keyboard.t, clbk:kbrdCallback):unit => {
    if (
        evt->ReactEvent.Keyboard.key->Js_string2.toLowerCase === clbk.key
        && evt->ReactEvent.Keyboard.altKey === clbk.alt
        && evt->ReactEvent.Keyboard.ctrlKey === clbk.ctrl
        && evt->ReactEvent.Keyboard.shiftKey === clbk.shift
    ) {
        clbk.act()
        evt->ReactEvent.Keyboard.stopPropagation
        evt->ReactEvent.Keyboard.preventDefault
    }
}

let kbrdHnd2 = ( clbk1:kbrdCallback, clbk2:kbrdCallback, ):(ReactEvent.Keyboard.t => unit) => {
    evt => {
        runKbrdCallback(evt,clbk1)
        runKbrdCallback(evt,clbk2)
    }
}

let kbrdHnd3 = ( clbk1:kbrdCallback, clbk2:kbrdCallback, clbk3:kbrdCallback, ):(ReactEvent.Keyboard.t => unit) => {
    evt => {
        runKbrdCallback(evt,clbk1)
        runKbrdCallback(evt,clbk2)
        runKbrdCallback(evt,clbk3)
    }
}
