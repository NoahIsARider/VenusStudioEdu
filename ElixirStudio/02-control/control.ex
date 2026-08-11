defmodule Control do
  def run do
    IO.puts("=== 1. 条件语句 (if / unless / case) ===")
    score = 85
    if score >= 60 do
      IO.puts("及格")
    else
      IO.puts("不及格")
    end

    IO.puts("\n=== 2. 模式匹配 ===")
    {status, message} = {:ok, "操作成功"}
    IO.puts("状态: #{status}, 消息: #{message}")
  end
end
Control.run()
