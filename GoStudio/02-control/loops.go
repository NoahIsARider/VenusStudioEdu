package main

import "fmt"

// DemoLoops 演示 Go 语言的循环语句
func DemoLoops() {
	fmt.Println("\n=== 5. 循环语句 ===")

	// 1. 基本的 for 循环（传统形式）
	fmt.Println("\n基本 for 循环:")
	for i := 0; i < 5; i++ {
		fmt.Printf("%d ", i)
	}
	fmt.Println()

	// 2. for 循环作为 while 循环
	fmt.Println("\nfor 作为 while:")
	count := 0
	for count < 5 {
		fmt.Printf("%d ", count)
		count++
	}
	fmt.Println()

	// 3. 无限循环
	fmt.Println("\n无限循环（带 break）:")
	n := 0
	for {
		if n >= 5 {
			break // 使用 break 退出循环
		}
		fmt.Printf("%d ", n)
		n++
	}
	fmt.Println()

	// 4. continue 语句
	fmt.Println("\ncontinue 跳过偶数:")
	for i := 0; i < 10; i++ {
		if i%2 == 0 {
			continue // 跳过本次循环
		}
		fmt.Printf("%d ", i)
	}
	fmt.Println()

	// 5. 嵌套循环
	fmt.Println("\n嵌套循环（打印乘法表）:")
	for i := 1; i <= 3; i++ {
		for j := 1; j <= 3; j++ {
			fmt.Printf("%d*%d=%d ", i, j, i*j)
		}
		fmt.Println()
	}

	// 6. 遍历数组
	fmt.Println("\n遍历数组:")
	arr := [5]int{10, 20, 30, 40, 50}
	for i := 0; i < len(arr); i++ {
		fmt.Printf("arr[%d] = %d\n", i, arr[i])
	}

	// 7. 使用 range 遍历数组
	fmt.Println("\n使用 range 遍历数组:")
	for index, value := range arr {
		fmt.Printf("索引 %d: 值 %d\n", index, value)
	}

	// 8. 只获取索引
	fmt.Println("\n只获取索引:")
	for index := range arr {
		fmt.Printf("%d ", index)
	}
	fmt.Println()

	// 9. 只获取值（使用空白标识符 _ 忽略索引）
	fmt.Println("\n只获取值:")
	for _, value := range arr {
		fmt.Printf("%d ", value)
	}
	fmt.Println()

	// 10. 遍历切片
	fmt.Println("\n遍历切片:")
	slice := []string{"Go", "Python", "Java", "C++"}
	for i, lang := range slice {
		fmt.Printf("%d: %s\n", i, lang)
	}

	// 11. 遍历映射
	fmt.Println("\n遍历映射:")
	m := map[string]int{
		"apple":  5,
		"banana": 3,
		"orange": 7,
	}
	for key, value := range m {
		fmt.Printf("%s: %d\n", key, value)
	}

	// 12. 只遍历映射的键
	fmt.Println("\n只遍历键:")
	for key := range m {
		fmt.Printf("%s ", key)
	}
	fmt.Println()

	// 13. 遍历字符串
	fmt.Println("\n遍历字符串（按字符）:")
	str := "Hello, 世界"
	for i, char := range str {
		fmt.Printf("位置 %d: %c (Unicode: %U)\n", i, char, char)
	}

	// 14. 遍历字符串（按字节）
	fmt.Println("\n遍历字符串（按字节）:")
	for i := 0; i < len(str); i++ {
		fmt.Printf("%d ", str[i])
	}
	fmt.Println()

	// 15. 标签和 goto（不推荐，但可以用）
	fmt.Println("\n标签和 break:")
outer:
	for i := 0; i < 3; i++ {
		for j := 0; j < 3; j++ {
			if i*j >= 4 {
				fmt.Printf("在 i=%d, j=%d 处跳出\n", i, j)
				break outer // 跳出外层循环
			}
			fmt.Printf("(%d,%d) ", i, j)
		}
		fmt.Println()
	}

	// 16. 标签和 continue
	fmt.Println("\n标签和 continue:")
outer2:
	for i := 0; i < 3; i++ {
		for j := 0; j < 3; j++ {
			if j == 1 {
				continue outer2 // 继续外层循环的下一次迭代
			}
			fmt.Printf("(%d,%d) ", i, j)
		}
		fmt.Println()
	}
	fmt.Println()

	// 17. 使用循环计算
	fmt.Println("\n使用循环计算阶乘:")
	factorial := func(n int) int {
		result := 1
		for i := 1; i <= n; i++ {
			result *= i
		}
		return result
	}
	fmt.Printf("5! = %d\n", factorial(5))

	// 18. 使用循环查找
	fmt.Println("\n使用循环查找元素:")
	numbers := []int{3, 7, 11, 15, 19}
	target := 11
	found := false
	for i, num := range numbers {
		if num == target {
			fmt.Printf("找到 %d 在索引 %d 处\n", target, i)
			found = true
			break
		}
	}
	if !found {
		fmt.Printf("未找到 %d\n", target)
	}

	// 19. 倒序遍历
	fmt.Println("\n倒序遍历:")
	for i := len(numbers) - 1; i >= 0; i-- {
		fmt.Printf("%d ", numbers[i])
	}
	fmt.Println()

	// 20. 步长为 2 的循环
	fmt.Println("\n步长为 2:")
	for i := 0; i < 10; i += 2 {
		fmt.Printf("%d ", i)
	}
	fmt.Println()
}

func main() {
	DemoLoops()
}
