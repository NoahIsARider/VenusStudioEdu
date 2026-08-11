defmodule Basics do
  def run do
    IO.puts("=== 1. 基本数据类型与变量 ===")
    name = "ElixirStudio"
    version = 1.15
    IO.puts("语言名称: #{name}")
    IO.puts("版本号: #{version}")

    IO.puts("\n=== 2. 基本算术运算 ===")
    IO.puts("10 + 20 = #{10 + 20}")
    IO.puts("5 * 6 = #{5 * 6}")
  end
end
Basics.run()
