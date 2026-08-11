module Recursion where

runRecursion :: IO ()
runRecursion = do
    putStrLn "=== 1. 列表操作与高阶函数 ==="
    let nums = [1, 2, 3, 4, 5]
    let doubled = map (* 2) nums
    let evens = filter even nums
    putStrLn ("原列表: " ++ show nums)
    putStrLn ("映射翻倍: " ++ show doubled)
    putStrLn ("过滤偶数: " ++ show evens)
