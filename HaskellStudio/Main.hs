import Basics
import Functions
import Types
import Recursion

main :: IO ()
main = do
    putStrLn "======================================="
    putStrLn "🌟 欢迎来到 HaskellStudio 教程主入口 🌟"
    putStrLn "======================================="
    
    runBasics
    runFunctions
    runTypes
    runRecursion

    putStrLn "\n======================================="
    putStrLn "🎉 HaskellStudio 所有教程运行完毕！"
    putStrLn "======================================="
