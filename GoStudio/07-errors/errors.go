package main

import (
	"errors"
	"fmt"
)

// DemoErrors 演示 Go 语言的错误处理
func DemoErrors() {
	fmt.Println("\n=== 19. 错误处理 ===")

	// 1. 基本错误处理
	fmt.Println("\n1. 基本错误处理:")
	result, err := divide(10, 2)
	if err != nil {
		fmt.Printf("错误: %v\n", err)
	} else {
		fmt.Printf("结果: %d\n", result)
	}

	result, err = divide(10, 0)
	if err != nil {
		fmt.Printf("错误: %v\n", err)
	}

	// 2. 自定义错误
	fmt.Println("\n2. 自定义错误:")
	err = validateAge(-5)
	if err != nil {
		fmt.Printf("验证失败: %v\n", err)
	}

	err = validateAge(25)
	if err != nil {
		fmt.Printf("验证失败: %v\n", err)
	} else {
		fmt.Println("年龄有效")
	}

	// 3. errors.New
	fmt.Println("\n3. 使用 errors.New:")
	err = doSomething(false)
	if err != nil {
		fmt.Printf("错误: %v\n", err)
	}

	// 4. fmt.Errorf
	fmt.Println("\n4. 使用 fmt.Errorf:")
	err = processUser("", 25)
	if err != nil {
		fmt.Printf("处理用户错误: %v\n", err)
	}

	// 5. 自定义错误类型
	fmt.Println("\n5. 自定义错误类型:")
	err = withdraw(100, 200)
	if err != nil {
		fmt.Printf("错误: %v\n", err)
		// 类型断言检查具体错误
		if e, ok := err.(*InsufficientFundsError); ok {
			fmt.Printf("余额不足: 需要 %.2f, 只有 %.2f\n",
				e.Amount, e.Balance)
		}
	}

	// 6. 错误包装
	fmt.Println("\n6. 错误包装:")
	err = readConfig()
	if err != nil {
		fmt.Printf("错误: %v\n", err)
	}

	// 7. 错误检查
	fmt.Println("\n7. 错误检查:")
	err = doOperation()
	if err != nil {
		fmt.Printf("操作失败: %v\n", err)
		if errors.Is(err, ErrNotFound) {
			fmt.Println("这是一个 NotFound 错误")
		}
	}

	// 8. 错误类型检查
	fmt.Println("\n8. 错误类型检查:")
	err = performAction()
	if err != nil {
		var validationErr *ValidationError
		if errors.As(err, &validationErr) {
			fmt.Printf("验证错误: 字段=%s, 值=%v\n",
				validationErr.Field, validationErr.Value)
		}
	}

	// 9. 多返回值错误处理
	fmt.Println("\n9. 多返回值:")
	a, b, err := parseNumbers("10", "20")
	if err != nil {
		fmt.Printf("解析错误: %v\n", err)
	} else {
		fmt.Printf("解析成功: a=%d, b=%d\n", a, b)
	}

	// 10. 提前返回模式
	fmt.Println("\n10. 提前返回模式:")
	err = processData("")
	if err != nil {
		fmt.Printf("处理失败: %v\n", err)
	}

	err = processData("valid data")
	if err != nil {
		fmt.Printf("处理失败: %v\n", err)
	} else {
		fmt.Println("处理成功")
	}

	// 11. 错误聚合
	fmt.Println("\n11. 错误聚合:")
	err = multipleOperations()
	if err != nil {
		fmt.Printf("操作失败: %v\n", err)
	}

	// 12. 最佳实践
	fmt.Println("\n12. 错误处理最佳实践:")
	fmt.Println("- 总是检查错误")
	fmt.Println("- 提供有意义的错误信息")
	fmt.Println("- 错误向上传播时添加上下文")
	fmt.Println("- 使用自定义错误类型提供更多信息")
	fmt.Println("- 不要忽略错误（避免使用 _ ）")
}

// 基本错误返回
func divide(a, b int) (int, error) {
	if b == 0 {
		return 0, errors.New("除数不能为0")
	}
	return a / b, nil
}

// 自定义错误
func validateAge(age int) error {
	if age < 0 {
		return errors.New("年龄不能为负数")
	}
	if age > 150 {
		return errors.New("年龄不合理")
	}
	return nil
}

// 使用 errors.New
func doSomething(success bool) error {
	if !success {
		return errors.New("操作失败")
	}
	return nil
}

// 使用 fmt.Errorf
func processUser(name string, age int) error {
	if name == "" {
		return fmt.Errorf("无效的用户名: 不能为空")
	}
	if age < 0 {
		return fmt.Errorf("无效的年龄: %d", age)
	}
	return nil
}

// 自定义错误类型
type InsufficientFundsError struct {
	Amount  float64
	Balance float64
}

func (e *InsufficientFundsError) Error() string {
	return fmt.Sprintf("余额不足: 需要 %.2f, 只有 %.2f",
		e.Amount, e.Balance)
}

func withdraw(balance, amount float64) error {
	if amount > balance {
		return &InsufficientFundsError{
			Amount:  amount,
			Balance: balance,
		}
	}
	return nil
}

// 错误包装
func openFile() error {
	return errors.New("文件不存在")
}

func readConfig() error {
	err := openFile()
	if err != nil {
		return fmt.Errorf("读取配置失败: %w", err)
	}
	return nil
}

// 预定义错误
var (
	ErrNotFound     = errors.New("未找到")
	ErrUnauthorized = errors.New("未授权")
	ErrInvalidInput = errors.New("无效输入")
)

func doOperation() error {
	return fmt.Errorf("操作失败: %w", ErrNotFound)
}

// 验证错误类型
type ValidationError struct {
	Field string
	Value interface{}
}

func (e *ValidationError) Error() string {
	return fmt.Sprintf("验证失败: 字段 %s, 值 %v", e.Field, e.Value)
}

func performAction() error {
	return &ValidationError{
		Field: "email",
		Value: "invalid-email",
	}
}

// 多返回值
func parseNumbers(s1, s2 string) (int, int, error) {
	// 简化版本，实际应该使用 strconv
	if s1 == "" || s2 == "" {
		return 0, 0, errors.New("输入不能为空")
	}
	return 10, 20, nil
}

// 提前返回
func processData(data string) error {
	if data == "" {
		return errors.New("数据不能为空")
	}
	// 处理数据...
	return nil
}

// 错误聚合
func multipleOperations() error {
	err1 := doSomething(false)
	if err1 != nil {
		return fmt.Errorf("第一步失败: %w", err1)
	}
	
	err2 := validateAge(-1)
	if err2 != nil {
		return fmt.Errorf("第二步失败: %w", err2)
	}
	
	return nil
}

func main() {
	DemoErrors()
}
