open Expln_React_Modal
open Expln_React_common

let rndProgress: (~text:string, ~pct:float=?, ~onTerminate:unit=>unit=?, ()) => reElem

let openInfoDialog: (
    ~modalRef: Expln_React_Modal.modalRef,
    ~text: string,
    ~onOk: unit => unit =?,
    ~title:string=?,
    unit,
) => unit

let hndRespErr: (promise<result<'resp,(int,string)>>, modalRef) => promise<'resp>

