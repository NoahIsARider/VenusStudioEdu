package main

import (
	"fmt"
)

// DemoPanic 演示 Go 语言的 panic 和 recover
func DemoPanic() {
	fmt.Println("\n=== 20. Panic 和 Recover ===")

	// 1. 基本 panic
	fmt.Println("\n1. 基本 panic（注释掉以避免程序终止）:")
	fmt.Println("// panic(\"出错了！\") - 这会终止程序")

	// 2. recover 捕获 panic
	fmt.Println("\n2. 使用 recover 捕获 panic:")
	safeFunction()
	fmt.Println("程序继续运行")

	// 3. defer 中的 recover
	fmt.Println("\n3. defer 中的 recover:")
	safeDivide(10, 0)
	fmt.Println("除法后继续")

	// 4. panic 传播
	fmt.Println("\n4. panic 传播:")
	outerFunction()

	// 5. 检查 panic 值
	fmt.Println("\n5. 检查 panic 值:")
	checkPanicValue()

	// 6. 多层 defer 和 recover
	fmt.Println("\n6. 多层 defer:")
	multipleDeferWithPanic()

	// 7. panic 的实际应用
	fmt.Println("\n7. 实际应用 - 断言:")
	mustBePositive(10)
	fmt.Println("检查通过")

	// 这会 panic
	defer func() {
		if r := recover(); r != nil {
			fmt.Printf("捕获到 panic: %v\n", r)
		}
	}()
	mustBePositive(-5)

	// 8. 什么时候使用 panic
	fmt.Println("\n8. 使用 panic 的场景:")
	fmt.Println("- 不可恢复的错误")
	fmt.Println("- 程序员错误（如索引越界）")
	fmt.Println("- 初始化失败")
	fmt.Println("- 不应该使用 panic 代替常规错误处理")
}

// 安全函数示例
func safeFunction() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Printf("捕获到 panic: %v\n", r)
		}
	}()
	
	fmt.Println("开始执行")
	panic("出现问题！")
	fmt.Println("这行不会执行")
}

// 安全的除法
func safeDivide(a, b int) {
	defer func() {
		if r := recover(); r != nil {
			fmt.Printf("除法错误: %v\n", r)
		}
	}()
	
	if b == 0 {
		panic("除数不能为0")
	}
	result := a / b
	fmt.Printf("%d / %d = %d\n", a, b, result)
}

// panic 传播
func innerFunction() {
	panic("内部函数 panic")
}

func middleFunction() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Printf("中间层捕获: %v\n", r)
			// 可以选择重新 panic
			// panic(r)
		}
	}()
	innerFunction()
}

func outerFunction() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Printf("外层捕获: %v\n", r)
		}
	}()
	middleFunction()
	fmt.Println("外层函数继续")
}

// 检查 panic 值的类型
func checkPanicValue() {
	defer func() {
		if r := recover(); r != nil {
			switch v := r.(type) {
			case string:
				fmt.Printf("字符串 panic: %s\n", v)
			case int:
				fmt.Printf("整数 panic: %d\n", v)
			case error:
				fmt.Printf("错误 panic: %v\n", v)
			default:
				fmt.Printf("未知类型 panic: %v\n", v)
			}
		}
	}()
	
	panic("这是一个字符串")
}

// 多层 defer
func multipleDeferWithPanic() {
	defer fmt.Println("第一个 defer")
	defer func() {
		if r := recover(); r != nil {
			fmt.Printf("recover: %v\n", r)
		}
	}()
	defer fmt.Println("第三个 defer")
	
	panic("测试 panic")
	fmt.Println("不会执行")
}

// 断言函数
func mustBePositive(n int) {
	if n <= 0 {
		panic(fmt.Sprintf("必须是正数，得到: %d", n))
	}
}

// 数组访问安全包装
func safeArrayAccess(arr []int, index int) (value int, err error) {
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("索引越界: %v", r)
		}
	}()
	
	value = arr[index]
	return value, nil
}

func main() {
	DemoPanic()
}
