package main

import (
	"fmt"
	"math"
)

// DemoMethods 演示 Go 语言的方法
func DemoMethods() {
	fmt.Println("\n=== 14. 方法 ===")

	// 1. 基本方法定义
	fmt.Println("\n1. 基本方法:")
	type Rectangle struct {
		Width, Height float64
	}

	// 值接收者方法
	rect := Rectangle{Width: 10, Height: 5}
	fmt.Printf("矩形: %+v\n", rect)
	fmt.Printf("面积: %.2f\n", rect.Area())
	fmt.Printf("周长: %.2f\n", rect.Perimeter())

	// 2. 指针接收者方法
	fmt.Println("\n2. 指针接收者方法:")
	rect.Scale(2)
	fmt.Printf("放大2倍后: %+v\n", rect)
	fmt.Printf("新面积: %.2f\n", rect.Area())

	// 3. 值接收者 vs 指针接收者
	fmt.Println("\n3. 值接收者 vs 指针接收者:")
	r1 := Rectangle{Width: 5, Height: 3}
	r1.TryModifyValue() // 不会改变
	fmt.Printf("值接收者尝试修改: %+v\n", r1)
	r1.ModifyPointer() // 会改变
	fmt.Printf("指针接收者修改: %+v\n", r1)

	// 4. 非结构体类型的方法
	fmt.Println("\n4. 自定义类型的方法:")
	type MyInt int
	var num MyInt = 10
	fmt.Printf("原值: %d\n", num)
	fmt.Printf("双倍: %d\n", num.Double())
	fmt.Printf("是否为偶数: %t\n", num.IsEven())

	// 5. 方法链
	fmt.Println("\n5. 方法链:")
	builder := &StringBuilder{}
	result := builder.
		Append("Hello").
		Append(" ").
		Append("World").
		String()
	fmt.Printf("构建的字符串: %s\n", result)

	// 6. 多个类型的方法
	fmt.Println("\n6. 多个类型的方法:")
	circle := Circle{Radius: 5}
	rect2 := Rectangle{Width: 4, Height: 6}
	fmt.Printf("圆形面积: %.2f\n", circle.Area())
	fmt.Printf("矩形面积: %.2f\n", rect2.Area())

	// 7. 匿名字段的方法提升
	fmt.Println("\n7. 方法提升:")
	type Person struct {
		Name string
		Age  int
	}
	type Employee struct {
		Person // 匿名字段
		Salary float64
	}
	emp := Employee{
		Person: Person{Name: "Alice", Age: 30},
		Salary: 50000,
	}
	fmt.Printf("员工信息: %s\n", emp.Info())

	// 8. 方法表达式
	fmt.Println("\n8. 方法表达式:")
	areaFunc := Rectangle.Area
	r := Rectangle{Width: 5, Height: 3}
	fmt.Printf("方法表达式调用: %.2f\n", areaFunc(r))

	// 9. 方法值
	fmt.Println("\n9. 方法值:")
	r2 := Rectangle{Width: 8, Height: 4}
	areaMethod := r2.Area
	fmt.Printf("方法值调用: %.2f\n", areaMethod())
}

// Rectangle 类型
type Rectangle struct {
	Width, Height float64
}

// 值接收者方法 - 计算面积
func (r Rectangle) Area() float64 {
	return r.Width * r.Height
}

// 值接收者方法 - 计算周长
func (r Rectangle) Perimeter() float64 {
	return 2 * (r.Width + r.Height)
}

// 指针接收者方法 - 缩放
func (r *Rectangle) Scale(factor float64) {
	r.Width *= factor
	r.Height *= factor
}

// 值接收者尝试修改（不会生效）
func (r Rectangle) TryModifyValue() {
	r.Width = 100
	r.Height = 100
}

// 指针接收者修改（会生效）
func (r *Rectangle) ModifyPointer() {
	r.Width = 100
	r.Height = 100
}

// Circle 类型
type Circle struct {
	Radius float64
}

// Circle 的面积方法
func (c Circle) Area() float64 {
	return math.Pi * c.Radius * c.Radius
}

// 自定义整数类型
type MyInt int

// MyInt 的方法
func (m MyInt) Double() MyInt {
	return m * 2
}

func (m MyInt) IsEven() bool {
	return m%2 == 0
}

// 字符串构建器
type StringBuilder struct {
	data string
}

// 链式方法
func (sb *StringBuilder) Append(s string) *StringBuilder {
	sb.data += s
	return sb
}

func (sb *StringBuilder) String() string {
	return sb.data
}

// Person 类型
type Person struct {
	Name string
	Age  int
}

// Person 的方法
func (p Person) Info() string {
	return fmt.Sprintf("%s, %d 岁", p.Name, p.Age)
}

// Employee 包含匿名 Person 字段
type Employee struct {
	Person
	Salary float64
}

func main() {
	DemoMethods()
}
