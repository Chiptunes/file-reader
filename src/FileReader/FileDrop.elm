module FileReader.FileDrop exposing (..)

{-| Drag and Drop support

@docs dzAttrs
@docs onDragEnter
@docs onDragLeave
@docs onDragOver
@docs onDropFiles
@docs stopProp
@docs preventDef
@docs onStopPropagation
@docs onPreventDefault

-}

import FileReader exposing (NativeFile, parseDroppedFiles)
import Html exposing (Attribute)
import Html.Events exposing (Options, onWithOptions)
import Json.Decode as Json


{-| Event binder
-}
dzAttrs : msg -> msg -> msg -> (List NativeFile -> msg) -> List (Attribute msg)
dzAttrs dragEnter dragLeave dragOverMsg dropMsg =
    [ onDragEnter dragEnter
    , onDragLeave dragLeave
    , onDragOver dragOverMsg -- Needed for drop to work - should generally be passed NoOp
    , onDropFiles dropMsg
    ]



--


{-| Sends msg when the onDragEnter event is triggered
-}
onDragEnter : msg -> Attribute msg
onDragEnter msgCreator =
    onPreventDefault "dragenter" msgCreator


{-| Sends msg when the onDragLeave event is triggered
-}
onDragLeave : msg -> Attribute msg
onDragLeave msgCreator =
    onPreventDefault "dragleave" msgCreator


{-| Sends msg when the onDragOver event is triggered
-}
onDragOver : msg -> Attribute msg
onDragOver =
    onPreventDefault "dragover"



-- onDrop : msg -> Attribute msg
-- onDrop msgCreator =
--     onPreventDefault "drop" msgCreator


{-| Sends msg when the onDropFiles event is triggered
-}
onDropFiles : (List NativeFile -> msg) -> Attribute msg
onDropFiles msgCreator =
    onWithOptions "drop" stopProp <|
        Json.map msgCreator parseDroppedFiles



-- Helpers


{-| Stops event propagation
-}
stopProp : Options
stopProp =
    { stopPropagation = False, preventDefault = True }


{-| Sets preventDefault to true
-}
preventDef : Options
preventDef =
    { stopPropagation = False, preventDefault = True }


{-| Sends msg when the onStopPropagation event is triggered
-}
onStopPropagation : String -> a -> Attribute a
onStopPropagation evt msgCreator =
    onWithOptions evt stopProp <|
        Json.succeed msgCreator


{-| Sends msg when the onPreventDefault event is triggered
-}
onPreventDefault : String -> a -> Attribute a
onPreventDefault evt msgCreator =
    onWithOptions evt preventDef <|
        Json.succeed msgCreator
