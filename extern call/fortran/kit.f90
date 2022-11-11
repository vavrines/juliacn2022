! gfortran kit.f90 -o libkit.so -shared -fPIC

subroutine test(u)
    real(kind = 8), dimension(:, :), intent(inout) :: u
    u(1, 2) = 2022.0
end

subroutine test1(u, n1, n2)
    integer, intent(in) :: n1, n2
    real(kind = 8), intent(inout) :: u(n1, n2)
    u(1, 2) = 2022.0
end