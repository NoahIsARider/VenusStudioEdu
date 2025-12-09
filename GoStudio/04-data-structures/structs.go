package main

import (
	"fmt"
	"encoding/json"
)

// DemoStructs 演示 Go 语言的结构体
func DemoStructs() {
	fmt.Println("\n=== 13. 结构体 ===")

	// 1. 定义和初始化结构体
	fmt.Println("\n1. 定义和初始化:")
	type Person struct {
		Name string
		Age  int
		City string
	}

	var p1 Person
	fmt.Printf("零值结构体: %+v\n", p1)

	p2 := Person{Name: "Alice", Age: 30, City: "北京"}
	fmt.Printf("完整初始化: %+v\n", p2)

	p3 := Person{Name: "Bob", Age: 25}
	fmt.Printf("部分初始化: %+v\n", p3)

	p4 := Person{"Carol", 28, "上海"}
	fmt.Printf("按顺序初始化: %+v\n", p4)

	// 2. 访问和修改字段
	fmt.Println("\n2. 访问和修改字段:")
	fmt.Printf("姓名: %s, 年龄: %d\n", p2.Name, p2.Age)
	p2.Age = 31
	fmt.Printf("修改后: %+v\n", p2)

	// 3. 匿名结构体
	fmt.Println("\n3. 匿名结构体:")
	point := struct {
		X, Y int
	}{10, 20}
	fmt.Printf("点: %+v\n", point)

	// 4. 结构体指针
	fmt.Println("\n4. 结构体指针:")
	p5 := &Person{Name: "David", Age: 35}
	fmt.Printf("指针: %+v\n", p5)
	fmt.Printf("访问字段: %s\n", p5.Name) // 自动解引用
	p5.Age = 36
	fmt.Printf("修改后: %+v\n", p5)

	// 5. 嵌套结构体
	fmt.Println("\n5. 嵌套结构体:")
	type Address struct {
		City    string
		Country string
	}
	type Employee struct {
		Name    string
		Age     int
		Address Address
	}
	emp := Employee{
		Name: "Eve",
		Age:  28,
		Address: Address{
			City:    "深圳",
			Country: "中国",
		},
	}
	fmt.Printf("员工: %+v\n", emp)
	fmt.Printf("城市: %s\n", emp.Address.City)

	// 6. 匿名字段（嵌入）
	fmt.Println("\n6. 匿名字段:")
	type Contact struct {
		Email string
		Phone string
	}
	type User struct {
		Name string
		Age  int
		Contact // 匿名字段
	}
	user := User{
		Name: "Frank",
		Age:  30,
		Contact: Contact{
			Email: "frank@example.com",
			Phone: "123-456-7890",
		},
	}
	fmt.Printf("用户: %+v\n", user)
	fmt.Printf("邮箱: %s\n", user.Email) // 可以直接访问

	// 7. 结构体比较
	fmt.Println("\n7. 结构体比较:")
	type Point struct {
		X, Y int
	}
	pt1 := Point{1, 2}
	pt2 := Point{1, 2}
	pt3 := Point{2, 3}
	fmt.Printf("pt1 == pt2: %t\n", pt1 == pt2)
	fmt.Printf("pt1 == pt3: %t\n", pt1 == pt3)

	// 8. 结构体作为函数参数（值传递）
	fmt.Println("\n8. 结构体作为参数（值传递）:")
	original := Person{Name: "Grace", Age: 25}
	fmt.Printf("原结构体: %+v\n", original)
	modifyPerson(original)
	fmt.Printf("调用后: %+v （未改变）\n", original)

	// 9. 结构体指针作为参数
	fmt.Println("\n9. 结构体指针作为参数:")
	modifyPersonPtr(&original)
	fmt.Printf("使用指针修改后: %+v\n", original)

	// 10. 结构体标签
	fmt.Println("\n10. 结构体标签（JSON）:")
	type Product struct {
		ID    int    `json:"id"`
		Name  string `json:"name"`
		Price float64 `json:"price"`
	}
	product := Product{ID: 1, Name: "笔记本电脑", Price: 5999.99}
	jsonData, _ := json.Marshal(product)
	fmt.Printf("JSON: %s\n", string(jsonData))

	// 11. 结构体方法将在下一个文件中详细介绍
	fmt.Println("\n11. 结构体方法预告:")
	fmt.Println("结构体方法将在 05-methods 模块中详细介绍")

	// 12. 结构体切片
	fmt.Println("\n12. 结构体切片:")
	people := []Person{
		{Name: "Alice", Age: 30, City: "北京"},
		{Name: "Bob", Age: 25, City: "上海"},
		{Name: "Carol", Age: 28, City: "广州"},
	}
	for i, person := range people {
		fmt.Printf("%d: %s, %d 岁, %s\n", i, person.Name, person.Age, person.City)
	}

	// 13. 结构体映射
	fmt.Println("\n13. 结构体映射:")
	employeeMap := map[int]Employee{
		1: {Name: "Alice", Age: 30, Address: Address{City: "北京", Country: "中国"}},
		2: {Name: "Bob", Age: 25, Address: Address{City: "上海", Country: "中国"}},
	}
	for id, emp := range employeeMap {
		fmt.Printf("ID %d: %s\n", id, emp.Name)
	}

	// 14. 空结构体
	fmt.Println("\n14. 空结构体:")
	type Empty struct{}
	e := Empty{}
	fmt.Printf("空结构体: %+v, 大小: %d 字节\n", e, 0)
	fmt.Println("空结构体常用于信号通道和集合")
}

// 值传递（不会修改原结构体）
func modifyPerson(p Person) {
	p.Age = 100
	fmt.Printf("函数内: %+v\n", p)
}

// 指针传递（会修改原结构体）
func modifyPersonPtr(p *Person) {
	p.Age = 100
	fmt.Printf("函数内: %+v\n", p)
}

func main() {
	DemoStructs()
}
