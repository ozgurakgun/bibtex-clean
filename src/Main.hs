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
        Right xs -> unlines
            $ nub
            $ map entry
            $ sortBy (comparing comp)
            $ map lowerCaseFieldNames xs

comp :: T -> (Maybe String, String, Maybe String, String)
comp x = (fieldOf "year" x, entryType x, fieldOf "title" x, identifier x)

fieldOf :: String -> T -> Maybe String
fieldOf f = lookup f . fields


fixStdin :: String -> String
fixStdin = replace "@inproc.{" "@inproceedings{"
