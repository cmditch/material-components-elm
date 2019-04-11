module Material.Chip.Choice exposing (ChoiceChipConfig, choiceChip, choiceChipConfig)

import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Html.Events
import Json.Decode as Decode


type alias ChoiceChipConfig msg =
    { selected : Bool
    , additionalAttributes : List (Html.Attribute msg)
    , onClick : Maybe msg
    }


choiceChipConfig : ChoiceChipConfig msg
choiceChipConfig =
    { selected = False
    , additionalAttributes = []
    , onClick = Nothing
    }


choiceChip : String -> ChoiceChipConfig msg -> String -> Html msg
choiceChip id config label =
    Html.node "mdc-chip"
        (List.filterMap identity
            [ rootCs

            -- , selectedCs config
            , selectedAttr config
            , clickHandler config
            ]
            ++ config.additionalAttributes
        )
        [ textElt label ]


rootCs : Maybe (Html.Attribute msg)
rootCs =
    Just (class "mdc-chip")


selectedCs : ChoiceChipConfig msg -> Maybe (Html.Attribute msg)
selectedCs { selected } =
    if selected then
        Just (class "mdc-chip--selected")

    else
        Nothing


selectedAttr : ChoiceChipConfig msg -> Maybe (Html.Attribute msg)
selectedAttr { selected } =
    if selected then
        Just (Html.Attributes.attribute "selected" "")

    else
        Nothing


clickHandler : ChoiceChipConfig msg -> Maybe (Html.Attribute msg)
clickHandler config =
    Maybe.map (Html.Events.on "MDCChip:interaction" << Decode.succeed) config.onClick


textElt : String -> Html msg
textElt label =
    Html.div [ class "mdc-chip__text" ] [ text label ]
