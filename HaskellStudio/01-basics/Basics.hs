module Basics where

runBasics :: IO ()
runBasics = do
    putStrLn "=== 1. Haskell 基础与变量 ==="
    let name = "HaskellStudio"
    let version = 9.6
    putStrLn ("语言名称: " ++ name)
    putStrLn ("版本: " ++ show version)
    
    putStrLn "\n=== 2. 基本运算 ==="
    let sumVal = 10 + 20
    let prodVal = 5 * 6
    putStrLn ("10 + 20 = " ++ show sumVal)
    putStrLn ("5 * 6 = " ++ show prodVal)
