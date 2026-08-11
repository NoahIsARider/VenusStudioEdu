#!/usr/bin/env escript
%% -*- erlang -*-
%% coding: utf-8
%% =====================================================
%% 08-higher-order/higher_order.escript
%% Erlang 高阶与实战：函数式组合、二进制处理、OTP 模式
%% =====================================================

main(_) ->
    io:setopts([{encoding, unicode}]),

    io:format("~n=== 1. 函数式管道（管道组合） ===~n"),

    %% 通过匿名函数组合实现管道
    Data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    Result = pipeline(Data, [
        fun(L) -> [X * 2 || X <- L] end,
        fun(L) -> [X || X <- L, X rem 3 =/= 0] end,
        fun(L) -> lists:sum(L) end
    ]),
    io:format("管道处理结果: ~p~n", [Result]),

    io:format("~n=== 2. 柯里化与部分应用 ===~n"),

    %% 构造部分应用的函数
    Multiply = fun(A) -> fun(B) -> A * B end end,
    DoubleFn = Multiply(2),
    TripleFn = Multiply(3),
    io:format("DoubleFn(10) = ~p, TripleFn(10) = ~p~n", [DoubleFn(10), TripleFn(10)]),

    io:format("~n=== 3. 二进制与位操作 ===~n"),

    %% 二进制字符串
    BinStr = <<"Hello, Erlang">>,
    io:format("二进制字符串: ~ts~n", [BinStr]),
    io:format("二进制大小: ~p 字节~n", [byte_size(BinStr)]),

    %% 二进制拼接
    Combined = <<BinStr/binary, "!", 16#0A>>,
    io:format("拼接: ~w~n", [Combined]),

    %% 位字段解析
    Packet = <<1:4, 2:6, 3:6, 0:16>>,    %% 版本4位 + 类型6位 + 长度6位 + 校验16位
    <<Version:4, Type:6, Length:6, Check:16>> = Packet,
    io:format("包解析 - 版本:~p 类型:~p 长度:~p 校验:~p~n",
        [Version, Type, Length, Check]),

    %% 整数与二进制的转换
    io:format("~p -> 二进制: ~w~n", [255, <<255:8>>]),
    <<Num:8>> = <<255:8>>,
    io:format("二进制 -> 整数: ~p~n", [Num]),

    io:format("~n=== 4. ETS 表（内存数据库） ===~n"),

    %% 创建 ETS 表
    ets:new(students, [set, public, named_table]),
    ets:insert(students, {1, "张三", 85}),
    ets:insert(students, {2, "李四", 92}),
    ets:insert(students, {3, "王五", 78}),

    io:format("ETS 查询 id=2: ~p~n", [ets:lookup(students, 2)]),
    io:format("ETS 表大小: ~p~n", [ets:info(students, size)]),

    %% 遍历
    Names = [Name || {_, Name, _} <- ets:tab2list(students)],
    io:format("所有学生: ~ts~n", [lists:join(",", Names)]),

    ets:delete(students),

    io:format("~n=== 5. OTP 模式（通用服务器） ===~n"),

    %% 实现一个简单的 gen_server 风格服务
    {ok, Srv} = start_server(),
    io:format("服务器回复 hello: ~ts~n", [server_call(Srv, hello)]),
    io:format("存储 key1: ~p~n", [server_call(Srv, {store, "key1", 42})]),
    io:format("存储 key2: ~p~n", [server_call(Srv, {store, "key2", "value"})]),
    io:format("获取 key1: ~p~n", [server_call(Srv, {get, "key1"})]),
    io:format("获取 key2: ~p~n", [server_call(Srv, {get, "key2"})]),
    io:format("获取不存在的 key3: ~p~n", [server_call(Srv, {get, "key3"})]),
    stop_server(Srv),

    io:format("~n=== 6. 流式处理（惰性模拟） ===~n"),

    %% 生成平方序列并取前几个（Erlang 是急切求值，用有限范围模拟）
    Squares = [N * N || N <- lists:seq(1, 100)],
    io:format("平方序列前5个: ~w~n", [lists:sublist(Squares, 5)]),
    io:format("大于100的第一个平方: ~p~n",
        [hd([N || N <- Squares, N > 100])]),

    io:format("~n=== 7. 时间与性能 ===~n"),

    {TimeMicro, _} = timer:tc(fun() -> heavy_compute(100000) end),
    io:format("heavy_compute(100000) 耗时: ~p 微秒~n", [TimeMicro]).

%% === 辅助函数 ===

%% 管道执行
pipeline(Value, []) -> Value;
pipeline(Value, [F | Rest]) -> pipeline(F(Value), Rest).

%% 计算密集型操作
heavy_compute(N) -> lists:sum([X * X || X <- lists:seq(1, N)]).

%% === 简单 OTP 风格服务器（gen_server 简化版） ===

%% 启动服务器进程
start_server() ->
    Parent = self(),
    Pid = spawn(fun() -> server_loop(Parent, #{}) end),
    {ok, Pid}.

%% 服务器主循环（带状态）
server_loop(Parent, State) ->
    receive
        {call, From, hello} ->
            From ! {reply, "你好，来自 OTP 风格服务器！"},
            server_loop(Parent, State);
        {call, From, {store, K, V}} ->
            NewState = maps:put(K, V, State),
            From ! {reply, ok},
            server_loop(Parent, NewState);
        {call, From, {get, K}} ->
            Reply = maps:get(K, State, undefined),
            From ! {reply, Reply},
            server_loop(Parent, State);
        {stop, From} ->
            From ! {reply, stopped};
        _ ->
            server_loop(Parent, State)
    end.

%% 同步调用（call）
server_call(Pid, Request) ->
    Pid ! {call, self(), Request},
    receive
        {reply, Reply} -> Reply
    after 1000 -> timeout
    end.

%% 停止服务器
stop_server(Pid) ->
    Pid ! {stop, self()},
    io:format("服务器已停止~n").
