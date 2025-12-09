package main

import (
	"fmt"
	"math"
)

// DemoInterfaces 演示 Go 语言的接口
func DemoInterfaces() {
	fmt.Println("\n=== 15. 接口 ===")

	// 1. 基本接口
	fmt.Println("\n1. 基本接口:")
	var s Shape
	s = Circle{Radius: 5}
	fmt.Printf("圆形: 面积=%.2f, 周长=%.2f\n", s.Area(), s.Perimeter())

	s = Rectangle{Width: 4, Height: 6}
	fmt.Printf("矩形: 面积=%.2f, 周长=%.2f\n", s.Area(), s.Perimeter())

	// 2. 接口值
	fmt.Println("\n2. 接口值:")
	printShapeInfo(Circle{Radius: 3})
	printShapeInfo(Rectangle{Width: 5, Height: 2})

	// 3. 空接口
	fmt.Println("\n3. 空接口:")
	var any interface{}
	any = 42
	fmt.Printf("存储整数: %v (类型: %T)\n", any, any)
	any = "Hello"
	fmt.Printf("存储字符串: %v (类型: %T)\n", any, any)
	any = Circle{Radius: 10}
	fmt.Printf("存储结构体: %v (类型: %T)\n", any, any)

	// 4. 类型断言
	fmt.Println("\n4. 类型断言:")
	var i interface{} = "hello"
	s1, ok := i.(string)
	if ok {
		fmt.Printf("成功断言为 string: %s\n", s1)
	}
	n, ok := i.(int)
	if !ok {
		fmt.Printf("断言为 int 失败，得到零值: %d\n", n)
	}

	// 5. 类型选择
	fmt.Println("\n5. 类型选择:")
	checkType(42)
	checkType("Go")
	checkType(3.14)
	checkType(true)
	checkType([]int{1, 2, 3})

	// 6. 接口组合
	fmt.Println("\n6. 接口组合:")
	var rw ReadWriter = &File{name: "test.txt"}
	rw.Read()
	rw.Write("Hello, World!")

	// 7. 多个接口实现
	fmt.Println("\n7. 多个接口实现:")
	dog := Dog{Name: "Buddy"}
	cat := Cat{Name: "Whiskers"}
	
	fmt.Print("狗: ")
	dog.Speak()
	dog.Move()
	
	fmt.Print("猫: ")
	cat.Speak()
	cat.Move()

	// 8. 接口的零值
	fmt.Println("\n8. 接口的零值:")
	var nilShape Shape
	fmt.Printf("nil 接口: %v, is nil=%t\n", nilShape, nilShape == nil)

	// 9. 接口切片
	fmt.Println("\n9. 接口切片:")
	shapes := []Shape{
		Circle{Radius: 5},
		Rectangle{Width: 4, Height: 3},
		Circle{Radius: 7},
	}
	totalArea := 0.0
	for i, shape := range shapes {
		area := shape.Area()
		fmt.Printf("图形 %d: 面积=%.2f\n", i+1, area)
		totalArea += area
	}
	fmt.Printf("总面积: %.2f\n", totalArea)

	// 10. 实现多个接口
	fmt.Println("\n10. 实现多个接口:")
	var animal Animal = Dog{Name: "Max"}
	var mover Mover = Dog{Name: "Max"}
	animal.Speak()
	mover.Move()

	// 11. Stringer 接口
	fmt.Println("\n11. Stringer 接口:")
	p := Person{Name: "Alice", Age: 30}
	fmt.Println(p) // 自动调用 String() 方法

	// 12. 接口的实际应用
	fmt.Println("\n12. 排序接口应用:")
	students := StudentList{
		{Name: "Bob", Score: 85},
		{Name: "Alice", Score: 92},
		{Name: "Carol", Score: 78},
	}
	fmt.Printf("排序前: %v\n", students)
	sortStudents(students)
	fmt.Printf("排序后: %v\n", students)
}

// Shape 接口
type Shape interface {
	Area() float64
	Perimeter() float64
}

// Circle 实现 Shape
type Circle struct {
	Radius float64
}

func (c Circle) Area() float64 {
	return math.Pi * c.Radius * c.Radius
}

func (c Circle) Perimeter() float64 {
	return 2 * math.Pi * c.Radius
}

// Rectangle 实现 Shape
type Rectangle struct {
	Width, Height float64
}

func (r Rectangle) Area() float64 {
	return r.Width * r.Height
}

func (r Rectangle) Perimeter() float64 {
	return 2 * (r.Width + r.Height)
}

// 打印图形信息
func printShapeInfo(s Shape) {
	fmt.Printf("类型: %T, 面积: %.2f, 周长: %.2f\n",
		s, s.Area(), s.Perimeter())
}

// 类型检查
func checkType(i interface{}) {
	switch v := i.(type) {
	case int:
		fmt.Printf("整数: %d\n", v)
	case string:
		fmt.Printf("字符串: %s\n", v)
	case float64:
		fmt.Printf("浮点数: %.2f\n", v)
	case bool:
		fmt.Printf("布尔值: %t\n", v)
	default:
		fmt.Printf("其他类型: %T, 值: %v\n", v, v)
	}
}

// 接口组合
type Reader interface {
	Read() string
}

type Writer interface {
	Write(data string)
}

type ReadWriter interface {
	Reader
	Writer
}

// File 实现 ReadWriter
type File struct {
	name string
}

func (f *File) Read() string {
	fmt.Printf("从 %s 读取数据\n", f.name)
	return "file content"
}

func (f *File) Write(data string) {
	fmt.Printf("向 %s 写入: %s\n", f.name, data)
}

// Animal 和 Mover 接口
type Animal interface {
	Speak()
}

type Mover interface {
	Move()
}

// Dog 实现两个接口
type Dog struct {
	Name string
}

func (d Dog) Speak() {
	fmt.Printf("%s: 汪汪!\n", d.Name)
}

func (d Dog) Move() {
	fmt.Printf("%s 在跑\n", d.Name)
}

// Cat 实现两个接口
type Cat struct {
	Name string
}

func (c Cat) Speak() {
	fmt.Printf("%s: 喵喵!\n", c.Name)
}

func (c Cat) Move() {
	fmt.Printf("%s 在走\n", c.Name)
}

// Person 实现 Stringer 接口
type Person struct {
	Name string
	Age  int
}

func (p Person) String() string {
	return fmt.Sprintf("Person{Name: %s, Age: %d}", p.Name, p.Age)
}

// 学生排序示例
type Student struct {
	Name  string
	Score int
}

type StudentList []Student

func (s StudentList) Len() int {
	return len(s)
}

func (s StudentList) Less(i, j int) bool {
	return s[i].Score > s[j].Score // 按分数降序
}

func (s StudentList) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

// 简单的排序实现
func sortStudents(students StudentList) {
	n := len(students)
	for i := 0; i < n-1; i++ {
		for j := 0; j < n-i-1; j++ {
			if students.Less(j+1, j) {
				students.Swap(j, j+1)
			}
		}
	}
}

func main() {
	DemoInterfaces()
}
