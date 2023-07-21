open Expln_React_common

type size = [#small | #medium]

@module("./Expln_AutocompleteVirtualized.js") @react.component
external make: (
    ~value:option<string>,
    ~options: array<string>,
    ~onChange: option<string>=>unit,
    ~size:size=?,
    ~width:int=?,
    ~label:string,
) => reElem = "default"
