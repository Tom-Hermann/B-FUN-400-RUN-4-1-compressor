--
-- EPITECH PROJECT, 2021
-- B-FUN-400-RUN-4-1-compressor-romain.grondin
-- File description:
-- ParseFile
--

module ParseFile
    (
    parseFile,
    ) where

import MyData(Flag(..), Pixel(..), Pos(..), Color(..))
import Text.Read (read)

indexOf :: Char -> [Char] -> [Int]
indexOf x = map fst . filter (\(_,s) -> s==x) . zip [0..]

parseFile :: [String] -> [Pixel]
parseFile [] = []
parseFile (line:xs) = Pixel (Pos (x, y)) (Color (r, g, b)) : parseFile xs
    where
        x = read (take (head (indexOf ',' line) - fp)  (drop fp line)) :: Int
        fp = head (indexOf '(' line ) + 1
        y = read (take (head (indexOf ')' line) - sp)  (drop sp line)) :: Int
        sp = head (indexOf ',' line ) + 1
        r = read (take (indexOf ',' line !! 1 - tp)  (drop tp line)) :: Int
        tp = indexOf '(' line !! 1 + 1
        g = read (take (indexOf ',' line !! 2 - fop)  (drop fop line)) :: Int
        fop = indexOf ',' line !! 1 + 1
        b = read (take (indexOf ')' line !! 1 - fip)  (drop fip line)) :: Int
        fip = indexOf ',' line !! 2 + 1
