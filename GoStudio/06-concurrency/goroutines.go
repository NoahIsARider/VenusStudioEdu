package main

import (
	"fmt"
	"time"
)

// DemoGoroutines 演示 Go 语言的 goroutines
func DemoGoroutines() {
	fmt.Println("\n=== 16. Goroutines (协程) ===")

	// 1. 基本 goroutine
	fmt.Println("\n1. 基本 goroutine:")
	go sayHello("Goroutine")
	sayHello("Main")
	time.Sleep(time.Millisecond * 100) // 等待 goroutine 完成

	// 2. 多个 goroutines
	fmt.Println("\n2. 多个 goroutines:")
	for i := 1; i <= 5; i++ {
		go printNumber(i)
	}
	time.Sleep(time.Millisecond * 200)

	// 3. 匿名函数 goroutine
	fmt.Println("\n3. 匿名函数 goroutine:")
	for i := 1; i <= 3; i++ {
		go func(n int) {
			fmt.Printf("Goroutine %d\n", n)
		}(i) // 传递参数避免闭包陷阱
	}
	time.Sleep(time.Millisecond * 100)

	// 4. 闭包陷阱示例
	fmt.Println("\n4. 闭包陷阱（错误示例）:")
	for i := 1; i <= 3; i++ {
		go func() {
			fmt.Printf("错误: %d ", i) // 捕获的是变量，可能都是最后的值
		}()
	}
	time.Sleep(time.Millisecond * 100)
	fmt.Println()

	// 5. 正确的闭包使用
	fmt.Println("\n5. 正确的闭包:")
	for i := 1; i <= 3; i++ {
		i := i // 创建新变量
		go func() {
			fmt.Printf("正确: %d ", i)
		}()
	}
	time.Sleep(time.Millisecond * 100)
	fmt.Println()

	// 6. Goroutine 与主程序的关系
	fmt.Println("\n6. 主程序退出，goroutines 也会终止:")
	go func() {
		for i := 1; i <= 5; i++ {
			fmt.Printf("%d ", i)
			time.Sleep(time.Millisecond * 50)
		}
	}()
	time.Sleep(time.Millisecond * 150) // 只等待一部分时间
	fmt.Println("\n主程序即将退出...")

	// 7. 并发执行示例
	fmt.Println("\n7. 并发执行任务:")
	start := time.Now()
	
	go task("任务 A", 100)
	go task("任务 B", 100)
	go task("任务 C", 100)
	
	time.Sleep(time.Millisecond * 150)
	elapsed := time.Since(start)
	fmt.Printf("并发执行总时间: %v\n", elapsed)

	// 8. 顺序执行对比
	fmt.Println("\n8. 顺序执行对比:")
	start = time.Now()
	
	task("任务 A", 100)
	task("任务 B", 100)
	task("任务 C", 100)
	
	elapsed = time.Since(start)
	fmt.Printf("顺序执行总时间: %v\n", elapsed)

	// 9. WaitGroup 将在 channels.go 中介绍
	fmt.Println("\n9. 更好的同步方式:")
	fmt.Println("使用 Channel 和 WaitGroup 进行同步（见下一个示例）")

	// 10. Goroutine 泄漏示例
	fmt.Println("\n10. Goroutine 泄漏警告:")
	fmt.Println("永远阻塞的 goroutine 会造成内存泄漏")
	fmt.Println("示例: 发送数据到无缓冲 channel 但没有接收者")
}

func sayHello(name string) {
	fmt.Printf("Hello from %s\n", name)
}

func printNumber(n int) {
	time.Sleep(time.Millisecond * 10)
	fmt.Printf("Number: %d\n", n)
}

func task(name string, ms int) {
	fmt.Printf("%s 开始\n", name)
	time.Sleep(time.Millisecond * time.Duration(ms))
	fmt.Printf("%s 完成\n", name)
}

func main() {
	DemoGoroutines()
}
