package main

import (
	"fmt"
	"time"
)

// DemoSelect 演示 Go 语言的 select 语句
func DemoSelect() {
	fmt.Println("\n=== 18. Select 语句 ===")

	// 1. 基本 select
	fmt.Println("\n1. 基本 select:")
	ch1 := make(chan string)
	ch2 := make(chan string)

	go func() {
		time.Sleep(time.Millisecond * 100)
		ch1 <- "来自 ch1"
	}()

	go func() {
		time.Sleep(time.Millisecond * 200)
		ch2 <- "来自 ch2"
	}()

	for i := 0; i < 2; i++ {
		select {
		case msg1 := <-ch1:
			fmt.Println("接收:", msg1)
		case msg2 := <-ch2:
			fmt.Println("接收:", msg2)
		}
	}

	// 2. select 与超时
	fmt.Println("\n2. Select 超时:")
	c := make(chan string, 1)
	go func() {
		time.Sleep(time.Millisecond * 200)
		c <- "结果"
	}()

	select {
	case res := <-c:
		fmt.Println(res)
	case <-time.After(time.Millisecond * 100):
		fmt.Println("超时了")
	}

	// 3. 非阻塞 select
	fmt.Println("\n3. 非阻塞 select:")
	messages := make(chan string)
	select {
	case msg := <-messages:
		fmt.Println("收到消息:", msg)
	default:
		fmt.Println("没有消息可接收")
	}

	// 4. 非阻塞发送
	fmt.Println("\n4. 非阻塞发送:")
	msg := "hello"
	select {
	case messages <- msg:
		fmt.Println("发送消息:", msg)
	default:
		fmt.Println("无法发送消息（channel 已满或无接收者）")
	}

	// 5. 多路复用
	fmt.Println("\n5. 多路复用:")
	tick := time.Tick(time.Millisecond * 100)
	boom := time.After(time.Millisecond * 500)
	
	for {
		select {
		case <-tick:
			fmt.Println("tick")
		case <-boom:
			fmt.Println("BOOM!")
			goto done
		default:
			fmt.Print(".")
			time.Sleep(time.Millisecond * 50)
		}
	}
done:
	fmt.Println()

	// 6. Select 随机选择
	fmt.Println("\n6. Select 随机选择:")
	c1 := make(chan string, 1)
	c2 := make(chan string, 1)
	c1 <- "one"
	c2 <- "two"

	for i := 0; i < 2; i++ {
		select {
		case msg1 := <-c1:
			fmt.Println("从 c1 接收:", msg1)
		case msg2 := <-c2:
			fmt.Println("从 c2 接收:", msg2)
		}
	}

	// 7. 空 select
	fmt.Println("\n7. 空 select（会永远阻塞）:")
	fmt.Println("不演示空 select，它会导致死锁")

	// 8. Select 与退出信号
	fmt.Println("\n8. Select 与退出信号:")
	quit := make(chan bool)
	work := make(chan int)

	go func() {
		for i := 1; i <= 3; i++ {
			work <- i
		}
		quit <- true
	}()

	for {
		select {
		case w := <-work:
			fmt.Printf("工作: %d\n", w)
		case <-quit:
			fmt.Println("收到退出信号")
			return
		}
	}
}

func main() {
	DemoSelect()
}
