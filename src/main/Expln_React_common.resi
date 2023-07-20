type reCmp<'a> = React.component<'a>
type reElem = React.element
type reStyle = ReactDOM.Style.t
type reClipboardHnd = ReactEvent.Clipboard.t => unit
type reCompositionHnd = ReactEvent.Composition.t => unit
type reKeyboardHnd = ReactEvent.Keyboard.t => unit
type reFocusHnd = ReactEvent.Focus.t => unit
type reFormHnd = ReactEvent.Form.t => unit
type reMouseHnd = ReactEvent.Mouse.t => unit
type rePointerHnd = ReactEvent.Pointer.t => unit
type reSelectionHnd = ReactEvent.Selection.t => unit
type reTouchHnd = ReactEvent.Touch.t => unit
type reUIHnd = ReactEvent.UI.t => unit
type reWheelHnd = ReactEvent.Wheel.t => unit
type reMediaHnd = ReactEvent.Media.t => unit
type reImageHnd = ReactEvent.Image.t => unit
type reAnimationHnd = ReactEvent.Animation.t => unit
type reTransitionHnd = ReactEvent.Transition.t => unit
let evt2str: ('a => 'b, ReactEvent.Form.t) => 'b
let evt2bool: ('a => 'b, ReactEvent.Form.t) => 'b
external reElem2Obj: reElem => Js.Nullable.t<{..}> = "%identity"

let copyToClipboard: string => promise<unit>
let getAvailWidth: () => int

type mouseButton = Left | Middle | Right
type clickCallback

let clickClbkMake: (
    ~btn:mouseButton=?,
    ~alt:bool=?,
    ~shift:bool=?,
    ~ctrl:bool=?,
    ~act:unit=>unit,
    ()
) => clickCallback

let clickHnd: (
    ~btn:mouseButton=?,
    ~alt:bool=?,
    ~shift:bool=?,
    ~ctrl:bool=?,
    ~act:unit=>unit,
    ()
) => (ReactEvent.Mouse.t => unit)

let clickHnd2: ( clickCallback, clickCallback, ) => (ReactEvent.Mouse.t => unit)

let keyEnter: string
let keyEsc: string

type kbrdCallback

let kbrdClbkMake: (
    ~key:string,
    ~alt:bool=?,
    ~shift:bool=?,
    ~ctrl:bool=?,
    ~act:unit=>unit,
    ()
) => kbrdCallback

let kbrdHnd: (
    ~key:string,
    ~alt:bool=?,
    ~shift:bool=?,
    ~ctrl:bool=?,
    ~act:unit=>unit,
    ()
) => (ReactEvent.Keyboard.t => unit)

let kbrdHnd2: ( kbrdCallback, kbrdCallback ) => (ReactEvent.Keyboard.t => unit)
let kbrdHnd3: ( kbrdCallback, kbrdCallback, kbrdCallback ) => (ReactEvent.Keyboard.t => unit)
