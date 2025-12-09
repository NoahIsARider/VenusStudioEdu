package main

import "fmt"

// DemoConditions 演示 Go 语言的条件语句
func DemoConditions() {
	fmt.Println("\n=== 4. 条件语句 ===")

	// 1. 基本的 if 语句
	fmt.Println("\n基本 if 语句:")
	age := 18
	if age >= 18 {
		fmt.Println("你已成年")
	}

	// 2. if-else 语句
	fmt.Println("\nif-else 语句:")
	score := 85
	if score >= 90 {
		fmt.Println("优秀")
	} else {
		fmt.Println("良好")
	}

	// 3. if-else if-else 语句
	fmt.Println("\nif-else if-else 语句:")
	grade := 75
	if grade >= 90 {
		fmt.Println("成绩等级: A")
	} else if grade >= 80 {
		fmt.Println("成绩等级: B")
	} else if grade >= 70 {
		fmt.Println("成绩等级: C")
	} else if grade >= 60 {
		fmt.Println("成绩等级: D")
	} else {
		fmt.Println("成绩等级: F")
	}

	// 4. if 语句的简短语句
	// 可以在条件之前执行一个简短的语句
	fmt.Println("\nif 简短语句:")
	if num := getNumber(); num > 0 {
		fmt.Printf("数字 %d 是正数\n", num)
	} else if num < 0 {
		fmt.Printf("数字 %d 是负数\n", num)
	} else {
		fmt.Println("数字是零")
	}
	// 注意: num 变量只在 if-else 块中可见

	// 5. 条件表达式中的多个条件
	fmt.Println("\n多个条件:")
	temperature := 25
	humidity := 60
	if temperature > 20 && temperature < 30 && humidity < 70 {
		fmt.Println("天气很舒适")
	} else {
		fmt.Println("天气不太舒适")
	}

	// 6. 使用逻辑运算符
	fmt.Println("\n逻辑运算符:")
	isWeekend := true
	isHoliday := false
	if isWeekend || isHoliday {
		fmt.Println("可以休息！")
	}

	// 7. 嵌套 if 语句
	fmt.Println("\n嵌套 if 语句:")
	hasLicense := true
	hasInsurance := true
	if hasLicense {
		if hasInsurance {
			fmt.Println("可以合法驾驶")
		} else {
			fmt.Println("有驾照但需要保险")
		}
	} else {
		fmt.Println("需要先考驾照")
	}

	// 8. 条件判断的最佳实践
	fmt.Println("\n最佳实践 - 提前返回:")
	checkUser := func(username string, password string) {
		// 提前返回（卫语句）- 推荐的做法
		if username == "" {
			fmt.Println("用户名不能为空")
			return
		}
		if password == "" {
			fmt.Println("密码不能为空")
			return
		}
		if len(password) < 8 {
			fmt.Println("密码长度至少8位")
			return
		}
		fmt.Println("登录成功！")
	}
	checkUser("alice", "password123")
	checkUser("", "password")
	checkUser("bob", "short")

	// 9. 三元运算符的替代方案
	// Go 没有三元运算符，使用 if-else 或函数
	fmt.Println("\n三元运算符替代:")
	x := 10
	max := func(a, b int) int {
		if a > b {
			return a
		}
		return b
	}
	fmt.Printf("max(x, 5) = %d\n", max(x, 5))
}

func getNumber() int {
	return 42
}

func main() {
	DemoConditions()
}
