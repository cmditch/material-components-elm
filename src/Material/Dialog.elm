module Material.Dialog exposing (DialogConfig, DialogContent, dialog, dialogConfig)

import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Html.Events
import Json.Decode as Decode


type alias DialogConfig msg =
    { open : Bool
    , additionalAttributes : List (Html.Attribute msg)
    , onClose : Maybe msg
    }


dialogConfig : DialogConfig msg
dialogConfig =
    { open = False
    , additionalAttributes = []
    , onClose = Nothing
    }


type alias DialogContent msg =
    { title : Maybe String
    , content : List (Html msg)
    , actions : List (Html msg)
    }


dialog : String -> DialogConfig msg -> DialogContent msg -> Html msg
dialog id config content =
    Html.node "mdc-dialog"
        (List.filterMap identity
            [ rootCs
            , openAttr config
            , roleAttr
            , ariaModalAttr
            , closeHandler config
            ]
        )
        [ containerElt content
        , scrimElt
        ]


rootCs : Maybe (Html.Attribute msg)
rootCs =
    Just (class "mdc-dialog")


openAttr : DialogConfig msg -> Maybe (Html.Attribute msg)
openAttr { open } =
    if open then
        Just (Html.Attributes.attribute "open" "")

    else
        Nothing


roleAttr : Maybe (Html.Attribute msg)
roleAttr =
    Just (Html.Attributes.attribute "role" "alertdialog")


ariaModalAttr : Maybe (Html.Attribute msg)
ariaModalAttr =
    Just (Html.Attributes.attribute "aria-modal" "true")


closeHandler : DialogConfig msg -> Maybe (Html.Attribute msg)
closeHandler { onClose } =
    Maybe.map (Html.Events.on "MDCDialog:close" << Decode.succeed) onClose


containerElt : DialogContent msg -> Html msg
containerElt content =
    Html.div [ class "mdc-dialog__container" ] [ surfaceElt content ]


surfaceElt : DialogContent msg -> Html msg
surfaceElt content =
    Html.div
        [ class "mdc-dialog__surface" ]
        (List.filterMap identity
            [ titleElt content
            , contentElt content
            , actionsElt content
            ]
        )


titleElt : DialogContent msg -> Maybe (Html msg)
titleElt { title } =
    case title of
        Just title_ ->
            Just (Html.div [ class "mdc-dialog__title" ] [ text title_ ])

        Nothing ->
            Nothing


contentElt : DialogContent msg -> Maybe (Html msg)
contentElt { content } =
    Just (Html.div [ class "mdc-dialog__content" ] content)


actionsElt : DialogContent msg -> Maybe (Html msg)
actionsElt { actions } =
    if List.isEmpty actions then
        Nothing

    else
        Just (Html.div [ class "mdc-dialog__actions" ] actions)


scrimElt : Html msg
scrimElt =
    Html.div [ class "mdc-dialog__scrim" ] []
