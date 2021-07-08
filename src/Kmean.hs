--
-- EPITECH PROJECT, 2021
-- B-FUN-400-RUN-4-1-compressor-romain.grondin
-- File description:
-- Kmean
--

module Kmean (
    kmean,
    initClusters,
    getRandomPoint
) where

import System.Random (Random(randomR), RandomGen, StdGen)
import MyData(Flag(..), Pixel(..), Pos(..), Color(..))

getRandomPoint :: StdGen -> Int -> [Pixel] -> [Int] -> [Int]
getRandomPoint g 0 pixels clusters = clusters
getRandomPoint g i pixels clusters
    | value `elem` clusters = getRandomPoint newg i pixels clusters
    | otherwise = getRandomPoint newg (i - 1) pixels clusters ++ [value]
    where
        (value, newg) = randomR (0, length pixels - 1) g

returnPixel :: Int -> [Pixel] -> [(Color, [Pixel])]
returnPixel 0 (pixels:xs) =  [(colors pixels, [])]
returnPixel i (x:xs) = returnPixel (i - 1) xs

initClusters :: [Int] -> [Pixel] -> [(Color, [Pixel])]
initClusters [] pixels = []
initClusters (index:xs) pixels = initClusters xs pixels ++ returnPixel index pixels

get1th :: (Int, Int, Int) -> Int
get1th (a,_,_) = a

get2th :: (Int, Int, Int) -> Int
get2th (_, a,_) = a

get3th :: (Int, Int, Int) -> Int
get3th (_,_, a) = a

getDistance :: Color -> Color -> Float
getDistance a b = sqrt (x + y + z)
    where
        x = fromIntegral (get1th (color a) - get1th (color b))^2 :: Float
        y = fromIntegral (get2th (color a) - get2th (color b))^2 :: Float
        z = fromIntegral (get3th (color a) - get3th (color b))^2 :: Float

sumColor :: [Color] -> Int -> ((Int, Int, Int) -> Int) -> Int
sumColor [x] sum funct = sum + funct (color x)
sumColor (x:xs) sum funct =  sumColor xs (sum + funct (color x)) funct

meanCluster :: [Color] -> Color
meanCluster list = Color (x, y, z)
    where
        x = div (sumColor list 0 get1th) (length list)
        y = div (sumColor list 0 get2th) (length list)
        z = div (sumColor list 0 get3th) (length list)

getColors :: [Pixel] -> [Color]
getColors [] = []
getColors (x:xs) =  [colors x] ++ getColors xs

redifinedCluster :: [(Color, [Pixel])] -> [(Color, [Pixel])]
redifinedCluster [] = []
redifinedCluster ((cluster, []):xs) = (cluster, []) : redifinedCluster xs
redifinedCluster ((cluster, pixels):xs) = new: redifinedCluster xs
    where
        new = (meanCluster (getColors pixels), [])

addPixelToCluster :: [(Color, [Pixel])] -> Pixel -> Int-> [(Color, [Pixel])]
addPixelToCluster ((color, pixel):xs) new 0 = (color, pixel ++ [new]):xs
addPixelToCluster (x:xs) new i = addPixelToCluster (xs ++ [x]) new (i - 1)

continueKMean :: [(Color, [Pixel])] -> [(Color, [Pixel])] -> Float -> Bool
continueKMean new [] converge
    | null new = False
    | otherwise = True
continueKMean [] old converge = True
continueKMean ((newC, newPixel):news) ((oldC, oldPixel):olds) converge
    | getDistance newC oldC <= converge = continueKMean news olds converge
    | otherwise = True

getCluster :: [(Color, [Pixel])] -> [Color]
getCluster [] = []
getCluster ((cluster, pixels):xs) = getCluster xs ++ [cluster]

getIndex :: Color -> [Color] -> Float -> Int -> Int -> Int
getIndex point [] distance index saveIndex = saveIndex
getIndex point (cluster:xs) distance index saveIndex
    | dist < distance = getIndex point xs dist (index + 1) index
    | otherwise = getIndex point xs distance (index + 1) saveIndex
    where
        dist = getDistance point cluster

getNewGen :: [Pixel] -> [(Color, [Pixel])] -> [(Color, [Pixel])]
getNewGen [] cluster = cluster
getNewGen (x:xs) cluster = getNewGen xs (addPixelToCluster cluster x findIndex)
    where
        findIndex = getIndex (colors x) (getCluster cluster) 500.0 0 0

kmean :: Float -> [Pixel] -> [(Color, [Pixel])] -> [(Color, [Pixel])]
kmean converge allPixels old
    | continueKMean old newGen converge = kmean converge allPixels newGen
    | otherwise = getNewGen allPixels old
    where
        newGen = redifinedCluster (getNewGen allPixels old)