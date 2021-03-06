module Misc exposing
    ( Error(..)
    , InternalError(..)
    , Package
    , PackageSolved
    , PackageStateSolved(..)
    , PackageStateUnsolved(..)
    , errorToStr
    , internalErrorTag
    , internalErrorToStr
    , isDirect
    )

import Version exposing (Version, VersionId)



-- TYPES - PACKAGE


{-|

  - `initialState`
      - State of the package in parsed elm.json.

-}
type alias Package =
    { state : PackageStateUnsolved
    , selectedVersion : Version
    , initialState :
        Maybe
            { state : PackageStateSolved
            , version : Version
            }
    }


type PackageStateUnsolved
    = DirectNormal_
    | DirectTest_
    | IndirectOrNotNeeded


{-| TODO WIP

  - state
      - `Nothing` means NotNeeded

-}
type alias PackageSolved =
    { state : Maybe PackageStateSolved
    , selectedVersion : Version
    , initialState :
        Maybe
            { state : PackageStateSolved
            , version : Version
            }
    }


type PackageStateSolved
    = DirectNormal
    | DirectTest
    | IndirectNormal
    | IndirectTest



-- FUNCTIONS - PACKAGE


isDirect : Package -> Bool
isDirect package =
    case package.state of
        DirectNormal_ ->
            True

        DirectTest_ ->
            True

        IndirectOrNotNeeded ->
            False



-- TYPES - ERROR


type Error
    = FetchingFailedWithName String
    | FetchingFailedWithId VersionId
    | InternalError InternalError


{-| These errors should never happen and always indicate some internal error in code.

  - Error might not be internal to the module in question, but can also be error in caller.
  - First parameter is unique random number, to uniquely identify each possible error location.

-}
type InternalError
    = NameNotFetched Int String
    | NameNotFound Int String
    | NameExistsAlready Int String
    | IdNotFetched Int VersionId
    | IdNotFound Int VersionId
    | IdExistsAlready Int VersionId
    | OtherInternalError Int String



-- FUNCTIONS - ERROR


errorToStr : Error -> String
errorToStr error =
    case error of
        FetchingFailedWithName name ->
            "ERROR: Failed to fetch " ++ name

        FetchingFailedWithId id ->
            "ERROR: Failed to fetch " ++ Version.idToStr id

        InternalError internalError ->
            internalErrorToStr internalError


internalErrorTag : InternalError -> Int
internalErrorTag internalError =
    case internalError of
        NameNotFetched tag _ ->
            tag

        NameNotFound tag _ ->
            tag

        NameExistsAlready tag _ ->
            tag

        IdNotFetched tag _ ->
            tag

        IdNotFound tag _ ->
            tag

        IdExistsAlready tag _ ->
            tag

        OtherInternalError tag _ ->
            tag


internalErrorToStr : InternalError -> String
internalErrorToStr internalError =
    "INTERNAL ERROR: "
        ++ (case internalError of
                NameNotFetched tag name ->
                    "Name " ++ name ++ " hasn't been fetched (" ++ String.fromInt tag ++ ")"

                NameNotFound tag name ->
                    "Name " ++ name ++ " not found (" ++ String.fromInt tag ++ ")"

                NameExistsAlready tag name ->
                    "Name " ++ name ++ " exists already (" ++ String.fromInt tag ++ ")"

                IdNotFetched tag id ->
                    "VersionId " ++ Version.idToStr id ++ " hasn't been fetched (" ++ String.fromInt tag ++ ")"

                IdNotFound tag id ->
                    "VersionId " ++ Version.idToStr id ++ " not found (" ++ String.fromInt tag ++ ")"

                IdExistsAlready tag id ->
                    "VersionId " ++ Version.idToStr id ++ " exist already (" ++ String.fromInt tag ++ ")"

                OtherInternalError tag message ->
                    message ++ " (" ++ String.fromInt tag ++ ")"
           )
