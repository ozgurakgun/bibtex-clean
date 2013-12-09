module Main where

import Data.Ord ( comparing )
import Data.List ( sortBy )

import Text.BibTeX.Entry
import Text.BibTeX.Parse ( file )
import Text.BibTeX.Format ( entry )

import Text.ParserCombinators.Parsec ( parse )


main :: IO ()
main = interact $ \ stdin ->
    case parse file "<stdin>" stdin of
        Left err -> error (show err)
        Right xs -> unlines
            $ map entry
            $ sortBy (comparing comp)
            $ map lowerCaseFieldNames xs

comp :: T -> (Maybe String, String, String, Maybe String)
comp x = (yearOf x, entryType x, identifier x, authorOf x)

yearOf :: T -> Maybe String
yearOf = lookup "year" . fields

authorOf :: T -> Maybe String
authorOf = lookup "author" . fields

