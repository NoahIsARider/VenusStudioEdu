package main

import "fmt"

// DemoArrays 演示 Go 语言的数组
func DemoArrays() {
	fmt.Println("\n=== 10. 数组 ===")

	// 1. 声明和初始化数组
	fmt.Println("\n1. 数组声明:")
	var arr1 [5]int
	fmt.Printf("未初始化的数组: %v\n", arr1)

	arr2 := [5]int{1, 2, 3, 4, 5}
	fmt.Printf("初始化的数组: %v\n", arr2)

	arr3 := [...]int{1, 2, 3}
	fmt.Printf("自动推断长度: %v\n", arr3)

	// 2. 访问数组元素
	fmt.Println("\n2. 访问数组元素:")
	fmt.Printf("arr2[0] = %d\n", arr2[0])
	fmt.Printf("arr2[4] = %d\n", arr2[4])

	// 3. 修改数组元素
	fmt.Println("\n3. 修改数组元素:")
	arr2[0] = 10
	fmt.Printf("修改后: %v\n", arr2)

	// 4. 数组长度
	fmt.Println("\n4. 数组长度:")
	fmt.Printf("len(arr2) = %d\n", len(arr2))

	// 5. 遍历数组
	fmt.Println("\n5. 遍历数组:")
	for i := 0; i < len(arr2); i++ {
		fmt.Printf("arr2[%d] = %d\n", i, arr2[i])
	}

	// 6. 使用 range 遍历
	fmt.Println("\n6. 使用 range 遍历:")
	for index, value := range arr2 {
		fmt.Printf("索引 %d: 值 %d\n", index, value)
	}

	// 7. 多维数组
	fmt.Println("\n7. 多维数组:")
	matrix := [3][3]int{
		{1, 2, 3},
		{4, 5, 6},
		{7, 8, 9},
	}
	fmt.Println("3x3 矩阵:")
	for i := 0; i < 3; i++ {
		for j := 0; j < 3; j++ {
			fmt.Printf("%d ", matrix[i][j])
		}
		fmt.Println()
	}

	// 8. 数组比较
	fmt.Println("\n8. 数组比较:")
	a1 := [3]int{1, 2, 3}
	a2 := [3]int{1, 2, 3}
	a3 := [3]int{1, 2, 4}
	fmt.Printf("a1 == a2: %t\n", a1 == a2)
	fmt.Printf("a1 == a3: %t\n", a1 == a3)

	// 9. 数组作为参数（值传递）
	fmt.Println("\n9. 数组作为参数:")
	original := [3]int{1, 2, 3}
	fmt.Printf("原数组: %v\n", original)
	modifyArray(original)
	fmt.Printf("调用函数后: %v （没有改变）\n", original)

	// 10. 数组指针作为参数
	fmt.Println("\n10. 数组指针作为参数:")
	modifyArrayPtr(&original)
	fmt.Printf("使用指针修改后: %v\n", original)
}

// 数组作为参数（值传递，不会修改原数组）
func modifyArray(arr [3]int) {
	arr[0] = 100
	fmt.Printf("函数内: %v\n", arr)
}

// 使用数组指针
func modifyArrayPtr(arr *[3]int) {
	arr[0] = 100
	fmt.Printf("函数内: %v\n", arr)
}

func main() {
	DemoArrays()
}
