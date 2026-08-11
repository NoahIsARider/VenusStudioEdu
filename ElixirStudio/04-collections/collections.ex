defmodule Collections do
  def run do
    IO.puts("=== 1. 列表与关键字列表 ===")
    list = [1, 2, 3, 4]
    IO.puts("列表: #{inspect(list)}")

    map = %{name: "Alice", age: 30}
    IO.puts("映射 Map: #{inspect(map)}")
    IO.puts("姓名: #{map.name}")
  end
end
Collections.run()
