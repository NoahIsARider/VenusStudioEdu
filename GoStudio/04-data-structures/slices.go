package main

import "fmt"

// DemoSlices 演示 Go 语言的切片
func DemoSlices() {
	fmt.Println("\n=== 11. 切片 ===")

	// 1. 创建切片
	fmt.Println("\n1. 创建切片:")
	var slice1 []int
	fmt.Printf("nil 切片: %v, len=%d, cap=%d, is nil=%t\n",
		slice1, len(slice1), cap(slice1), slice1 == nil)

	slice2 := []int{1, 2, 3, 4, 5}
	fmt.Printf("字面量切片: %v, len=%d, cap=%d\n",
		slice2, len(slice2), cap(slice2))

	slice3 := make([]int, 3, 5) // 长度3，容量5
	fmt.Printf("make 创建: %v, len=%d, cap=%d\n",
		slice3, len(slice3), cap(slice3))

	// 2. 从数组创建切片
	fmt.Println("\n2. 从数组创建切片:")
	arr := [5]int{1, 2, 3, 4, 5}
	slice4 := arr[1:4] // 包含索引1,2,3，不包含4
	fmt.Printf("arr[1:4] = %v\n", slice4)
	slice5 := arr[:3]
	fmt.Printf("arr[:3] = %v\n", slice5)
	slice6 := arr[2:]
	fmt.Printf("arr[2:] = %v\n", slice6)

	// 3. 访问和修改切片元素
	fmt.Println("\n3. 访问和修改:")
	slice2[0] = 10
	fmt.Printf("修改后: %v\n", slice2)

	// 4. 追加元素
	fmt.Println("\n4. 追加元素:")
	slice7 := []int{1, 2, 3}
	fmt.Printf("原切片: %v, len=%d, cap=%d\n", slice7, len(slice7), cap(slice7))
	slice7 = append(slice7, 4)
	fmt.Printf("追加 4: %v, len=%d, cap=%d\n", slice7, len(slice7), cap(slice7))
	slice7 = append(slice7, 5, 6, 7)
	fmt.Printf("追加多个: %v, len=%d, cap=%d\n", slice7, len(slice7), cap(slice7))

	// 5. 合并切片
	fmt.Println("\n5. 合并切片:")
	s1 := []int{1, 2, 3}
	s2 := []int{4, 5, 6}
	s3 := append(s1, s2...)
	fmt.Printf("合并结果: %v\n", s3)

	// 6. 复制切片
	fmt.Println("\n6. 复制切片:")
	source := []int{1, 2, 3, 4, 5}
	dest := make([]int, len(source))
	n := copy(dest, source)
	fmt.Printf("源切片: %v\n", source)
	fmt.Printf("目标切片: %v, 复制了 %d 个元素\n", dest, n)

	// 7. 删除元素
	fmt.Println("\n7. 删除元素:")
	nums := []int{1, 2, 3, 4, 5}
	fmt.Printf("原切片: %v\n", nums)
	// 删除索引2的元素
	nums = append(nums[:2], nums[3:]...)
	fmt.Printf("删除索引2后: %v\n", nums)

	// 8. 插入元素
	fmt.Println("\n8. 插入元素:")
	nums = []int{1, 2, 4, 5}
	fmt.Printf("原切片: %v\n", nums)
	// 在索引2插入3
	index := 2
	nums = append(nums[:index], append([]int{3}, nums[index:]...)...)
	fmt.Printf("插入3后: %v\n", nums)

	// 9. 切片的切片
	fmt.Println("\n9. 切片的切片:")
	original := []int{0, 1, 2, 3, 4, 5}
	sub := original[1:4]
	fmt.Printf("原切片: %v\n", original)
	fmt.Printf("子切片: %v\n", sub)
	sub[0] = 99
	fmt.Printf("修改子切片后，原切片: %v\n", original)
	fmt.Println("（共享底层数组）")

	// 10. 独立的切片副本
	fmt.Println("\n10. 创建独立副本:")
	original2 := []int{1, 2, 3, 4, 5}
	independent := make([]int, len(original2))
	copy(independent, original2)
	independent[0] = 99
	fmt.Printf("原切片: %v\n", original2)
	fmt.Printf("独立副本: %v\n", independent)

	// 11. 二维切片
	fmt.Println("\n11. 二维切片:")
	matrix := [][]int{
		{1, 2, 3},
		{4, 5, 6},
		{7, 8, 9},
	}
	fmt.Println("矩阵:")
	for i, row := range matrix {
		fmt.Printf("第 %d 行: %v\n", i, row)
	}

	// 12. 动态二维切片
	fmt.Println("\n12. 动态二维切片:")
	rows, cols := 3, 4
	matrix2 := make([][]int, rows)
	for i := range matrix2 {
		matrix2[i] = make([]int, cols)
	}
	// 填充数据
	count := 1
	for i := 0; i < rows; i++ {
		for j := 0; j < cols; j++ {
			matrix2[i][j] = count
			count++
		}
	}
	fmt.Println("3x4 矩阵:")
	for _, row := range matrix2 {
		fmt.Println(row)
	}

	// 13. 切片作为函数参数
	fmt.Println("\n13. 切片作为参数:")
	testSlice := []int{1, 2, 3}
	fmt.Printf("原切片: %v\n", testSlice)
	modifySlice(testSlice)
	fmt.Printf("修改后: %v （引用传递）\n", testSlice)

	// 14. nil 切片 vs 空切片
	fmt.Println("\n14. nil 切片 vs 空切片:")
	var nilSlice []int
	emptySlice := []int{}
	fmt.Printf("nil 切片: %v, is nil=%t, len=%d\n",
		nilSlice, nilSlice == nil, len(nilSlice))
	fmt.Printf("空切片: %v, is nil=%t, len=%d\n",
		emptySlice, emptySlice == nil, len(emptySlice))
}

// 修改切片（切片是引用类型）
func modifySlice(s []int) {
	if len(s) > 0 {
		s[0] = 100
	}
}

func main() {
	DemoSlices()
}
