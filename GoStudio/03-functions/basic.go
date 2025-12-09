package main

import "fmt"

// DemoBasicFunctions 演示 Go 语言的基本函数
func DemoBasicFunctions() {
	fmt.Println("\n=== 7. 基本函数 ===")

	// 1. 无参数无返回值
	fmt.Println("\n1. 无参数无返回值:")
	sayHello()

	// 2. 有参数无返回值
	fmt.Println("\n2. 有参数无返回值:")
	greet("Alice")

	// 3. 有参数有返回值
	fmt.Println("\n3. 有参数有返回值:")
	sum := add(5, 3)
	fmt.Printf("5 + 3 = %d\n", sum)

	// 4. 多个返回值
	fmt.Println("\n4. 多个返回值:")
	quotient, remainder := divide(10, 3)
	fmt.Printf("10 / 3 = %d 余 %d\n", quotient, remainder)

	// 5. 命名返回值
	fmt.Println("\n5. 命名返回值:")
	area, perimeter := rectangle(5, 3)
	fmt.Printf("矩形 (5x3): 面积=%d, 周长=%d\n", area, perimeter)

	// 6. 忽略返回值
	fmt.Println("\n6. 忽略返回值:")
	result, _ := divide(20, 4) // 使用 _ 忽略不需要的返回值
	fmt.Printf("20 / 4 = %d\n", result)

	// 7. 可变参数函数
	fmt.Println("\n7. 可变参数函数:")
	fmt.Printf("sum(1, 2, 3) = %d\n", sumAll(1, 2, 3))
	fmt.Printf("sum(1, 2, 3, 4, 5) = %d\n", sumAll(1, 2, 3, 4, 5))

	// 8. 传递切片给可变参数
	fmt.Println("\n8. 传递切片给可变参数:")
	numbers := []int{10, 20, 30, 40}
	fmt.Printf("sum(%v) = %d\n", numbers, sumAll(numbers...))

	// 9. 函数作为值
	fmt.Println("\n9. 函数作为值:")
	operation := add
	fmt.Printf("使用函数变量: operation(7, 8) = %d\n", operation(7, 8))

	// 10. 函数作为参数
	fmt.Println("\n10. 函数作为参数:")
	result1 := calculate(10, 5, add)
	result2 := calculate(10, 5, multiply)
	fmt.Printf("calculate(10, 5, add) = %d\n", result1)
	fmt.Printf("calculate(10, 5, multiply) = %d\n", result2)

	// 11. 函数作为返回值
	fmt.Println("\n11. 函数作为返回值:")
	adder := makeAdder(10)
	fmt.Printf("adder(5) = %d\n", adder(5))
	fmt.Printf("adder(3) = %d\n", adder(3))

	// 12. 匿名函数
	fmt.Println("\n12. 匿名函数:")
	subtract := func(a, b int) int {
		return a - b
	}
	fmt.Printf("匿名函数: subtract(10, 3) = %d\n", subtract(10, 3))

	// 13. 立即执行函数
	fmt.Println("\n13. 立即执行函数:")
	func(msg string) {
		fmt.Println("立即执行:", msg)
	}("Hello from IIFE!")

	// 14. 递归函数
	fmt.Println("\n14. 递归函数:")
	fmt.Printf("factorial(5) = %d\n", factorial(5))
	fmt.Printf("fibonacci(7) = %d\n", fibonacci(7))

	// 15. defer 语句
	fmt.Println("\n15. defer 语句:")
	demoDefer()

	// 16. 多个 defer 的执行顺序（后进先出）
	fmt.Println("\n16. 多个 defer (LIFO):")
	multipleDeferDemo()
}

// 无参数无返回值
func sayHello() {
	fmt.Println("Hello, Go!")
}

// 有参数无返回值
func greet(name string) {
	fmt.Printf("Hello, %s!\n", name)
}

// 有参数有返回值
func add(a, b int) int {
	return a + b
}

// 多个返回值
func divide(a, b int) (int, int) {
	return a / b, a % b
}

// 命名返回值
func rectangle(length, width int) (area int, perimeter int) {
	area = length * width
	perimeter = 2 * (length + width)
	return // 裸返回，自动返回命名的返回值
}

// 可变参数函数
func sumAll(numbers ...int) int {
	total := 0
	for _, num := range numbers {
		total += num
	}
	return total
}

// 乘法函数
func multiply(a, b int) int {
	return a * b
}

// 接受函数作为参数
func calculate(a, b int, operation func(int, int) int) int {
	return operation(a, b)
}

// 返回函数
func makeAdder(x int) func(int) int {
	return func(y int) int {
		return x + y
	}
}

// 递归：计算阶乘
func factorial(n int) int {
	if n <= 1 {
		return 1
	}
	return n * factorial(n-1)
}

// 递归：斐波那契数列
func fibonacci(n int) int {
	if n <= 1 {
		return n
	}
	return fibonacci(n-1) + fibonacci(n-2)
}

// defer 示例
func demoDefer() {
	defer fmt.Println("这是第一个 defer，最后执行")
	defer fmt.Println("这是第二个 defer，第二个执行")
	defer fmt.Println("这是第三个 defer，第一个执行")
	fmt.Println("这是普通语句，最先执行")
}

// 多个 defer 示例
func multipleDeferDemo() {
	for i := 1; i <= 3; i++ {
		defer fmt.Printf("defer %d\n", i)
	}
	fmt.Println("函数主体执行完毕")
}

func main() {
	DemoBasicFunctions()
}
