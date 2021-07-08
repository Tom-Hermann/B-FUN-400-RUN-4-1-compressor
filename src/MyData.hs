--
-- EPITECH PROJECT, 2021
-- B-FUN-400-RUN-4-1-compressor-romain.grondin
-- File description:
-- MyData
--

module MyData (
    Flag (..),
    Pixel(..),
    Color(..),
    Pos(..)
) where

data Flag = Flag {
        file :: String,
        nb_color :: Int ,
        convergence :: Float,
        errorMessage :: String,
        help :: Bool
} deriving (Eq, Show)

newtype Pos = Pos { pos :: (Int, Int) } deriving (Eq, Show)

newtype Color = Color { color :: (Int, Int, Int) } deriving (Eq, Show)

data Pixel = Pixel {
    position :: Pos,
    colors :: Color
} deriving (Eq, Show)