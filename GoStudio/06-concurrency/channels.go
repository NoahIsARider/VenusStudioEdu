package main

import (
	"fmt"
	"sync"
	"time"
)

// DemoChannels 演示 Go 语言的 channels
func DemoChannels() {
	fmt.Println("\n=== 17. Channels (通道) ===")

	// 1. 创建和使用 channel
	fmt.Println("\n1. 基本 channel:")
	ch := make(chan int)
	go func() {
		ch <- 42 // 发送数据
	}()
	value := <-ch // 接收数据
	fmt.Printf("接收到: %d\n", value)

	// 2. 缓冲 channel
	fmt.Println("\n2. 缓冲 channel:")
	buffered := make(chan string, 3)
	buffered <- "A"
	buffered <- "B"
	buffered <- "C"
	fmt.Printf("接收: %s\n", <-buffered)
	fmt.Printf("接收: %s\n", <-buffered)
	fmt.Printf("接收: %s\n", <-buffered)

	// 3. 关闭 channel
	fmt.Println("\n3. 关闭 channel:")
	ch2 := make(chan int, 3)
	ch2 <- 1
	ch2 <- 2
	ch2 <- 3
	close(ch2) // 关闭 channel
	
	for val := range ch2 {
		fmt.Printf("%d ", val)
	}
	fmt.Println()

	// 4. 检查 channel 是否关闭
	fmt.Println("\n4. 检查 channel 状态:")
	ch3 := make(chan int, 1)
	ch3 <- 10
	close(ch3)
	
	val, ok := <-ch3
	fmt.Printf("接收: %d, channel 是否开启: %t\n", val, ok)
	val, ok = <-ch3
	fmt.Printf("再次接收: %d, channel 是否开启: %t\n", val, ok)

	// 5. 单向 channel
	fmt.Println("\n5. 单向 channel:")
	ch4 := make(chan int)
	go sendOnly(ch4)
	receiveOnly(ch4)

	// 6. WaitGroup 同步
	fmt.Println("\n6. 使用 WaitGroup:")
	var wg sync.WaitGroup
	for i := 1; i <= 3; i++ {
		wg.Add(1)
		go worker(i, &wg)
	}
	wg.Wait()
	fmt.Println("所有 worker 完成")

	// 7. Channel 作为信号
	fmt.Println("\n7. Channel 作为信号:")
	done := make(chan bool)
	go func() {
		fmt.Println("工作中...")
		time.Sleep(time.Millisecond * 100)
		fmt.Println("工作完成")
		done <- true
	}()
	<-done
	fmt.Println("收到完成信号")

	// 8. 多个 goroutines 与 channel
	fmt.Println("\n8. 多个生产者和消费者:")
	jobs := make(chan int, 10)
	results := make(chan int, 10)

	// 3 个 worker
	for w := 1; w <= 3; w++ {
		go processor(w, jobs, results)
	}

	// 发送 5 个任务
	for j := 1; j <= 5; j++ {
		jobs <- j
	}
	close(jobs)

	// 收集结果
	for a := 1; a <= 5; a++ {
		<-results
	}

	// 9. Channel 超时
	fmt.Println("\n9. Channel 超时:")
	ch5 := make(chan string)
	go func() {
		time.Sleep(time.Millisecond * 200)
		ch5 <- "完成"
	}()
	
	select {
	case msg := <-ch5:
		fmt.Println(msg)
	case <-time.After(time.Millisecond * 100):
		fmt.Println("超时！")
	}

	// 10. 非阻塞操作
	fmt.Println("\n10. 非阻塞操作:")
	messages := make(chan string)
	signals := make(chan bool)

	select {
	case msg := <-messages:
		fmt.Println("收到消息:", msg)
	default:
		fmt.Println("没有消息")
	}

	msg := "hi"
	select {
	case messages <- msg:
		fmt.Println("发送消息:", msg)
	default:
		fmt.Println("无法发送")
	}

	// 11. Channel 方向
	fmt.Println("\n11. Channel 方向限制:")
	pinger := make(chan string, 1)
	ponger := make(chan string, 1)
	
	go ping(pinger, ponger)
	go pong(ponger, pinger)
	
	pinger <- "开始"
	time.Sleep(time.Millisecond * 100)

	// 12. 关闭时的零值
	fmt.Println("\n12. 关闭 channel 的零值:")
	ch6 := make(chan int, 2)
	ch6 <- 1
	ch6 <- 2
	close(ch6)
	
	fmt.Printf("%d ", <-ch6)
	fmt.Printf("%d ", <-ch6)
	fmt.Printf("%d ", <-ch6) // 关闭的 channel 返回零值
	fmt.Println()
}

// 只发送的 channel
func sendOnly(ch chan<- int) {
	ch <- 123
	close(ch)
}

// 只接收的 channel
func receiveOnly(ch <-chan int) {
	fmt.Printf("接收: %d\n", <-ch)
}

// Worker with WaitGroup
func worker(id int, wg *sync.WaitGroup) {
	defer wg.Done()
	fmt.Printf("Worker %d 开始\n", id)
	time.Sleep(time.Millisecond * 50)
	fmt.Printf("Worker %d 完成\n", id)
}

// Processor
func processor(id int, jobs <-chan int, results chan<- int) {
	for j := range jobs {
		fmt.Printf("Worker %d 处理任务 %d\n", id, j)
		time.Sleep(time.Millisecond * 50)
		results <- j * 2
	}
}

// Ping
func ping(pinger chan<- string, ponger <-chan string) {
	for i := 0; i < 3; i++ {
		msg := <-ponger
		if msg == "开始" || msg == "pong" {
			fmt.Println("收到:", msg, "-> 发送 ping")
			pinger <- "ping"
		}
	}
}

// Pong
func pong(ponger <-chan string, pinger chan<- string) {
	for i := 0; i < 3; i++ {
		msg := <-ponger
		if msg == "ping" {
			fmt.Println("收到:", msg, "-> 发送 pong")
			pinger <- "pong"
		}
	}
}

func main() {
	DemoChannels()
}
