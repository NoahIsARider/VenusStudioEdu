package main

import "fmt"

// DemoGenerics 演示 Go 语言的泛型（Go 1.18+）
func DemoGenerics() {
	fmt.Println("\n=== 22. 泛型 ===")

	// 1. 泛型函数
	fmt.Println("\n1. 泛型函数:")
	fmt.Printf("Min(10, 5) = %d\n", Min(10, 5))
	fmt.Printf("Min(3.14, 2.71) = %.2f\n", Min(3.14, 2.71))
	fmt.Printf("Min(\"hello\", \"world\") = %s\n", Min("hello", "world"))

	// 2. 泛型切片函数
	fmt.Println("\n2. 泛型切片函数:")
	intSlice := []int{1, 2, 3, 4, 5}
	fmt.Printf("整数切片: %v\n", intSlice)
	fmt.Printf("第一个元素: %d\n", First(intSlice))
	
	strSlice := []string{"Go", "Python", "Java"}
	fmt.Printf("字符串切片: %v\n", strSlice)
	fmt.Printf("第一个元素: %s\n", First(strSlice))

	// 3. 泛型类型
	fmt.Println("\n3. 泛型栈:")
	intStack := NewStack[int]()
	intStack.Push(1)
	intStack.Push(2)
	intStack.Push(3)
	fmt.Printf("栈大小: %d\n", intStack.Size())
	fmt.Printf("弹出: %d\n", intStack.Pop())
	fmt.Printf("弹出: %d\n", intStack.Pop())
	
	strStack := NewStack[string]()
	strStack.Push("Go")
	strStack.Push("语言")
	fmt.Printf("弹出: %s\n", strStack.Pop())

	// 4. 泛型映射
	fmt.Println("\n4. 泛型映射函数:")
	numbers := []int{1, 2, 3, 4, 5}
	doubled := Map(numbers, func(n int) int {
		return n * 2
	})
	fmt.Printf("原数组: %v\n", numbers)
	fmt.Printf("翻倍后: %v\n", doubled)
	
	words := []string{"go", "rust", "java"}
	upper := Map(words, func(s string) string {
		return fmt.Sprintf("<%s>", s)
	})
	fmt.Printf("转换后: %v\n", upper)

	// 5. 泛型过滤
	fmt.Println("\n5. 泛型过滤函数:")
	nums := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	evens := Filter(nums, func(n int) bool {
		return n%2 == 0
	})
	fmt.Printf("原数组: %v\n", nums)
	fmt.Printf("偶数: %v\n", evens)

	// 6. 类型约束
	fmt.Println("\n6. 类型约束:")
	fmt.Printf("Add(10, 20) = %d\n", Add(10, 20))
	fmt.Printf("Add(3.14, 2.86) = %.2f\n", Add(3.14, 2.86))

	// 7. 泛型与接口
	fmt.Println("\n7. 泛型容器:")
	box1 := Box[int]{Value: 42}
	fmt.Printf("整数盒子: %v\n", box1.Get())
	
	box2 := Box[string]{Value: "Hello"}
	fmt.Printf("字符串盒子: %v\n", box2.Get())

	// 8. 多类型参数
	fmt.Println("\n8. 多类型参数:")
	pair := Pair[string, int]{
		First:  "Age",
		Second: 30,
	}
	fmt.Printf("键值对: %s = %d\n", pair.First, pair.Second)

	// 9. 泛型方法
	fmt.Println("\n9. 泛型方法:")
	cache := NewCache[string, int]()
	cache.Set("one", 1)
	cache.Set("two", 2)
	if val, ok := cache.Get("one"); ok {
		fmt.Printf("缓存值: %d\n", val)
	}
}

// 泛型函数 - 求最小值
func Min[T int | float64 | string](a, b T) T {
	if a < b {
		return a
	}
	return b
}

// 泛型函数 - 获取切片第一个元素
func First[T any](slice []T) T {
	if len(slice) == 0 {
		var zero T
		return zero
	}
	return slice[0]
}

// 泛型栈
type Stack[T any] struct {
	items []T
}

func NewStack[T any]() *Stack[T] {
	return &Stack[T]{items: []T{}}
}

func (s *Stack[T]) Push(item T) {
	s.items = append(s.items, item)
}

func (s *Stack[T]) Pop() T {
	if len(s.items) == 0 {
		var zero T
		return zero
	}
	item := s.items[len(s.items)-1]
	s.items = s.items[:len(s.items)-1]
	return item
}

func (s *Stack[T]) Size() int {
	return len(s.items)
}

// 泛型映射函数
func Map[T, U any](slice []T, f func(T) U) []U {
	result := make([]U, len(slice))
	for i, v := range slice {
		result[i] = f(v)
	}
	return result
}

// 泛型过滤函数
func Filter[T any](slice []T, predicate func(T) bool) []T {
	result := []T{}
	for _, v := range slice {
		if predicate(v) {
			result = append(result, v)
		}
	}
	return result
}

// 类型约束
type Number interface {
	int | int64 | float32 | float64
}

func Add[T Number](a, b T) T {
	return a + b
}

// 泛型容器
type Box[T any] struct {
	Value T
}

func (b Box[T]) Get() T {
	return b.Value
}

// 多类型参数
type Pair[K, V any] struct {
	First  K
	Second V
}

// 泛型缓存
type Cache[K comparable, V any] struct {
	data map[K]V
}

func NewCache[K comparable, V any]() *Cache[K, V] {
	return &Cache[K, V]{
		data: make(map[K]V),
	}
}

func (c *Cache[K, V]) Set(key K, value V) {
	c.data[key] = value
}

func (c *Cache[K, V]) Get(key K) (V, bool) {
	val, ok := c.data[key]
	return val, ok
}

func main() {
	DemoGenerics()
}
