--
-- EPITECH PROJECT, 2021
-- B-FUN-400-RUN-4-1-compressor-romain.grondin
-- File description:
-- Lib
--

module Lib
    ( setFlag,
    setConf
    ) where

import MyData ( Flag(..) )
import Data.Maybe ( isNothing )
import Text.Read ( readMaybe )
import System.Exit ( exitWith, ExitCode(ExitFailure) )

setFlag :: [String] -> Flag
setFlag [] = Flag "" (-1) (-1) "" False
setFlag ("-n":x:xs)
        | isNothing rmaybe  = (setFlag xs) {errorMessage =  "None valid value"}
        | otherwise = (setFlag xs) {nb_color = read x :: Int}
        where
                rmaybe = readMaybe x :: Maybe Float
setFlag ("-l":x:xs)
        | isNothing rmaybe  = (setFlag xs) {errorMessage =  "None valid value"}
        | otherwise = (setFlag xs) {convergence = read x :: Float}
        where
                rmaybe = readMaybe x :: Maybe Float
setFlag ("-f":x:xs) = (setFlag xs) {file = x}
setFlag ("-h":x:xs) = (setFlag xs) {help = True}
setFlag [x] =  Flag "" (-1) (-1) "" True
setFlag (x:xs) = (setFlag xs) {errorMessage = "Unknow flag"}

setConf :: [String] -> Flag
setConf [] = Flag "" (-1) (-1) "" True
setConf x
        | l == -1 = (setFlag x) {errorMessage =  "l flag must be set"}
        | n == -1 = (setFlag x) {errorMessage =  "n flag must be set"}
        | f == "" = (setFlag x) {errorMessage =  "f flag must be set"}
        | otherwise = setFlag x
        where
                l = convergence (setFlag x)
                n = nb_color (setFlag x)
                f = file (setFlag x)