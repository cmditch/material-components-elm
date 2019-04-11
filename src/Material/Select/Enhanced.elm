module Material.Select.Enhanced exposing
    ( EnhancedSelectConfig
    , enhancedSelectConfig
    , filledEnhancedSelect
    , outlinedEnhancedSelect
    , selectItem
    , selectItemConfig
    )

import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Html.Events
import Json.Decode as Decode
import Material.List exposing (list, listConfig)


type alias EnhancedSelectConfig msg =
    { variant : Variant
    , label : String
    , disabled : Bool
    , additionalAttributes : List (Html.Attribute msg)
    , width : Maybe String
    }


enhancedSelectConfig : EnhancedSelectConfig msg
enhancedSelectConfig =
    { variant = Filled
    , label = ""
    , disabled = False
    , additionalAttributes = []
    , width = Nothing
    }


type Variant
    = Filled
    | Outlined


enhancedSelect : EnhancedSelectConfig msg -> List (Html msg) -> Html msg
enhancedSelect config nodes =
    Html.node "mdc-enhanced-select"
        (List.filterMap identity
            [ rootCs
            , variantCs config
            , disabledCs config
            ]
            ++ config.additionalAttributes
        )
        (List.concat
            [ [ hiddenInputElt
              , dropdownIconElt
              , selectedTextElt
              , menuElt nodes
              ]
            , if config.variant == Outlined then
                [ notchedOutlineElt config ]

              else
                [ floatingLabelElt config
                , lineRippleElt
                ]
            ]
        )


filledEnhancedSelect : String -> EnhancedSelectConfig msg -> List (Html msg) -> Html msg
filledEnhancedSelect id config nodes =
    enhancedSelect { config | variant = Filled } nodes


outlinedEnhancedSelect : String -> EnhancedSelectConfig msg -> List (Html msg) -> Html msg
outlinedEnhancedSelect id config nodes =
    enhancedSelect { config | variant = Outlined } nodes


type alias SelectItemConfig msg =
    { disabled : Bool
    , selected : Bool
    , activated : Bool
    , additionalAttributes : List (Html.Attribute msg)
    , onClick : Maybe msg
    }


selectItemConfig : SelectItemConfig msg
selectItemConfig =
    { disabled = False
    , selected = False
    , activated = False
    , additionalAttributes = []
    , onClick = Nothing
    }


selectItem : SelectItemConfig msg -> List (Html msg) -> Html msg
selectItem config nodes =
    Html.li
        (List.filterMap identity
            [ listItemCs
            , listItemDisabledCs config
            , listItemSelectedCs config
            , listItemActivatedCs config
            , listItemClickHandler config
            ]
            ++ config.additionalAttributes
        )
        nodes


rootCs : Maybe (Html.Attribute msg)
rootCs =
    Just (class "mdc-select")


variantCs : EnhancedSelectConfig msg -> Maybe (Html.Attribute msg)
variantCs { variant } =
    if variant == Outlined then
        Just (class "mdc-select--outlined")

    else
        Nothing


disabledCs : EnhancedSelectConfig msg -> Maybe (Html.Attribute msg)
disabledCs { disabled } =
    if disabled then
        Just (class "mdc-select--disabled")

    else
        Nothing


listItemCs : Maybe (Html.Attribute msg)
listItemCs =
    Just (class "mdc-list-item")


listItemDisabledCs : SelectItemConfig msg -> Maybe (Html.Attribute msg)
listItemDisabledCs { disabled } =
    if disabled then
        Just (class "mdc-list-item--disabled")

    else
        Nothing


listItemSelectedCs : SelectItemConfig msg -> Maybe (Html.Attribute msg)
listItemSelectedCs { selected } =
    if selected then
        Just (class "mdc-list-item--selected")

    else
        Nothing


listItemActivatedCs : SelectItemConfig msg -> Maybe (Html.Attribute msg)
listItemActivatedCs { activated } =
    if activated then
        Just (class "mdc-list-item--activated")

    else
        Nothing


listItemClickHandler : SelectItemConfig msg -> Maybe (Html.Attribute msg)
listItemClickHandler { onClick } =
    Maybe.map Html.Events.onClick onClick


hiddenInputElt : Html msg
hiddenInputElt =
    Html.input [ Html.Attributes.type_ "hidden" ] []


dropdownIconElt : Html msg
dropdownIconElt =
    Html.i [ class "mdc-select__dropdown-icon" ] []


selectedTextElt : Html msg
selectedTextElt =
    Html.div [ class "mdc-select__selected-text" ] []


menuElt : List (Html msg) -> Html msg
menuElt nodes =
    Html.div [ class "mdc-select__menu mdc-menu mdc-menu-surface" ] [ listElt nodes ]


listElt : List (Html msg) -> Html msg
listElt nodes =
    -- TODO: id?
    list "" listConfig nodes


floatingLabelElt : EnhancedSelectConfig msg -> Html msg
floatingLabelElt { label } =
    Html.label [ class "mdc-floating-label" ] [ text label ]


lineRippleElt : Html msg
lineRippleElt =
    Html.label [ class "mdc-line-ripple" ] []


notchedOutlineElt : EnhancedSelectConfig msg -> Html msg
notchedOutlineElt { label } =
    Html.div [ class "mdc-notched-outline" ]
        [ Html.div [ class "mdc-notched-outline__leading" ] []
        , Html.div [ class "mdc-notched-outline__notch" ]
            [ Html.label [ class "mdc-floating-label" ] [ text label ]
            ]
        , Html.div [ class "mdc-notched-outline__trailing" ] []
        ]
