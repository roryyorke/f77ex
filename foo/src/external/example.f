C FILE: EXAMPLE.F
      SUBROUTINE SQUARE(B, X)
      REAL B
      REAL X
Cf2py intent(in) x
Cf2py intent(out) b
      B = X * X
      END

      SUBROUTINE FOO(B, X)
      REAL B
      REAL X

      INTEGER M
      INTEGER N
      DOUBLE PRECISION A(3,3)
      INTEGER LDA
      INTEGER IPIV(3)
      INTEGER INFO

      M=3
      N=3
      A(1,1) = X
      A(1,2) = 0
      A(1,3) = 0
      A(2,1) = 0
      A(2,2) = X
      A(2,3) = 0
      A(3,1) = 0
      A(3,2) = 0
      A(3,3) = X
      LDA=3
      

      CALL DGETRF(M, N, A, LDA, IPIV, INFO)
c$$$      B = (ABS(A(1,1)) + A(1,2) + A(1,3)
c$$$     $      + A(2,1) + A(2,2) + A(2,3)
c$$$     $      + A(3,1) + A(3,2) + A(3,3))
c$$$      B = IPIV(1)
      B = A(1,1);
      
      END


C END FILE EXAMPLE.F
