package main

import "fmt"

// DemoOperators 演示 Go 语言的运算符
func DemoOperators() {
	fmt.Println("\n=== 3. 运算符 ===")

	// 1. 算术运算符
	fmt.Println("\n算术运算符:")
	a, b := 10, 3
	fmt.Printf("a = %d, b = %d\n", a, b)
	fmt.Printf("加法: a + b = %d\n", a+b)
	fmt.Printf("减法: a - b = %d\n", a-b)
	fmt.Printf("乘法: a * b = %d\n", a*b)
	fmt.Printf("除法: a / b = %d\n", a/b)
	fmt.Printf("取余: a %% b = %d\n", a%b)

	// 自增自减
	counter := 0
	counter++ // 只支持后缀形式
	fmt.Printf("自增: counter++ = %d\n", counter)
	counter-- // 只支持后缀形式
	fmt.Printf("自减: counter-- = %d\n", counter)

	// 2. 比较运算符
	fmt.Println("\n比较运算符:")
	x, y := 5, 10
	fmt.Printf("x = %d, y = %d\n", x, y)
	fmt.Printf("x == y: %t\n", x == y)
	fmt.Printf("x != y: %t\n", x != y)
	fmt.Printf("x < y:  %t\n", x < y)
	fmt.Printf("x <= y: %t\n", x <= y)
	fmt.Printf("x > y:  %t\n", x > y)
	fmt.Printf("x >= y: %t\n", x >= y)

	// 3. 逻辑运算符
	fmt.Println("\n逻辑运算符:")
	p, q := true, false
	fmt.Printf("p = %t, q = %t\n", p, q)
	fmt.Printf("p && q (与): %t\n", p && q)
	fmt.Printf("p || q (或): %t\n", p || q)
	fmt.Printf("!p (非):     %t\n", !p)

	// 4. 位运算符
	fmt.Println("\n位运算符:")
	m, n := 12, 5 // 二进制: 1100 和 0101
	fmt.Printf("m = %d (二进制: %04b), n = %d (二进制: %04b)\n", m, m, n, n)
	fmt.Printf("m & n  (按位与): %d (二进制: %04b)\n", m&n, m&n)
	fmt.Printf("m | n  (按位或): %d (二进制: %04b)\n", m|n, m|n)
	fmt.Printf("m ^ n  (按位异或): %d (二进制: %04b)\n", m^n, m^n)
	fmt.Printf("^m     (按位取反): %d (二进制: %b)\n", ^m, ^m)
	fmt.Printf("m << 2 (左移): %d (二进制: %06b)\n", m<<2, m<<2)
	fmt.Printf("m >> 2 (右移): %d (二进制: %02b)\n", m>>2, m>>2)

	// 5. 赋值运算符
	fmt.Println("\n赋值运算符:")
	num := 10
	fmt.Printf("初始值: num = %d\n", num)
	num += 5
	fmt.Printf("num += 5: %d\n", num)
	num -= 3
	fmt.Printf("num -= 3: %d\n", num)
	num *= 2
	fmt.Printf("num *= 2: %d\n", num)
	num /= 4
	fmt.Printf("num /= 4: %d\n", num)
	num %= 5
	fmt.Printf("num %%= 5: %d\n", num)

	// 位赋值运算符
	val := 8 // 二进制: 1000
	fmt.Printf("\n初始值: val = %d (二进制: %04b)\n", val, val)
	val &= 12 // 1000 & 1100 = 1000
	fmt.Printf("val &= 12: %d (二进制: %04b)\n", val, val)
	val |= 4 // 1000 | 0100 = 1100
	fmt.Printf("val |= 4:  %d (二进制: %04b)\n", val, val)
	val ^= 6 // 1100 ^ 0110 = 1010
	fmt.Printf("val ^= 6:  %d (二进制: %04b)\n", val, val)
	val <<= 1 // 1010 << 1 = 10100
	fmt.Printf("val <<= 1: %d (二进制: %05b)\n", val, val)
	val >>= 2 // 10100 >> 2 = 101
	fmt.Printf("val >>= 2: %d (二进制: %03b)\n", val, val)

	// 6. 取地址和指针运算符
	fmt.Println("\n取地址和指针运算符:")
	value := 42
	ptr := &value
	fmt.Printf("value = %d, 地址 = %p\n", value, &value)
	fmt.Printf("ptr = %p, *ptr = %d\n", ptr, *ptr)

	// 7. 运算符优先级示例
	fmt.Println("\n运算符优先级:")
	result := 2 + 3*4 - 8/2
	fmt.Printf("2 + 3*4 - 8/2 = %d\n", result)
	result = (2 + 3) * (4 - 8) / 2
	fmt.Printf("(2 + 3) * (4 - 8) / 2 = %d\n", result)

	// 8. 短路求值
	fmt.Println("\n短路求值:")
	fmt.Println("逻辑与(&&)短路: false && (会被跳过的表达式)")
	if false && printAndReturnTrue() {
		fmt.Println("这不会执行")
	}
	fmt.Println("逻辑或(||)短路: true || (会被跳过的表达式)")
	if true || printAndReturnFalse() {
		fmt.Println("这会执行，但 printAndReturnFalse 不会被调用")
	}
}

func printAndReturnTrue() bool {
	fmt.Println("printAndReturnTrue 被调用")
	return true
}

func printAndReturnFalse() bool {
	fmt.Println("printAndReturnFalse 被调用")
	return false
}

func main() {
	DemoOperators()
}
