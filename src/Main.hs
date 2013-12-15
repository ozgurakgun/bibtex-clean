module Main where

import Data.Char ( toLower )
import Data.Ord ( comparing )
import Data.List ( nub, sort, sortBy, group )
import Control.Arrow ( (&&&) )
import Control.Monad ( unless )
import qualified System.IO as S ( hPutStrLn, stderr )
import qualified System.Exit as S ( exitFailure )

import Text.BibTeX.Entry
import Text.BibTeX.Parse ( file )
import Text.BibTeX.Format ( entry )

import Text.ParserCombinators.Parsec ( parse )

import Data.String.Utils ( replace )


main :: IO ()
main = do
    stdin <- getContents
    case parse file "<stdin>" (fixStdin stdin) of
        Left err -> die (show err)
        Right xs -> do
            let
                stdout = xs
                    |> map lowerCaseFieldNames
                    |> map lowerCaseEntryType
                    |> sortBy (comparing comp)
                    |> map entry
                    |> nub
                    |> unlines
                duplicates = xs
                    |> map identifier
                    |> histogram
                    |> filter (\ (_,n) -> n > 1 )
                stderr = unlines
                    $ "Warning: Duplicate citation keys."
                    : map (\ (k,n) -> show n ++ "\t" ++ k ) duplicates

            putStrLn stdout
            unless (null duplicates) (die stderr)


(|>) :: a -> (a -> b) -> b
(|>) = flip ($)

histogram :: Ord a => [a] -> [(a,Int)]
histogram = map (head &&& length) . group . sort

comp :: T -> (Maybe String, String, Maybe String, String)
comp x = (fieldOf "year" x, entryType x, fieldOf "title" x, identifier x)

fieldOf :: String -> T -> Maybe String
fieldOf f = lookup f . fields

lowerCaseEntryType :: T -> T
lowerCaseEntryType t = t { entryType = map toLower (entryType t) }


fixStdin :: String -> String
fixStdin = replace "@inproc.{" "@inproceedings{"
         . replace "@InProc.{" "@inproceedings{"

die :: String -> IO ()
die err = S.hPutStrLn S.stderr err >> S.exitFailure

