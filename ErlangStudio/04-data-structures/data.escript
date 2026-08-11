#!/usr/bin/env escript
%% -*- erlang -*-
%% coding: utf-8
%% =====================================================
%% 04-data-structures/data.escript
%% Erlang 数据结构：列表、元组、映射（Map）、记录（Record）
%% =====================================================

%% 记录定义（编译期展开为元组）
-record(person, {name, age = 0, city = "未知"}).

main(_) ->
    io:setopts([{encoding, unicode}]),

    io:format("~n=== 1. 列表（List） ===~n"),

    List = [5, 2, 8, 1, 9],
    io:format("原始列表: ~w~n", [List]),

    %% 常用列表函数
    io:format("连接: ~w~n", [[1, 2] ++ [3, 4]]),
    io:format("差值: ~w~n", [[1, 2, 3, 4] -- [2, 4]]),
    io:format("头部: ~p, 尾部: ~w~n", [hd(List), tl(List)]),
    io:format("长度: ~p~n", [length(List)]),
    io:format("第3个元素: ~p~n", [lists:nth(3, List)]),
    io:format("排序: ~w~n", [lists:sort(List)]),
    io:format("去重: ~w~n", [lists:usort([3, 1, 3, 2, 1])]),
    io:format("逆序: ~w~n", [lists:reverse(List)]),
    io:format("subseq(2,4): ~w~n", [lists:sublist(List, 2, 4)]),

    io:format("~n=== 2. 元组（Tuple） ===~n"),

    Point = {1, 2},
    io:format("点坐标: ~w~n", [Point]),
    Person = {"张三", 25, "北京"},
    io:format("元组: ~tp~n", [Person]),
    io:format("取第2个元素: ~p~n", [element(2, Person)]),
    io:format("元组大小: ~p~n", [tuple_size(Person)]),

    %% 模式匹配解构（顺序对应元组字段）
    {N2, Age2, City2} = Person,
    io:format("名字: ~ts, 年龄: ~p, 城市: ~ts~n", [N2, Age2, City2]),

    %% 二元元组常用于键值
    KeyValue = {name, "value"},
    io:format("键值元组: ~p~n", [KeyValue]),

    io:format("~n=== 3. 映射（Map） ===~n"),

    %% Map 是键值对集合
    Config = #{name => "Lua", version => 5.4, open => true},
    io:format("映射: ~tp~n", [Config]),

    %% 读取
    io:format("获取 name: ~ts~n", [maps:get(name, Config)]),
    io:format("获取不存在的键（带默认值）: ~p~n", [maps:get(hobby, Config, "编程")]),

    %% 新增/更新（Map 不可变，返回新 Map）
    NewConfig = Config#{year => 2024},
    io:format("新增键: ~tp~n", [maps:get(year, NewConfig)]),

    %% 删除
    Smaller = maps:remove(version, Config),
    io:format("删除后是否存在 version: ~p~n", [maps:is_key(version, Smaller)]),

    %% 遍历
    io:format("遍历所有键值:~n"),
    maps:foreach(fun(K, V) -> io:format("  ~p => ~tp~n", [K, V]) end, Config),

    io:format("所有键: ~w~n", [maps:keys(Config)]),
    io:format("所有值: ~w~n", [maps:values(Config)]),

    io:format("~n=== 4. 记录（Record） ===~n"),

    %% 创建记录
    P1 = #person{name = "李雷", age = 20, city = "上海"},
    io:format("记录: ~tp~n", [P1]),

    %% 访问字段
    io:format("姓名: ~ts, 年龄: ~p~n", [P1#person.name, P1#person.age]),

    %% 更新字段
    P2 = P1#person{age = 21},
    io:format("更新后年龄: ~p~n", [P2#person.age]),

    %% 使用默认值
    P3 = #person{name = "韩梅梅"},
    io:format("默认年龄: ~p, 默认城市: ~ts~n", [P3#person.age, P3#person.city]),

    %% 模式匹配记录
    #person{name = N, age = A} = P1,
    io:format("模式匹配: ~ts ~p~n", [N, A]),

    io:format("~n=== 5. 嵌套结构 ===~n"),

    Students = [
        #{name => "李雷", scores => #{math => 90, english => 85}},
        #{name => "韩梅梅", scores => #{math => 78, english => 95}}
    ],

    %% 遍历嵌套 map
    lists:foreach(
        fun(S) ->
            Name = maps:get(name, S),
            Scores = maps:get(scores, S),
            Avg = (maps:get(math, Scores) + maps:get(english, Scores)) / 2,
            io:format("~ts 平均分: ~.1f~n", [Name, Avg])
        end, Students),

    io:format("~n=== 6. 集合与映射组合 ===~n"),

    %% 用 map 做集合
    Visited = #{beijing => true, shanghai => true},
    io:format("已访问北京: ~p~n", [maps:is_key(beijing, Visited)]),
    io:format("已访问广州: ~p~n", [maps:is_key(guangzhou, Visited)]),

    %% 用列表推导生成 map
    SquareMap = maps:from_list([{X, X * X} || X <- lists:seq(1, 5)]),
    io:format("1~~5 的平方映射: ~w~n", [SquareMap]),

    %% map 与 list 转换
    ListFromMap = maps:to_list(Config),
    io:format("map 转列表: ~w~n", [ListFromMap]).

%% 记录不能出现在 escript 顶层，这里只作为文档说明
