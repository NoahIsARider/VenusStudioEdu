package main

import "fmt"

// DemoPointers 演示 Go 语言的指针
func DemoPointers() {
	fmt.Println("\n=== 21. 指针 ===")

	// 1. 基本指针概念
	fmt.Println("\n1. 基本指针:")
	num := 42
	ptr := &num // 取地址
	fmt.Printf("num 的值: %d\n", num)
	fmt.Printf("num 的地址: %p\n", &num)
	fmt.Printf("ptr 的值（地址）: %p\n", ptr)
	fmt.Printf("ptr 指向的值: %d\n", *ptr) // 解引用

	// 2. 通过指针修改值
	fmt.Println("\n2. 通过指针修改值:")
	*ptr = 100
	fmt.Printf("修改后 num 的值: %d\n", num)

	// 3. 指针作为函数参数
	fmt.Println("\n3. 指针作为参数:")
	x := 10
	fmt.Printf("调用前: x = %d\n", x)
	increment(&x)
	fmt.Printf("调用后: x = %d\n", x)

	// 4. 值传递 vs 指针传递
	fmt.Println("\n4. 值传递 vs 指针传递:")
	a := 5
	modifyValue(a)
	fmt.Printf("值传递后: a = %d （未改变）\n", a)
	modifyPointer(&a)
	fmt.Printf("指针传递后: a = %d （已改变）\n", a)

	// 5. 指针的零值
	fmt.Println("\n5. 指针的零值:")
	var p *int
	fmt.Printf("nil 指针: %v, is nil: %t\n", p, p == nil)

	// 6. new 函数
	fmt.Println("\n6. 使用 new 创建指针:")
	p2 := new(int)
	fmt.Printf("new(int) 的值: %d, 地址: %p\n", *p2, p2)
	*p2 = 42
	fmt.Printf("赋值后: %d\n", *p2)

	// 7. 结构体指针
	fmt.Println("\n7. 结构体指针:")
	person := Person{Name: "Alice", Age: 30}
	personPtr := &person
	fmt.Printf("原始: %+v\n", person)
	personPtr.Age = 31 // 自动解引用
	fmt.Printf("修改后: %+v\n", person)

	// 8. 指针与数组
	fmt.Println("\n8. 指针与数组:")
	arr := [3]int{1, 2, 3}
	arrPtr := &arr
	fmt.Printf("数组: %v\n", arr)
	arrPtr[0] = 10
	fmt.Printf("通过指针修改: %v\n", arr)

	// 9. 指针与切片
	fmt.Println("\n9. 指针与切片:")
	slice := []int{1, 2, 3}
	modifySlice(slice)
	fmt.Printf("修改后的切片: %v\n", slice)

	// 10. 指针数组
	fmt.Println("\n10. 指针数组:")
	n1, n2, n3 := 1, 2, 3
	ptrArr := []*int{&n1, &n2, &n3}
	for i, p := range ptrArr {
		fmt.Printf("ptrArr[%d] -> %d\n", i, *p)
	}
	*ptrArr[0] = 10
	fmt.Printf("修改后 n1 = %d\n", n1)

	// 11. 指针与方法
	fmt.Println("\n11. 指针接收者方法:")
	rect := Rectangle{Width: 5, Height: 3}
	fmt.Printf("原始: %+v\n", rect)
	rect.Scale(2)
	fmt.Printf("缩放后: %+v\n", rect)

	// 12. 指针比较
	fmt.Println("\n12. 指针比较:")
	v1 := 10
	v2 := 10
	ptr1 := &v1
	ptr2 := &v2
	ptr3 := &v1
	fmt.Printf("ptr1 == ptr2: %t （指向不同地址）\n", ptr1 == ptr2)
	fmt.Printf("ptr1 == ptr3: %t （指向相同地址）\n", ptr1 == ptr3)

	// 13. 指针的指针
	fmt.Println("\n13. 指针的指针:")
	val := 42
	ptr := &val
	ptrPtr := &ptr
	fmt.Printf("val: %d\n", val)
	fmt.Printf("*ptr: %d\n", *ptr)
	fmt.Printf("**ptrPtr: %d\n", **ptrPtr)

	// 14. 什么时候使用指针
	fmt.Println("\n14. 使用指针的场景:")
	fmt.Println("- 需要修改原始数据")
	fmt.Println("- 避免大型结构体的复制")
	fmt.Println("- 实现方法时修改接收者")
	fmt.Println("- nil 值有特殊意义")
}

type Person struct {
	Name string
	Age  int
}

type Rectangle struct {
	Width, Height int
}

// 指针接收者方法
func (r *Rectangle) Scale(factor int) {
	r.Width *= factor
	r.Height *= factor
}

// 通过指针修改值
func increment(n *int) {
	*n++
}

// 值传递
func modifyValue(n int) {
	n = 100
}

// 指针传递
func modifyPointer(n *int) {
	*n = 100
}

// 修改切片（切片本身包含指针）
func modifySlice(s []int) {
	if len(s) > 0 {
		s[0] = 100
	}
}

func main() {
	DemoPointers()
}
