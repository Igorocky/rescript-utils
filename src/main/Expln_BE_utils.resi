open Expln_utils_jsonParse

let beRespGenericErr:int
let beRespParseErr:int
let beRespNoDataErr:int

type beFunc<'req,'resp> = 'req => promise<result<'resp,(int,string)>>

let createBeFunc: (string, jsonAny => 'resp) => beFunc<'req,'resp>
