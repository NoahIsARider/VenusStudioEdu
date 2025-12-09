package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	fmt.Println("╔════════════════════════════════════════╗")
	fmt.Println("║     欢迎来到 GoStudio 学习项目！      ║")
	fmt.Println("║     Go 语言完整学习教程                ║")
	fmt.Println("╚════════════════════════════════════════╝")
	fmt.Println()

	reader := bufio.NewReader(os.Stdin)

	for {
		printMenu()
		fmt.Print("\n请选择一个选项 (1-23, 0 退出): ")
		
		input, _ := reader.ReadString('\n')
		input = strings.TrimSpace(input)

		switch input {
		case "0":
			fmt.Println("\n感谢使用 GoStudio！再见！👋")
			return
		case "1":
			runDemo("01-basics/variables.go")
		case "2":
			runDemo("01-basics/types.go")
		case "3":
			runDemo("01-basics/operators.go")
		case "4":
			runDemo("02-control/conditions.go")
		case "5":
			runDemo("02-control/loops.go")
		case "6":
			runDemo("02-control/switch.go")
		case "7":
			runDemo("03-functions/basic.go")
		case "8":
			runDemo("03-functions/advanced.go")
		case "9":
			runDemo("03-functions/closures.go")
		case "10":
			runDemo("04-data-structures/arrays.go")
		case "11":
			runDemo("04-data-structures/slices.go")
		case "12":
			runDemo("04-data-structures/maps.go")
		case "13":
			runDemo("04-data-structures/structs.go")
		case "14":
			runDemo("05-methods/methods.go")
		case "15":
			runDemo("05-methods/interfaces.go")
		case "16":
			runDemo("06-concurrency/goroutines.go")
		case "17":
			runDemo("06-concurrency/channels.go")
		case "18":
			runDemo("06-concurrency/select.go")
		case "19":
			runDemo("07-errors/errors.go")
		case "20":
			runDemo("07-errors/panic.go")
		case "21":
			runDemo("09-advanced/pointers.go")
		case "22":
			runDemo("09-advanced/generics.go")
		case "23":
			runAllDemos()
		default:
			fmt.Println("❌ 无效的选项，请重试")
		}

		fmt.Print("\n按 Enter 键继续...")
		reader.ReadString('\n')
	}
}

func printMenu() {
	fmt.Println("\n" + strings.Repeat("=", 50))
	fmt.Println("📚 GoStudio 学习菜单")
	fmt.Println(strings.Repeat("=", 50))
	
	fmt.Println("\n🔤 基础语法 (01-basics)")
	fmt.Println("  1. 变量和常量")
	fmt.Println("  2. 数据类型")
	fmt.Println("  3. 运算符")
	
	fmt.Println("\n🔀 控制流 (02-control)")
	fmt.Println("  4. 条件语句 (if-else)")
	fmt.Println("  5. 循环 (for)")
	fmt.Println("  6. Switch 语句")
	
	fmt.Println("\n⚙️  函数 (03-functions)")
	fmt.Println("  7. 基本函数")
	fmt.Println("  8. 高级函数特性")
	fmt.Println("  9. 闭包")
	
	fmt.Println("\n📦 数据结构 (04-data-structures)")
	fmt.Println("  10. 数组")
	fmt.Println("  11. 切片")
	fmt.Println("  12. 映射 (Map)")
	fmt.Println("  13. 结构体")
	
	fmt.Println("\n🎯 方法和接口 (05-methods)")
	fmt.Println("  14. 方法")
	fmt.Println("  15. 接口")
	
	fmt.Println("\n🔄 并发编程 (06-concurrency)")
	fmt.Println("  16. Goroutines")
	fmt.Println("  17. Channels")
	fmt.Println("  18. Select 语句")
	
	fmt.Println("\n⚠️  错误处理 (07-errors)")
	fmt.Println("  19. 错误处理")
	fmt.Println("  20. Panic 和 Recover")
	
	fmt.Println("\n🚀 高级特性 (09-advanced)")
	fmt.Println("  21. 指针")
	fmt.Println("  22. 泛型")
	
	fmt.Println("\n🎬 其他")
	fmt.Println("  23. 运行所有示例")
	fmt.Println("  0.  退出")
}

func runDemo(path string) {
	fmt.Println("\n" + strings.Repeat("─", 50))
	fmt.Printf("▶️  正在运行: %s\n", path)
	fmt.Println(strings.Repeat("─", 50))
	
	// 这里简化处理，实际应该使用 os/exec 包执行
	fmt.Printf("\n请手动运行: go run %s\n", path)
	fmt.Println("\n或使用命令: ./run.sh " + strings.TrimSuffix(path, ".go"))
}

func runAllDemos() {
	fmt.Println("\n" + strings.Repeat("=", 50))
	fmt.Println("🎬 运行所有示例")
	fmt.Println(strings.Repeat("=", 50))
	
	demos := []string{
		"01-basics/variables.go",
		"01-basics/types.go",
		"01-basics/operators.go",
		"02-control/conditions.go",
		"02-control/loops.go",
		"02-control/switch.go",
		"03-functions/basic.go",
		"03-functions/advanced.go",
		"03-functions/closures.go",
		"04-data-structures/arrays.go",
		"04-data-structures/slices.go",
		"04-data-structures/maps.go",
		"04-data-structures/structs.go",
		"05-methods/methods.go",
		"05-methods/interfaces.go",
		"06-concurrency/goroutines.go",
		"06-concurrency/channels.go",
		"06-concurrency/select.go",
		"07-errors/errors.go",
		"07-errors/panic.go",
		"09-advanced/pointers.go",
		"09-advanced/generics.go",
	}
	
	fmt.Println("\n请使用以下命令运行所有示例:")
	for i, demo := range demos {
		fmt.Printf("%d. go run %s\n", i+1, demo)
	}
	
	fmt.Println("\n或使用便捷脚本: ./run-all.sh")
}
