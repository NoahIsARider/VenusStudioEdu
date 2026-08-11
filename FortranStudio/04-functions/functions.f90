! =====================================================
! 04-functions/functions.f90
! Fortran 函数与子程序：函数、子程序、intent、可选参数、接口、模块
! =====================================================

! ---- 模块定义（必须在 program 之前）----

module math_utils
    implicit none
    real, parameter :: PI = 3.1415926
contains

    ! 模块函数：立方
    function cube(x) result(res)
        real, intent(in) :: x
        real :: res
        res = x ** 3
    end function cube

    ! 模块函数：翻倍
    function double_it(n) result(res)
        integer, intent(in) :: n
        integer :: res
        res = n * 2
    end function double_it

    ! 模块子程序：球体体积
    subroutine sphere_volume(radius, vol)
        real, intent(in) :: radius
        real, intent(out) :: vol
        vol = (4.0 / 3.0) * PI * radius ** 3
    end subroutine sphere_volume

end module math_utils

! ---- 主程序 ----

program functions
    use math_utils
    implicit none

    call demo_functions()

contains

    subroutine demo_functions()
        integer :: result
        real :: x, y, area_val, r, vol

        print *, ""
        print *, "=== 1. 函数（function）==="

        ! 调用函数
        result = square(5)
        print *, "square(5) =", result

        result = factorial(5)
        print *, "factorial(5) =", result

        x = 3.0; y = 4.0
        print *, "distance(3, 4) =", distance(x, y)

        print *, ""
        print *, "=== 2. 子程序（subroutine）==="

        ! 调用子程序（用 call）
        call greet("FortranStudio")

        ! 子程序可以修改传入参数
        call swap_ints(10, 20)

        ! 通过子程序返回多个值
        block
            integer :: a, b
            call minmax([5, 2, 8, 1, 9], a, b)
            print *, "minmax 结果: 最小=", a, ", 最大=", b
        end block

        print *, ""
        print *, "=== 3. intent 属性 ==="

        ! intent(in)    - 只读参数
        ! intent(out)   - 只写参数
        ! intent(inout) - 可读可写参数
        call demonstrate_intent(10, area_val, r)
        print *, "半径 10 的圆面积 =", area_val
        print *, "半径 10 的圆周长 =", r

        print *, ""
        print *, "=== 4. 可选参数（optional）==="

        ! 调用带可选参数的子程序
        call print_info("张三")
        call print_info("李四", 25)
        call print_info("王五", 30, "北京")

        print *, ""
        print *, "=== 5. 接口块（interface）==="

        ! 使用接口块声明外部函数
        block
            interface
                function ext_add(a, b) result(r)
                    integer, intent(in) :: a, b
                    integer :: r
                end function ext_add
            end interface

            print *, "ext_add(3, 4) =", ext_add(3, 4)
        end block

        print *, ""
        print *, "=== 6. 模块（module）==="

        ! 使用模块中的函数和子程序
        print *, "math_utils::cube(3) =", cube(3.0)
        print *, "math_utils::double_it(5) =", double_it(5)

        call sphere_volume(2.0, vol)
        print *, "math_utils::sphere_volume(2) =", vol

    end subroutine demo_functions

    ! ---- 函数定义 ----

    ! 简单函数：返回整数的平方
    function square(n) result(res)
        integer, intent(in) :: n
        integer :: res
        res = n * n
    end function square

    ! 递归函数：阶乘
    recursive function factorial(n) result(res)
        integer, intent(in) :: n
        integer :: res
        if (n <= 1) then
            res = 1
        else
            res = n * factorial(n - 1)
        end if
    end function factorial

    ! 实数函数：欧几里得距离
    function distance(a, b) result(res)
        real, intent(in) :: a, b
        real :: res
        res = sqrt(a*a + b*b)
    end function distance

    ! ---- 子程序定义 ----

    ! 简单子程序：打印问候
    subroutine greet(name)
        character(len=*), intent(in) :: name
        print *, "你好，" // trim(name) // "！"
    end subroutine greet

    ! 子程序：交换两个整数（使用临时变量）
    subroutine swap_ints(a, b)
        integer, intent(inout) :: a, b
        integer :: temp
        temp = a
        a = b
        b = temp
        print *, "交换后: a =", a, ", b =", b
    end subroutine swap_ints

    ! 子程序：返回数组的最小值和最大值
    subroutine minmax(arr, min_val, max_val)
        integer, intent(in) :: arr(:)
        integer, intent(out) :: min_val, max_val
        min_val = minval(arr)
        max_val = maxval(arr)
    end subroutine minmax

    ! 子程序：演示 intent（计算圆面积和周长）
    subroutine demonstrate_intent(radius, area, circumference)
        integer, intent(in) :: radius          ! 只读输入
        real, intent(out) :: area              ! 只写输出
        real, intent(out) :: circumference     ! 只写输出
        real, parameter :: LOCAL_PI = 3.1415926
        area = LOCAL_PI * real(radius) ** 2
        circumference = 2.0 * LOCAL_PI * real(radius)
    end subroutine demonstrate_intent

    ! 子程序：带可选参数
    subroutine print_info(name, age, city)
        character(len=*), intent(in) :: name
        integer, intent(in), optional :: age
        character(len=*), intent(in), optional :: city

        print *, "姓名: " // trim(name)
        if (present(age)) then
            print *, "年龄:", age
        else
            print *, "年龄: 未提供"
        end if
        if (present(city)) then
            print *, "城市: " // trim(city)
        else
            print *, "城市: 未提供"
        end if
    end subroutine print_info

end program functions

! ---- 外部函数（通过接口块调用）----

function ext_add(a, b) result(r)
    integer, intent(in) :: a, b
    integer :: r
    r = a + b
end function ext_add
