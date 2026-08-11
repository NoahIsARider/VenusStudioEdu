object Control {
  def main(args: Array[String]): Unit = {
    println("=== 1. 条件表达式 ===")
    val x = 10
    val result = if (x > 5) "大于 5" else "小于等于 5"
    println(s"结果: $result")

    println("\n=== 2. 循环与守卫 ===")
    for (i <- 1 to 3) {
      println(s"循环计数: $i")
    }

    println("\n=== 3. 模式匹配 (Match) ===")
    val status = 200
    val message = status match {
      case 200 => "成功"
      case 404 => "未找到"
      case _   => "未知状态"
    }
    println(s"状态码 $status 对应: $message")
  }
}
Control.main(Array())
