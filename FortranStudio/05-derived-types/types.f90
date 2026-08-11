! =====================================================
! 05-derived-types/types.f90
! Fortran 派生类型：类型组件、类型绑定过程、构造器、嵌套类型
! =====================================================

program types_demo
    implicit none

    call demo_types()

contains

    subroutine demo_types()
        print *, ""
        print *, "=== 1. 基本派生类型 ==="

        ! 定义和使用基本派生类型
        block
            type :: Point
                real :: x
                real :: y
            end type Point

            type(Point) :: p1, p2

            ! 使用构造器初始化
            p1 = Point(1.0, 2.0)
            p2 = Point(3.0, 4.0)

            print *, "点 p1: x =", p1%x, ", y =", p1%y
            print *, "点 p2: x =", p2%x, ", y =", p2%y

            ! 修改组件
            p1%x = 10.0
            print *, "修改后 p1: x =", p1%x, ", y =", p1%y
        end block

        print *, ""
        print *, "=== 2. 带字符串组件的派生类型 ==="

        block
            type :: Person
                character(len=20) :: name
                integer :: age
                real :: height
            end type Person

            type(Person) :: person1, person2

            person1 = Person("张三", 25, 1.75)
            person2 = Person("李四", 30, 1.80)

            print *, "人物1: ", trim(person1%name), ", 年龄:", person1%age, ", 身高:", person1%height
            print *, "人物2: ", trim(person2%name), ", 年龄:", person2%age, ", 身高:", person2%height
        end block

        print *, ""
        print *, "=== 3. 嵌套派生类型 ==="

        block
            type :: Address
                character(len=50) :: street
                character(len=20) :: city
                character(len=10) :: zipcode
            end type Address

            type :: Employee
                character(len=20) :: name
                integer :: id
                type(Address) :: addr
            end type Employee

            type(Employee) :: emp

            ! 嵌套构造器
            emp = Employee("王五", 1001, Address("人民路 100 号", "北京", "100000"))

            print *, "员工: ", trim(emp%name)
            print *, "工号: ", emp%id
            print *, "地址: ", trim(emp%addr%street)
            print *, "城市: ", trim(emp%addr%city)
            print *, "邮编: ", trim(emp%addr%zipcode)
        end block

        print *, ""
        print *, "=== 4. 派生类型数组 ==="

        block
            type :: Student
                character(len=20) :: name
                integer :: score
            end type Student

            type(Student) :: students(3)
            integer :: i

            students(1) = Student("学生甲", 90)
            students(2) = Student("学生乙", 85)
            students(3) = Student("学生丙", 95)

            do i = 1, 3
                print *, "学生: ", trim(students(i)%name), ", 成绩: ", students(i)%score
            end do
        end block

        print *, ""
        print *, "=== 5. 类型绑定过程（方法）==="

        block
            type :: Rectangle
                real :: width
                real :: height
            contains
                procedure :: area
                procedure :: perimeter
            end type Rectangle

            type(Rectangle) :: rect

            rect = Rectangle(5.0, 3.0)
            print *, "矩形: 宽=", rect%width, ", 高=", rect%height
            print *, "面积 =", rect%area()
            print *, "周长 =", rect%perimeter()
        end block

        print *, ""
        print *, "=== 6. 默认构造器 ==="

        block
            type :: Counter
                integer :: value = 0
            end type Counter

            type(Counter) :: c1, c2

            ! 默认初始化为 0
            print *, "默认构造 c1: value =", c1%value
            print *, "默认构造 c2: value =", c2%value

            c1%value = 10
            print *, "修改后 c1: value =", c1%value
        end block

    end subroutine demo_types

end program types_demo
