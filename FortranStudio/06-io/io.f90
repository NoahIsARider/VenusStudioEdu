! =====================================================
! 06-io/io.f90
! Fortran 输入输出：格式化 I/O、列表导向 I/O、文件 I/O、namelist
! =====================================================

program io_demo
    implicit none

    call demo_io()

contains

    subroutine demo_io()
        integer :: i, n, unit_num
        real :: x, y
        character(len=100) :: line
        integer :: ios

        print *, ""
        print *, "=== 1. 表控输入输出（list-directed）==="

        ! 表控输出（默认格式）
        print *, "整数:", 42
        print *, "实数:", 3.14159
        print *, "字符串:", "你好，Fortran！"
        print *, "多个值:", 1, 2, 3, "混合", 3.14

        ! 使用 write 输出到屏幕
        write(*, *) "write 输出: ", 100, 200

        print *, ""
        print *, "=== 2. 格式化输出（format）==="

        ! 使用格式说明符
        print "(A, I5)",         "整数（I5）:    ", 42
        print "(A, F8.2)",       "实数（F8.2）:  ", 3.14159
        print "(A, E12.4)",      "科学计数（E）: ", 3.14159
        print "(A, A)",          "字符串（A）:   ", "Hello"
        print "(A, L1)",         "逻辑（L1）:    ", .true.

        ! 多个格式项
        print "(I3, A, F6.2)", 1, " -> ", 1.0
        print "(3I4)", 1, 2, 3
        print "(3F8.2)", 1.1, 2.2, 3.3

        ! 重复格式
        print "(5(I2, 1X))", 1, 2, 3, 4, 5   ! 1X 表示 1 个空格

        ! 换行控制
        print "(A, /, A)", "第一行", "第二行"  ! / 表示换行

        print *, ""
        print *, "=== 3. 字符串内部 I/O ==="

        ! 将数据写入字符串
        block
            character(len=50) :: buffer
            write(buffer, "(I5, A, F6.2)") 42, " = ", 42.0
            print *, "写入字符串: " // trim(adjustl(buffer))

            ! 从字符串读取
            read(buffer, *) i, line, x
            print *, "从字符串读取: i =", i, ", x =", x
        end block

        print *, ""
        print *, "=== 4. 文件 I/O ==="

        ! 写入文件
        open(newunit=unit_num, file="demo_output.txt", status="replace", action="write")
        do i = 1, 5
            write(unit_num, "(I2, A, I4)") i, " 的平方 = ", i*i
        end do
        close(unit_num)
        print *, "已写入文件 demo_output.txt"

        ! 读取文件
        open(newunit=unit_num, file="demo_output.txt", status="old", action="read")
        print *, "读取文件内容:"
        do
            read(unit_num, "(A)", iostat=ios) line
            if (ios /= 0) exit
            print *, "  " // trim(line)
        end do
        close(unit_num)

        print *, ""
        print *, "=== 5. namelist ==="

        ! namelist 用于分组读写命名变量
        block
            real :: temperature = 25.5
            integer :: pressure = 1013
            character(len=20) :: location = "北京"
            integer :: nl_unit

            namelist /weather/ temperature, pressure, location

            ! 写入 namelist 到文件
            open(newunit=nl_unit, file="weather.nml", status="replace", action="write")
            write(nl_unit, nml=weather)
            close(nl_unit)
            print *, "已写入 namelist 文件 weather.nml"

            ! 读取 namelist
            temperature = 0.0
            pressure = 0
            location = ""
            open(newunit=nl_unit, file="weather.nml", status="old", action="read")
            read(nl_unit, nml=weather)
            close(nl_unit)
            print *, "读取 namelist:"
            print *, "  温度: ", temperature
            print *, "  气压: ", pressure
            print *, "  地点: ", trim(location)
        end block

        print *, ""
        print *, "=== 6. 格式说明符详解 ==="

        ! 常用格式说明符
        print *, "I 格式（整数）:"
        print "(I10)",     12345        ! 宽度 10
        print "(I5.3)",    42          ! 宽度 5，至少 3 位

        print *, "F 格式（定点实数）:"
        print "(F10.2)",    3.14159     ! 宽度 10，2 位小数
        print "(F10.4)",    3.14159     ! 宽度 10，4 位小数

        print *, "E 格式（科学计数法）:"
        print "(E12.4)",    3.14159     ! 宽度 12，4 位小数
        print "(ES12.4)",   3.14159     ! 工程计数法

        print *, "A 格式（字符串）:"
        print "(A20)",      "左对齐"
        print "(A)",        "自动宽度"

        print *, "X 格式（空格）:"
        print "(I3, 5X, I3)", 1, 2     ! 5 个空格

    end subroutine demo_io

end program io_demo
