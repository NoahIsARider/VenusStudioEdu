package main

import (
	"fmt"
	"sort"
)

// DemoMaps 演示 Go 语言的映射
func DemoMaps() {
	fmt.Println("\n=== 12. 映射（Map）===")

	// 1. 创建映射
	fmt.Println("\n1. 创建映射:")
	var map1 map[string]int
	fmt.Printf("nil 映射: %v, is nil=%t\n", map1, map1 == nil)

	map2 := make(map[string]int)
	fmt.Printf("make 创建: %v\n", map2)

	map3 := map[string]int{
		"apple":  5,
		"banana": 3,
		"orange": 7,
	}
	fmt.Printf("字面量创建: %v\n", map3)

	// 2. 添加和修改元素
	fmt.Println("\n2. 添加和修改元素:")
	map2["one"] = 1
	map2["two"] = 2
	map2["three"] = 3
	fmt.Printf("添加元素后: %v\n", map2)
	map2["one"] = 10
	fmt.Printf("修改元素后: %v\n", map2)

	// 3. 访问元素
	fmt.Println("\n3. 访问元素:")
	value := map2["two"]
	fmt.Printf("map2[\"two\"] = %d\n", value)

	// 4. 检查键是否存在
	fmt.Println("\n4. 检查键是否存在:")
	val, exists := map2["two"]
	fmt.Printf("\"two\" 存在: %t, 值: %d\n", exists, val)
	val, exists = map2["four"]
	fmt.Printf("\"four\" 存在: %t, 值: %d\n", exists, val)

	// 5. 删除元素
	fmt.Println("\n5. 删除元素:")
	fmt.Printf("删除前: %v\n", map2)
	delete(map2, "one")
	fmt.Printf("删除 \"one\" 后: %v\n", map2)

	// 6. 获取映射长度
	fmt.Println("\n6. 映射长度:")
	fmt.Printf("len(map3) = %d\n", len(map3))

	// 7. 遍历映射
	fmt.Println("\n7. 遍历映射:")
	for key, value := range map3 {
		fmt.Printf("%s: %d\n", key, value)
	}

	// 8. 只遍历键
	fmt.Println("\n8. 只遍历键:")
	for key := range map3 {
		fmt.Printf("%s ", key)
	}
	fmt.Println()

	// 9. 只遍历值
	fmt.Println("\n9. 只遍历值:")
	for _, value := range map3 {
		fmt.Printf("%d ", value)
	}
	fmt.Println()

	// 10. 映射的映射（嵌套）
	fmt.Println("\n10. 嵌套映射:")
	users := map[string]map[string]string{
		"user1": {
			"name":  "Alice",
			"email": "alice@example.com",
		},
		"user2": {
			"name":  "Bob",
			"email": "bob@example.com",
		},
	}
	fmt.Printf("用户信息: %v\n", users)
	fmt.Printf("user1 的名字: %s\n", users["user1"]["name"])

	// 11. 映射和切片结合
	fmt.Println("\n11. 映射和切片结合:")
	scores := map[string][]int{
		"Alice": {90, 85, 88},
		"Bob":   {75, 80, 78},
		"Carol": {95, 92, 96},
	}
	for name, scoreList := range scores {
		fmt.Printf("%s 的成绩: %v\n", name, scoreList)
	}

	// 12. 计数器应用
	fmt.Println("\n12. 使用映射作为计数器:")
	words := []string{"apple", "banana", "apple", "cherry", "banana", "apple"}
	counter := make(map[string]int)
	for _, word := range words {
		counter[word]++
	}
	fmt.Printf("词频统计: %v\n", counter)

	// 13. 映射作为集合
	fmt.Println("\n13. 使用映射模拟集合:")
	set := make(map[int]bool)
	set[1] = true
	set[2] = true
	set[3] = true
	fmt.Printf("集合: %v\n", set)
	if set[2] {
		fmt.Println("2 在集合中")
	}
	if !set[4] {
		fmt.Println("4 不在集合中")
	}

	// 14. 排序映射的键
	fmt.Println("\n14. 按键排序遍历:")
	m := map[string]int{
		"delta":  4,
		"alpha":  1,
		"charlie": 3,
		"bravo":  2,
	}
	keys := make([]string, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	for _, k := range keys {
		fmt.Printf("%s: %d\n", k, m[k])
	}

	// 15. 映射作为函数参数
	fmt.Println("\n15. 映射作为参数:")
	testMap := map[string]int{"a": 1, "b": 2}
	fmt.Printf("原映射: %v\n", testMap)
	modifyMap(testMap)
	fmt.Printf("修改后: %v （引用传递）\n", testMap)

	// 16. 结构体作为映射的值
	fmt.Println("\n16. 结构体作为值:")
	type Person struct {
		Name string
		Age  int
	}
	people := map[int]Person{
		1: {Name: "Alice", Age: 30},
		2: {Name: "Bob", Age: 25},
		3: {Name: "Carol", Age: 35},
	}
	for id, person := range people {
		fmt.Printf("ID %d: %s, %d 岁\n", id, person.Name, person.Age)
	}

	// 17. 清空映射
	fmt.Println("\n17. 清空映射:")
	m2 := map[string]int{"a": 1, "b": 2, "c": 3}
	fmt.Printf("清空前: %v, len=%d\n", m2, len(m2))
	for k := range m2 {
		delete(m2, k)
	}
	fmt.Printf("清空后: %v, len=%d\n", m2, len(m2))
}

// 修改映射（映射是引用类型）
func modifyMap(m map[string]int) {
	m["c"] = 3
	m["a"] = 100
}

func main() {
	DemoMaps()
}
