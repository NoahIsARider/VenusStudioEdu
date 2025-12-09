package main

import (
	"fmt"
	"time"
)

// DemoSwitch 演示 Go 语言的 switch 语句
func DemoSwitch() {
	fmt.Println("\n=== 6. Switch 语句 ===")

	// 1. 基本的 switch 语句
	fmt.Println("\n基本 switch:")
	day := 3
	switch day {
	case 1:
		fmt.Println("星期一")
	case 2:
		fmt.Println("星期二")
	case 3:
		fmt.Println("星期三")
	case 4:
		fmt.Println("星期四")
	case 5:
		fmt.Println("星期五")
	case 6:
		fmt.Println("星期六")
	case 7:
		fmt.Println("星期日")
	default:
		fmt.Println("无效的日期")
	}

	// 2. 多个条件的 case
	fmt.Println("\n多个条件的 case:")
	switch day {
	case 1, 2, 3, 4, 5:
		fmt.Println("工作日")
	case 6, 7:
		fmt.Println("周末")
	default:
		fmt.Println("无效")
	}

	// 3. 没有表达式的 switch（相当于 if-else）
	fmt.Println("\n没有表达式的 switch:")
	score := 85
	switch {
	case score >= 90:
		fmt.Println("优秀")
	case score >= 80:
		fmt.Println("良好")
	case score >= 70:
		fmt.Println("中等")
	case score >= 60:
		fmt.Println("及格")
	default:
		fmt.Println("不及格")
	}

	// 4. switch 中的简短语句
	fmt.Println("\nswitch 简短语句:")
	switch hour := time.Now().Hour(); {
	case hour < 12:
		fmt.Println("上午好")
	case hour < 18:
		fmt.Println("下午好")
	default:
		fmt.Println("晚上好")
	}

	// 5. fallthrough 关键字
	// Go 的 switch 默认不会贯穿，需要显式使用 fallthrough
	fmt.Println("\nfallthrough 示例:")
	num := 2
	switch num {
	case 1:
		fmt.Println("1")
		fallthrough
	case 2:
		fmt.Println("2")
		fallthrough
	case 3:
		fmt.Println("3")
	case 4:
		fmt.Println("4")
	}

	// 6. 类型 switch
	fmt.Println("\n类型 switch:")
	var i interface{} = "hello"
	switch v := i.(type) {
	case int:
		fmt.Printf("整数: %d\n", v)
	case string:
		fmt.Printf("字符串: %s\n", v)
	case bool:
		fmt.Printf("布尔值: %t\n", v)
	default:
		fmt.Printf("未知类型: %T\n", v)
	}

	// 7. 更多类型 switch 示例
	fmt.Println("\n检测多种类型:")
	checkType := func(x interface{}) {
		switch v := x.(type) {
		case nil:
			fmt.Println("nil")
		case int, int8, int16, int32, int64:
			fmt.Printf("整数类型: %d\n", v)
		case float32, float64:
			fmt.Printf("浮点类型: %f\n", v)
		case string:
			fmt.Printf("字符串类型: %s\n", v)
		case []int:
			fmt.Printf("整数切片: %v\n", v)
		default:
			fmt.Printf("其他类型: %T\n", v)
		}
	}

	checkType(42)
	checkType(3.14)
	checkType("Go")
	checkType([]int{1, 2, 3})
	checkType(true)

	// 8. switch 与条件表达式
	fmt.Println("\nswitch 与条件表达式:")
	age := 25
	switch {
	case age < 0:
		fmt.Println("年龄无效")
	case age < 18:
		fmt.Println("未成年")
	case age >= 18 && age < 60:
		fmt.Println("成年人")
	case age >= 60:
		fmt.Println("老年人")
	}

	// 9. switch 中使用函数
	fmt.Println("\nswitch 中使用函数:")
	switch getGrade(88) {
	case "A":
		fmt.Println("优秀")
	case "B":
		fmt.Println("良好")
	case "C":
		fmt.Println("中等")
	case "D":
		fmt.Println("及格")
	case "F":
		fmt.Println("不及格")
	}

	// 10. 实际应用：HTTP 状态码处理
	fmt.Println("\n实际应用 - HTTP 状态码:")
	handleHTTPStatus := func(statusCode int) {
		switch statusCode {
		case 200:
			fmt.Println("OK")
		case 201:
			fmt.Println("Created")
		case 204:
			fmt.Println("No Content")
		case 400:
			fmt.Println("Bad Request")
		case 401:
			fmt.Println("Unauthorized")
		case 403:
			fmt.Println("Forbidden")
		case 404:
			fmt.Println("Not Found")
		case 500:
			fmt.Println("Internal Server Error")
		case 502:
			fmt.Println("Bad Gateway")
		case 503:
			fmt.Println("Service Unavailable")
		default:
			fmt.Printf("Status Code: %d\n", statusCode)
		}
	}
	handleHTTPStatus(200)
	handleHTTPStatus(404)
	handleHTTPStatus(500)

	// 11. switch vs if-else 性能比较说明
	fmt.Println("\n性能说明:")
	fmt.Println("- switch 通常比多个 if-else 更高效")
	fmt.Println("- switch 可以生成跳转表，查找时间为 O(1)")
	fmt.Println("- 多个 if-else 是线性查找，时间复杂度为 O(n)")
}

func getGrade(score int) string {
	switch {
	case score >= 90:
		return "A"
	case score >= 80:
		return "B"
	case score >= 70:
		return "C"
	case score >= 60:
		return "D"
	default:
		return "F"
	}
}

func main() {
	DemoSwitch()
}
