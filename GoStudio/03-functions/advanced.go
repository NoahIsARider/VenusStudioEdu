package main

import "fmt"

// DemoAdvancedFunctions 演示 Go 语言的高级函数特性
func DemoAdvancedFunctions() {
	fmt.Println("\n=== 8. 高级函数特性 ===")

	// 1. 高阶函数 - Map
	fmt.Println("\n1. 高阶函数 - Map:")
	numbers := []int{1, 2, 3, 4, 5}
	doubled := mapInt(numbers, func(n int) int {
		return n * 2
	})
	fmt.Printf("原数组: %v\n", numbers)
	fmt.Printf("翻倍后: %v\n", doubled)

	// 2. 高阶函数 - Filter
	fmt.Println("\n2. 高阶函数 - Filter:")
	evens := filterInt(numbers, func(n int) bool {
		return n%2 == 0
	})
	fmt.Printf("偶数: %v\n", evens)

	// 3. 高阶函数 - Reduce
	fmt.Println("\n3. 高阶函数 - Reduce:")
	sum := reduceInt(numbers, 0, func(acc, n int) int {
		return acc + n
	})
	fmt.Printf("总和: %d\n", sum)

	// 4. 柯里化 (Currying)
	fmt.Println("\n4. 柯里化:")
	add := func(a int) func(int) int {
		return func(b int) int {
			return a + b
		}
	}
	add5 := add(5)
	fmt.Printf("add(5)(3) = %d\n", add5(3))
	fmt.Printf("add(5)(10) = %d\n", add5(10))

	// 5. 函数组合
	fmt.Println("\n5. 函数组合:")
	double := func(x int) int { return x * 2 }
	addTen := func(x int) int { return x + 10 }
	composed := compose(double, addTen)
	fmt.Printf("compose(double, addTen)(5) = %d\n", composed(5)) // (5+10)*2

	// 6. 偏函数应用
	fmt.Println("\n6. 偏函数应用:")
	multiply := func(a, b, c int) int {
		return a * b * c
	}
	multiplyBy2 := partial3(multiply, 2)
	fmt.Printf("multiplyBy2(3, 4) = %d\n", multiplyBy2(3, 4))

	// 7. 记忆化（Memoization）
	fmt.Println("\n7. 记忆化:")
	fib := memoize()
	fmt.Printf("fibonacci(10) = %d\n", fib(10))
	fmt.Printf("fibonacci(15) = %d\n", fib(15))
	fmt.Println("（缓存提高了性能）")

	// 8. 管道模式
	fmt.Println("\n8. 管道模式:")
	pipeline := []int{1, 2, 3, 4, 5}
	result := pipeline
	result = mapInt(result, func(n int) int { return n * 2 })
	result = filterInt(result, func(n int) bool { return n > 5 })
	fmt.Printf("管道结果: %v\n", result)

	// 9. 错误处理包装器
	fmt.Println("\n9. 错误处理包装器:")
	safeDiv := errorWrapper(func(a, b int) (int, error) {
		if b == 0 {
			return 0, fmt.Errorf("除数不能为0")
		}
		return a / b, nil
	})
	safeDiv(10, 2)
	safeDiv(10, 0)

	// 10. 函数装饰器（计时）
	fmt.Println("\n10. 函数装饰器（计时）:")
	slowFunc := func() {
		sum := 0
		for i := 0; i < 1000000; i++ {
			sum += i
		}
	}
	timedFunc := timeIt(slowFunc)
	timedFunc()

	// 11. 函数缓存
	fmt.Println("\n11. 函数缓存:")
	expensiveCalc := func(n int) int {
		fmt.Printf("计算 %d...\n", n)
		return n * n
	}
	cached := cache(expensiveCalc)
	fmt.Printf("第一次调用: %d\n", cached(5))
	fmt.Printf("第二次调用（使用缓存）: %d\n", cached(5))
	fmt.Printf("不同参数: %d\n", cached(10))
}

// Map 函数 - 对切片中的每个元素应用函数
func mapInt(slice []int, f func(int) int) []int {
	result := make([]int, len(slice))
	for i, v := range slice {
		result[i] = f(v)
	}
	return result
}

// Filter 函数 - 过滤切片
func filterInt(slice []int, f func(int) bool) []int {
	result := []int{}
	for _, v := range slice {
		if f(v) {
			result = append(result, v)
		}
	}
	return result
}

// Reduce 函数 - 归约
func reduceInt(slice []int, initial int, f func(int, int) int) int {
	result := initial
	for _, v := range slice {
		result = f(result, v)
	}
	return result
}

// 函数组合
func compose(f, g func(int) int) func(int) int {
	return func(x int) int {
		return f(g(x))
	}
}

// 偏函数应用
func partial3(f func(int, int, int) int, a int) func(int, int) int {
	return func(b, c int) int {
		return f(a, b, c)
	}
}

// 记忆化斐波那契
func memoize() func(int) int {
	cache := make(map[int]int)
	var fib func(int) int
	fib = func(n int) int {
		if n <= 1 {
			return n
		}
		if val, ok := cache[n]; ok {
			return val
		}
		cache[n] = fib(n-1) + fib(n-2)
		return cache[n]
	}
	return fib
}

// 错误处理包装器
func errorWrapper(f func(int, int) (int, error)) func(int, int) {
	return func(a, b int) {
		result, err := f(a, b)
		if err != nil {
			fmt.Printf("错误: %v\n", err)
		} else {
			fmt.Printf("结果: %d\n", result)
		}
	}
}

// 计时装饰器
func timeIt(f func()) func() {
	return func() {
		// 简化版本，不使用 time 包
		fmt.Println("开始执行...")
		f()
		fmt.Println("执行完成")
	}
}

// 缓存装饰器
func cache(f func(int) int) func(int) int {
	memo := make(map[int]int)
	return func(n int) int {
		if val, ok := memo[n]; ok {
			return val
		}
		memo[n] = f(n)
		return memo[n]
	}
}

func main() {
	DemoAdvancedFunctions()
}
