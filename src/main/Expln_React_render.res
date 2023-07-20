open Expln_React_Modal
open Expln_React_Mui
open Expln_utils_promise

let rndProgress = (~text:string, ~pct:option<float>=?, ~onTerminate:option<unit=>unit>=?, ()) => {
    <Paper style=ReactDOM.Style.make(~padding=onTerminate->Belt.Option.map(_=>"5px")->Belt.Option.getWithDefault("10px"), ())>
        <Row alignItems=#center spacing=1.>
            <span style=ReactDOM.Style.make(~paddingLeft="10px", ())>
                {
                    switch pct {
                        | Some(pct) => `${text}: ${(pct *. 100.)->Js.Math.round->Belt.Float.toInt->Belt_Int.toString}%`
                        | None => text
                    }->React.string
                }
            </span>
            {
                switch onTerminate {
                    | None => React.null
                    | Some(onTerminate) => {
                        <IconButton onClick={_ => onTerminate()}>
                            <Icons.CancelOutlined/>
                        </IconButton>
                    }
                }
            }
        </Row>
    </Paper>
}

let rndInfoDialog = (~text:string, ~onOk:unit=>unit, ~title:option<string>=?, ()) => {
    <Paper style=ReactDOM.Style.make(~padding="10px", ())>
        <Col spacing=1.>
            <span 
                style=ReactDOM.Style.make(
                    ~fontWeight="bold", 
                    ~display=?{if (title->Belt_Option.isNone) {Some("none")} else {None}}, 
                    ()
                )
            >
                {title->Belt_Option.getWithDefault("")->React.string}
            </span>
            <span>
                {text->React.string}
            </span>
            <Button onClick={_=>onOk()} variant=#contained >
                {React.string("Ok")}
            </Button>
        </Col>
    </Paper>
}

let openInfoDialog = (~modalRef:modalRef, ~text:string, ~onOk:option<unit=>unit>=?, ~title:option<string>=?, ()) => {
    openModal(modalRef, _ => React.null)->promiseMap(modalId => {
        updateModal(modalRef, modalId, () => {
            rndInfoDialog(
                ~text, 
                ~onOk = () => {
                    closeModal(modalRef, modalId)
                    onOk->Belt_Option.forEach(clbk => clbk())
                },
                ~title?,
                ()
            )
        })
    })->ignore
}

let hndRespErr = (resp:promise<result<'resp,(int,string)>>, modalRef:modalRef):promise<'resp> => {
    resp->promiseMap(resp => {
        switch resp {
            | Error((code,msg)) => {
                openInfoDialog(~modalRef, ~text=`Error ${code->Belt.Int.toString}: ${msg}`, ~title="BE Error", ())
                Expln_utils_common.exn(msg)
            }
            | Ok(data) => data
        }
    })
}

