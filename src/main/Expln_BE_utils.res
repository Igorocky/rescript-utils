open Expln_utils_jsonParse
open Expln_utils_promise

@val external fetch: (string,'a) => Js_promise.t<{..}> = "fetch"

let beRespGenericErr = -1
let beRespParseErr = -2
let beRespNoDataErr = -3

let parseBeResp = (respStr:string, dataMapper:jsonAny=>'a): result<'a,(int,string)> => {
    let parsed = parseJson(respStr, d => {
        (
            d->objOpt("data", dataMapper, ()),
            d->objOpt("err", d=>{
                (d->int("code", ()), d->str("msg", ()))
            }, ()),
        )
    }, ())

    switch parsed {
        | Error(msg) => {
            Js_console.error(`An error occured during parse of the BE response: parse error is '${msg}', ` ++
                `BE response is '${respStr}'`)
            Error((beRespParseErr,msg))
        }
        | Ok((dataOpt,errOpt)) => {
            switch errOpt {
                | Some((code,msg)) => Error((code,msg))
                | None => {
                    switch dataOpt {
                        | None => {
                            Js_console.error(`BE response doesn't contain neither 'data' nor 'err': ${respStr}`)
                            Error((beRespNoDataErr,`BE response doesn't contain neither 'data' nor 'err'.`))
                        }
                        | Some(data) => Ok(data)
                    }
                }
            }
        }
    }
}

type beFunc<'req,'resp> = 'req => promise<result<'resp,(int,string)>>

let createBeFunc = (url:string, respMapper:jsonAny => 'resp): beFunc<'req,'resp> => {
    req => {
        fetch(url, {
            "method": "POST",
            "headers": {
                "Content-Type": "application/json;charset=UTF-8"
            },
            "body": Js.Json.stringifyAny(req)
        }) 
            ->promiseFlatMap(res => res["text"](.))
            ->promiseMap(text => parseBeResp(text,respMapper))
    }
}
