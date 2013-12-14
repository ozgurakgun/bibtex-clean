module Main where

import Data.Ord ( comparing )
import Data.List ( nub, sortBy )

import Text.BibTeX.Entry
import Text.BibTeX.Parse ( file )
import Text.BibTeX.Format ( entry )

import Text.ParserCombinators.Parsec ( parse )

import Data.String.Utils ( replace )


main :: IO ()
main = interact $ \ stdin ->
    case parse file "<stdin>" (fixStdin stdin) of
        Left err -> error (show err)
        Right xs -> xs
            |> map lowerCaseFieldNames
            |> sortBy (comparing comp)
            |> map entry
            |> nub
            |> unlines


(|>) :: a -> (a -> b) -> b
(|>) = flip ($)


comp :: T -> (Maybe String, String, Maybe String, String)
comp x = (fieldOf "year" x, entryType x, fieldOf "title" x, identifier x)

fieldOf :: String -> T -> Maybe String
fieldOf f = lookup f . fields


fixStdin :: String -> String
fixStdin = replace "@inproc.{" "@inproceedings{"
         . replace "@InProc.{" "@inproceedings{"
