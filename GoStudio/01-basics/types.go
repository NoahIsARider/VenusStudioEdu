package main

import (
	"fmt"
	"unsafe"
)

// DemoTypes 演示 Go 语言的数据类型
func DemoTypes() {
	fmt.Println("\n=== 2. 数据类型 ===")

	// 1. 布尔类型
	var isActive bool = true
	var isCompleted bool = false
	fmt.Printf("布尔类型: isActive=%t, isCompleted=%t\n", isActive, isCompleted)

	// 2. 整数类型
	var int8Num int8 = 127        // -128 到 127
	var int16Num int16 = 32767    // -32768 到 32767
	var int32Num int32 = 2147483647
	var int64Num int64 = 9223372036854775807
	fmt.Printf("有符号整数: int8=%d, int16=%d, int32=%d, int64=%d\n",
		int8Num, int16Num, int32Num, int64Num)

	var uint8Num uint8 = 255       // 0 到 255
	var uint16Num uint16 = 65535   // 0 到 65535
	var uint32Num uint32 = 4294967295
	var uint64Num uint64 = 18446744073709551615
	fmt.Printf("无符号整数: uint8=%d, uint16=%d, uint32=%d, uint64=%d\n",
		uint8Num, uint16Num, uint32Num, uint64Num)

	// 3. 浮点数类型
	var float32Num float32 = 3.14159
	var float64Num float64 = 3.141592653589793
	fmt.Printf("浮点数: float32=%.5f, float64=%.15f\n", float32Num, float64Num)

	// 4. 复数类型
	var complex64Num complex64 = 1 + 2i
	var complex128Num complex128 = 2 + 3i
	fmt.Printf("复数: complex64=%v, complex128=%v\n", complex64Num, complex128Num)
	fmt.Printf("复数实部和虚部: real(%.0f), imag(%.0f)\n",
		real(complex128Num), imag(complex128Num))

	// 5. 字符串类型
	var str string = "Hello, Go! 你好，Go！"
	fmt.Printf("字符串: %s\n", str)
	fmt.Printf("字符串长度(字节数): %d\n", len(str))

	// 字符串是不可变的
	// str[0] = 'h' // 这会报错

	// 多行字符串
	multiline := `这是一个
多行字符串
可以包含换行符`
	fmt.Printf("多行字符串:\n%s\n", multiline)

	// 6. 字符类型
	var char1 rune = '中' // rune 是 int32 的别名，用于表示 Unicode 字符
	var char2 byte = 'A'  // byte 是 uint8 的别名，用于表示 ASCII 字符
	fmt.Printf("字符: rune='%c'(%d), byte='%c'(%d)\n", char1, char1, char2, char2)

	// 7. 指针类型
	var num int = 42
	var ptr *int = &num // & 取地址，* 声明指针
	fmt.Printf("指针: num=%d, ptr=%p, *ptr=%d\n", num, ptr, *ptr)
	*ptr = 100 // 通过指针修改值
	fmt.Printf("通过指针修改后: num=%d\n", num)

	// 8. 数组类型（固定长度）
	var arr [3]int = [3]int{1, 2, 3}
	fmt.Printf("数组: %v, 长度: %d\n", arr, len(arr))

	// 9. 切片类型（动态数组）
	slice := []int{1, 2, 3, 4, 5}
	fmt.Printf("切片: %v, 长度: %d, 容量: %d\n", slice, len(slice), cap(slice))

	// 10. 映射类型（哈希表）
	m := map[string]int{
		"apple":  1,
		"banana": 2,
		"orange": 3,
	}
	fmt.Printf("映射: %v\n", m)

	// 11. 结构体类型
	type Person struct {
		Name string
		Age  int
	}
	person := Person{Name: "Alice", Age: 30}
	fmt.Printf("结构体: %v\n", person)

	// 12. 接口类型
	var any interface{} // 空接口可以存储任意类型的值
	any = 42
	fmt.Printf("接口存储 int: %v\n", any)
	any = "Hello"
	fmt.Printf("接口存储 string: %v\n", any)

	// 13. 函数类型
	var addFunc func(int, int) int
	addFunc = func(a, b int) int {
		return a + b
	}
	fmt.Printf("函数类型: addFunc(3, 4) = %d\n", addFunc(3, 4))

	// 14. 通道类型（用于并发通信）
	ch := make(chan int)
	go func() {
		ch <- 42 // 发送数据到通道
	}()
	value := <-ch // 从通道接收数据
	fmt.Printf("通道: 接收到的值 = %d\n", value)

	// 15. 类型大小
	fmt.Println("\n类型大小（字节）:")
	fmt.Printf("bool: %d, int8: %d, int16: %d, int32: %d, int64: %d\n",
		unsafe.Sizeof(isActive), unsafe.Sizeof(int8Num), unsafe.Sizeof(int16Num),
		unsafe.Sizeof(int32Num), unsafe.Sizeof(int64Num))
	fmt.Printf("float32: %d, float64: %d\n",
		unsafe.Sizeof(float32Num), unsafe.Sizeof(float64Num))
	fmt.Printf("string: %d, slice: %d, map: %d\n",
		unsafe.Sizeof(str), unsafe.Sizeof(slice), unsafe.Sizeof(m))
}

func main() {
	DemoTypes()
}
