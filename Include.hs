#!/usr/bin/env runhaskell
import Text.Pandoc.JSON
import Text.Pandoc.Walk (walkM)
import Control.Monad ((>=>))

doInclude :: Block -> IO Block
doInclude cb@(CodeBlock ("verbatim", classes, namevals) contents) =
  case lookup "include" namevals of
       Just f     -> return . (\x -> Para [Math DisplayMath x]) =<< readFile f
       Nothing    -> return cb
doInclude cb@(CodeBlock (id, classes, namevals) contents) =
  case lookup "include" namevals of
       Just f     -> return . (CodeBlock (id, classes, namevals)) =<< readFile f
       Nothing    -> return cb
doInclude x = return x

wordpressify :: Inline -> Inline
wordpressify (Math x y) = Math x ("LaTeX " ++ y)
wordpressify x = x

myFilter :: Pandoc -> IO Pandoc
myFilter = walkM (return . wordpressify) >=> walkM doInclude

main :: IO ()
main = toJSONFilter myFilter
