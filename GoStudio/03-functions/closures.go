package main

import "fmt"

// DemoClosures 演示 Go 语言的闭包
func DemoClosures() {
	fmt.Println("\n=== 9. 闭包 ===")

	// 1. 基本闭包
	fmt.Println("\n1. 基本闭包:")
	increment := makeIncrementer()
	fmt.Printf("第一次调用: %d\n", increment())
	fmt.Printf("第二次调用: %d\n", increment())
	fmt.Printf("第三次调用: %d\n", increment())

	// 2. 多个闭包实例
	fmt.Println("\n2. 多个闭包实例:")
	inc1 := makeIncrementer()
	inc2 := makeIncrementer()
	fmt.Printf("inc1: %d\n", inc1())
	fmt.Printf("inc1: %d\n", inc1())
	fmt.Printf("inc2: %d\n", inc2())
	fmt.Println("（每个闭包都有自己的计数器）")

	// 3. 闭包捕获外部变量
	fmt.Println("\n3. 闭包捕获外部变量:")
	x := 10
	addToX := func(y int) int {
		return x + y
	}
	fmt.Printf("addToX(5) = %d\n", addToX(5))
	x = 20
	fmt.Printf("修改 x 后, addToX(5) = %d\n", addToX(5))

	// 4. 闭包修改外部变量
	fmt.Println("\n4. 闭包修改外部变量:")
	counter := 0
	increment := func() {
		counter++
		fmt.Printf("Counter: %d\n", counter)
	}
	increment()
	increment()
	increment()

	// 5. 工厂函数
	fmt.Println("\n5. 工厂函数:")
	mul2 := makeMultiplier(2)
	mul5 := makeMultiplier(5)
	fmt.Printf("mul2(10) = %d\n", mul2(10))
	fmt.Printf("mul5(10) = %d\n", mul5(10))

	// 6. 闭包与循环（常见陷阱）
	fmt.Println("\n6. 闭包与循环（错误示例）:")
	funcs := []func(){}
	for i := 0; i < 3; i++ {
		funcs = append(funcs, func() {
			fmt.Printf("%d ", i) // 捕获的是变量 i，不是值
		})
	}
	for _, f := range funcs {
		f() // 都会打印 3
	}
	fmt.Println()

	// 7. 闭包与循环（正确方式）
	fmt.Println("\n7. 闭包与循环（正确示例）:")
	funcs2 := []func(){}
	for i := 0; i < 3; i++ {
		i := i // 创建新的变量
		funcs2 = append(funcs2, func() {
			fmt.Printf("%d ", i)
		})
	}
	for _, f := range funcs2 {
		f()
	}
	fmt.Println()

	// 8. 闭包实现私有变量
	fmt.Println("\n8. 闭包实现私有变量:")
	account := makeAccount(100)
	account.deposit(50)
	account.withdraw(30)
	account.withdraw(200) // 余额不足
	account.getBalance()

	// 9. 闭包实现延迟计算
	fmt.Println("\n9. 闭包实现延迟计算:")
	expensiveOp := func() int {
		fmt.Println("执行昂贵的计算...")
		return 42
	}
	lazy := makeLazy(expensiveOp)
	fmt.Println("创建了延迟计算")
	fmt.Printf("第一次获取值: %d\n", lazy())
	fmt.Printf("第二次获取值（使用缓存）: %d\n", lazy())

	// 10. 闭包实现生成器
	fmt.Println("\n10. 闭包实现生成器:")
	gen := makeGenerator()
	fmt.Printf("生成: %d\n", gen())
	fmt.Printf("生成: %d\n", gen())
	fmt.Printf("生成: %d\n", gen())

	// 11. 斐波那契生成器
	fmt.Println("\n11. 斐波那契生成器:")
	fibGen := fibonacciGenerator()
	for i := 0; i < 10; i++ {
		fmt.Printf("%d ", fibGen())
	}
	fmt.Println()

	// 12. 闭包实现装饰器模式
	fmt.Println("\n12. 闭包实现装饰器模式:")
	greet := func(name string) string {
		return "Hello, " + name
	}
	decoratedGreet := addExclamation(greet)
	fmt.Println(decoratedGreet("Alice"))
}

// 创建递增器
func makeIncrementer() func() int {
	count := 0
	return func() int {
		count++
		return count
	}
}

// 创建乘法器
func makeMultiplier(factor int) func(int) int {
	return func(x int) int {
		return x * factor
	}
}

// 创建账户（封装私有状态）
func makeAccount(initialBalance int) struct {
	deposit    func(int)
	withdraw   func(int)
	getBalance func()
} {
	balance := initialBalance

	return struct {
		deposit    func(int)
		withdraw   func(int)
		getBalance func()
	}{
		deposit: func(amount int) {
			balance += amount
			fmt.Printf("存款 %d, 余额: %d\n", amount, balance)
		},
		withdraw: func(amount int) {
			if balance >= amount {
				balance -= amount
				fmt.Printf("取款 %d, 余额: %d\n", amount, balance)
			} else {
				fmt.Println("余额不足")
			}
		},
		getBalance: func() {
			fmt.Printf("当前余额: %d\n", balance)
		},
	}
}

// 延迟计算
func makeLazy(f func() int) func() int {
	var cached *int
	return func() int {
		if cached == nil {
			value := f()
			cached = &value
		}
		return *cached
	}
}

// 生成器
func makeGenerator() func() int {
	n := 0
	return func() int {
		n++
		return n
	}
}

// 斐波那契生成器
func fibonacciGenerator() func() int {
	a, b := 0, 1
	return func() int {
		result := a
		a, b = b, a+b
		return result
	}
}

// 装饰器：添加感叹号
func addExclamation(f func(string) string) func(string) string {
	return func(s string) string {
		return f(s) + "!"
	}
}

func main() {
	DemoClosures()
}
