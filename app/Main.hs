--
-- EPITECH PROJECT, 2021
-- B-FUN-400-RUN-4-1-compressor-romain.grondin
-- File description:
-- Main
--

import System.Environment ( getArgs )
import Lib ( setConf )
import Data.Maybe ( isNothing )
import Text.Read ( readMaybe)
import System.Exit ( exitSuccess, exitWith, ExitCode(ExitFailure) )
import MyData
    ( Flag(help, errorMessage, file, nb_color, convergence),
      Color(color),
      Pixel(position, colors),
      Pos(pos) )
import ParseFile ( parseFile )
import System.Random (newStdGen)
import Kmean ( getRandomPoint, initClusters, kmean )

returnError :: Flag -> IO ()
returnError flag
        | help flag = putStr (usage ++ n ++ l ++ f) >> exitSuccess
        | errorMessage flag /= "" = printError >> exitWith(ExitFailure 84)
        | otherwise = pure ()
        where
                printError =  print (errorMessage flag)
                usage = "USAGE: ./imageCompressor -n N -l L -f F\n\n"
                n = "\tN\tnumber of colors in the final image\n"
                l = "\tL\tconvergence limit\n\t"
                f = "F\tpath to the file containing the colors of the pixels\n"


displayColors :: (Int, Int, Int) -> IO ()
displayColors (re, gr, bl) = putStr ("(" ++ r ++ "," ++ g ++ "," ++ b ++ ")")
    where
        r = show re
        g = show gr
        b = show bl

displayPos :: (Int, Int) -> IO ()
displayPos (x, y) = putStr ("(" ++ show x ++ "," ++ show y ++ ")")


displayPixels :: [Pixel] -> IO ()
displayPixels [] = pure ()
displayPixels (x:xs) = xy >> putChar ' ' >> co >> putChar '\n' >> recurse
    where
        xy = displayPos (pos (position x))
        co = displayColors (color (colors x))
        recurse = displayPixels xs



displayRes :: [(Color, [Pixel])] -> IO ()
displayRes [] = pure ()
displayRes ((cluster, pixel):xs) = start >> clr >> after>> pxl >> recurse
    where
        start = putStr "--\n"
        clr = displayColors (color cluster)
        after = putStr "\n-\n"
        pxl = displayPixels pixel
        recurse = displayRes xs

main :: IO ()
main = do
        arg <- getArgs
        let flag = setConf arg
        returnError flag
        fileContent <- readFile (file flag)
        let pixels = parseFile (lines fileContent)
        g <- newStdGen
        let cluster = getRandomPoint g (nb_color flag) pixels []
        let test = kmean (convergence flag) pixels (initClusters cluster pixels)
        displayRes test
