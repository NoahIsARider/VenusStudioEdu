package main

import "fmt"

// DemoVariables 演示 Go 语言的变量声明和使用
func DemoVariables() {
	fmt.Println("\n=== 1. 变量和常量 ===")

	// 1. 使用 var 关键字声明变量
	var name string = "GoStudio"
	var age int = 2
	fmt.Printf("使用 var 声明: name=%s, age=%d\n", name, age)

	// 2. 类型推断 - Go 可以自动推断类型
	var language = "Go"
	var version = 1.25
	fmt.Printf("类型推断: language=%s (类型: string), version=%.2f (类型: float64)\n", language, version)

	// 3. 短变量声明 - 最常用的方式
	city := "北京"
	population := 21_000_000 // 可以使用下划线分隔数字，提高可读性
	fmt.Printf("短变量声明: city=%s, population=%d\n", city, population)

	// 4. 多变量声明
	var x, y, z int = 1, 2, 3
	fmt.Printf("多变量声明: x=%d, y=%d, z=%d\n", x, y, z)

	// 5. 使用简短声明同时声明多个不同类型的变量
	name2, age2, isStudent := "Alice", 20, true
	fmt.Printf("多变量短声明: name=%s, age=%d, isStudent=%t\n", name2, age2, isStudent)

	// 6. 零值 - 未初始化的变量会有默认零值
	var (
		emptyString string  // ""
		emptyInt    int     // 0
		emptyFloat  float64 // 0.0
		emptyBool   bool    // false
	)
	fmt.Printf("零值: string='%s', int=%d, float=%.1f, bool=%t\n",
		emptyString, emptyInt, emptyFloat, emptyBool)

	// 7. 常量 - 使用 const 关键字，在编译时确定
	const PI = 3.14159
	const GREETING = "你好，Go！"
	fmt.Printf("常量: PI=%.5f, GREETING=%s\n", PI, GREETING)

	// 8. 常量组
	const (
		Monday    = 1
		Tuesday   = 2
		Wednesday = 3
	)
	fmt.Printf("常量组: Monday=%d, Tuesday=%d, Wednesday=%d\n", Monday, Tuesday, Wednesday)

	// 9. iota - 常量生成器
	const (
		Sunday = iota // 0
		Monday2       // 1
		Tuesday2      // 2
		Wednesday2    // 3
		Thursday      // 4
		Friday        // 5
		Saturday      // 6
	)
	fmt.Printf("iota 示例: Sunday=%d, Wednesday2=%d, Saturday=%d\n", Sunday, Wednesday2, Saturday)

	// 10. iota 的高级用法 - 位运算
	const (
		ReadPermission = 1 << iota // 1 << 0 = 1 (二进制: 001)
		WritePermission            // 1 << 1 = 2 (二进制: 010)
		ExecutePermission          // 1 << 2 = 4 (二进制: 100)
	)
	fmt.Printf("权限位: Read=%d, Write=%d, Execute=%d\n",
		ReadPermission, WritePermission, ExecutePermission)

	// 11. 变量作用域
	{
		blockVariable := "我只存在于这个代码块中"
		fmt.Printf("块作用域变量: %s\n", blockVariable)
	}
	// blockVariable 在这里不可访问

	// 12. 类型转换（Go 不支持隐式转换）
	var integer int = 42
	var floatNum float64 = float64(integer)
	var anotherInt int = int(floatNum)
	fmt.Printf("类型转换: int(%d) -> float64(%.1f) -> int(%d)\n", integer, floatNum, anotherInt)
}

// 如果直接运行此文件
func main() {
	DemoVariables()
}
