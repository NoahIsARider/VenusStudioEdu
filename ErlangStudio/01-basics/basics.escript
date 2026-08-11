#!/usr/bin/env escript
%% -*- erlang -*-
%% coding: utf-8
%% =====================================================
%% 01-basics/basics.escript
%% Erlang 基础：变量、数据类型、运算符、模式匹配
%% =====================================================

main(_) ->
    io:setopts([{encoding, unicode}]),

    io:format("~n=== 1. 变量与绑定 ===~n"),

    %% Erlang 变量是不可变的（Single Assignment）
    %% 变量以大写字母或下划线开头
    Name = "ErlangStudio",
    Version = 25,
    io:format("Name = ~ts, Version = ~p~n", [Name, Version]),

    %% 变量只能绑定一次
    X = 10,
    io:format("X = ~p~n", [X]),
    %% X = 20 会出错（重新绑定不允许）

    %% 下划线变量表示"忽略"
    _ = "被忽略的值",

    io:format("~n=== 2. 原子（Atom） ===~n"),

    %% 原子是不可变的符号常量，以小写字母开头
    _ok = ok,
    _hi = hello_world,
    _special = 'Not-an-atom-usually',
    io:format("原子 ok = ~p, hello = ~p~n", [ok, hello]),

    io:format("~n=== 3. 数字 ===~n"),

    Int = 42,
    Float = 3.14159,
    io:format("~p + ~p = ~p~n", [Int, 8, Int + 8]),
    io:format("~p - ~p = ~p~n", [Int, 8, Int - 8]),
    io:format("~p * ~p = ~p~n", [Int, 8, Int * 8]),
    io:format("~p / ~p = ~p~n", [Int, 8, Int / 8]),
    io:format("~p div ~p = ~p~n", [Int, 8, Int div 8]),
    io:format("~p rem ~p = ~p~n", [Int, 8, Int rem 8]),
    io:format("Float = ~.2f~n", [Float]),

    io:format("~n=== 4. 字符串与列表 ===~n"),

    %% 字符串其实是整数列表（字符编码）
    Str = "Hello",
    io:format("~ts = ~ts，作为列表 = ~w~n", ["字符串", Str, Str]),

    io:format("~ts: ~ts~n", ["连接", "Hello" ++ " " ++ "Erlang"]),

    List = [1, 2, 3, 4, 5],
    io:format("~ts = ~w~n", ["列表", List]),

    Tuple = {ok, "result", 42},
    io:format("~ts = ~tp~n", ["元组", Tuple]),

    io:format("~n=== 5. 布尔运算 ===~n"),

    io:format("~p andalso ~p = ~p~n", [true, false, true andalso false]),
    io:format("~p orelse ~p = ~p~n", [true, false, true orelse false]),
    io:format("not ~p = ~p~n", [true, not true]),
    io:format("~p =< ~p = ~p~n", [3, 5, 3 =< 5]),
    io:format("~p >= ~p = ~p~n", [3, 5, 3 >= 5]),

    io:format("~n=== 6. 模式匹配 ===~n"),

    {A, B} = {1, 2},
    io:format("A = ~p, B = ~p~n", [A, B]),

    [H | T] = [1, 2, 3, 4],
    io:format("~ts H = ~p, ~ts T = ~w~n", ["头部", H, "尾部", T]),

    {status, Message} = {status, "操作成功"},
    io:format("~ts = ~ts~n", ["状态消息", Message]),

    io:format("~n=== 7. 守卫（Guard） ===~n"),

    describe(120),
    describe(75),
    describe(30),

    io:format("~n=== 8. io 格式化输出 ===~n"),

    io:format("~p 打印 term: ~p~n", [Tuple, Tuple]),
    io:format("~w 简洁形式: ~w~n", [Tuple, Tuple]),
    io:format("十进制: ~b，十六进制大写: ~B~n", [255, 255]),
    io:format("右对齐宽度8: ~8b~n", [42]),
    io:format("带前导零: ~8..0b~n", [42]).

%% 守卫函数：不同模式匹配不同的守卫条件
describe(Int) when Int > 100 -> io:format("~p ~ts~n", [Int, "大于 100"]);
describe(Int) when Int > 50  -> io:format("~p ~ts~n", [Int, "在 50 到 100 之间"]);
describe(_)                  -> io:format("~ts~n", ["小于等于 50"]).
