module Types where

data Shape = Circle Float | Rectangle Float Float

area :: Shape -> Float
area (Circle r) = pi * r * r
area (Rectangle w h) = w * h

runTypes :: IO ()
runTypes = do
    putStrLn "=== 1. 代数数据类型与模式匹配 ==="
    let c = Circle 5.0
    let r = Rectangle 4.0 5.0
    putStrLn ("圆的面积: " ++ show (area c))
    putStrLn ("矩形的面积: " ++ show (area r))
