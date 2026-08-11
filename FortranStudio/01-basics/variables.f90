! =====================================================
! 01-basics/variables.f90
! Fortran 变量和数据类型基础
! =====================================================
!
! Fortran 是一种静态类型语言，变量必须声明类型。
! 使用 implicit none 强制显式声明所有变量（推荐）。

program variables
    implicit none

    call demo_variables()

contains

    subroutine demo_variables()
        ! 局部变量声明区
        integer :: i, j
        real :: x, y
        complex :: z
        character(len=20) :: name
        logical :: flag
        integer, parameter :: MAX_SIZE = 100

        print *, ""
        print *, "=== 1. 变量声明 ==="

        ! 1. 整数类型
        i = 42
        print *, "整数: i =", i

        ! 2. 实数类型（浮点数）
        x = 3.14159
        print *, "实数: x =", x

        ! 3. 复数类型
        z = (1.0, 2.0)
        print *, "复数: z =", z

        ! 4. 字符串类型
        name = "FortranStudio"
        print *, "字符串: name =", trim(name)

        ! 5. 逻辑类型
        flag = .true.
        print *, "逻辑: flag =", flag

        print *, ""
        print *, "=== 2. 数据类型 ==="

        ! Fortran 5 种基本类型
        block
            integer :: int_val = 42
            real :: real_val = 3.14159
            complex :: comp_val = (1.0, 2.0)
            character(len=10) :: char_val = "你好"
            logical :: bool_val = .true.

            print *, "整数:  ", int_val, "类型: integer"
            print *, "实数:  ", real_val, "类型: real"
            print *, "复数:  ", comp_val, "类型: complex"
            print *, "字符串:", trim(char_val), " 类型: character"
            print *, "逻辑:  ", bool_val, "类型: logical"
        end block

        print *, ""
        print *, "=== 3. 运算符 ==="

        ! 算术运算符
        i = 10; j = 3
        print *, "加法 10 + 3 =", i + j
        print *, "减法 10 - 3 =", i - j
        print *, "乘法 10 * 3 =", i * j
        print *, "除法 10 / 3 =", i / j          ! 整数除法，结果为 3
        print *, "实数除法 10.0 / 3.0 =", 10.0 / 3.0
        print *, "取模 mod(10, 3) =", mod(i, j)
        print *, "幂 10 ** 2 =", i ** 2
        print *, "取负 -10 =", -i

        ! 关系运算符
        print *, ""
        print *, "关系运算符:"
        print *, "10 > 3:", 10 > 3
        print *, "10 < 3:", 10 < 3
        print *, "10 == 3:", 10 == 3
        print *, "10 /= 3:", 10 /= 3            ! Fortran 的不等于
        print *, "10 >= 10:", 10 >= 10
        print *, "10 <= 5:", 10 <= 5

        ! 逻辑运算符
        print *, ""
        print *, "逻辑运算符:"
        print *, ".true. .and. .false.:", .true. .and. .false.
        print *, ".true. .or. .false.:", .true. .or. .false.
        print *, ".not. .true.:", .not. .true.
        print *, ".true. .eqv. .true.:", .true. .eqv. .true.   ! 逻辑等价
        print *, ".true. .neqv. .false.:", .true. .neqv. .false. ! 逻辑不等价

        ! 字符串连接
        print *, ""
        print *, "字符串连接:"
        block
            character(len=20) :: greeting
            greeting = "Hello" // " " // "Fortran"
            print *, greeting
        end block

        print *, ""
        print *, "=== 4. kind 参数 ==="

        ! kind 参数控制精度
        block
            integer :: int32_val
            integer(kind=8) :: int64_val
            real :: real32_val
            real(kind=8) :: real64_val

            int32_val = 2147483647
            int64_val = 9223372036854775807_8
            real32_val = 1.0
            real64_val = 1.0_8

            print *, "32位整数:", int32_val
            print *, "64位整数:", int64_val
            print *, "32位实数:", real32_val
            print *, "64位实数:", real64_val
            print *, "默认整数 kind:", kind(int32_val)
            print *, "默认实数 kind:", kind(real32_val)
        end block

        print *, ""
        print *, "=== 5. 类型转换 ==="

        ! 数字类型转换
        block
            integer :: num = 123
            real :: float_num

            float_num = real(num)         ! 整数转实数
            print *, "整数转实数:", float_num

            float_num = 456.78
            num = int(float_num)          ! 实数转整数（截断）
            print *, "实数转整数:", num
        end block

        print *, ""
        print *, "=== 6. 常量（参数） ==="
        ! Fortran 用 parameter 属性定义常量
        print *, "常量: MAX_SIZE =", MAX_SIZE
        print *, "常量: PI =", 3.1415926

    end subroutine demo_variables

end program variables
