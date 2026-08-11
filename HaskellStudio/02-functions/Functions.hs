module Functions where

add :: Int -> Int -> Int
add x y = x + y

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

runFunctions :: IO ()
runFunctions = do
    putStrLn "=== 1. 函数定义与柯里化 ==="
    putStrLn ("add 5 3 = " ++ show (add 5 3))
    
    putStrLn "\n=== 2. 模式匹配与递归 ==="
    putStrLn ("factorial 5 = " ++ show (factorial 5))
