C     Copied from scikit-build-core Fotran example

C     Basic non-LAPACK-dependent routine for sanity checks
      SUBROUTINE SQUARE(B, X)
      REAL B
      REAL X
      B = X * X
      END

C     Matrix determinant
      SUBROUTINE MAT_DET(M, A, DET_A, INFO)
      INTEGER M
      DOUBLE PRECISION A(M,M)
      DOUBLE PRECISION DET_A
      INTEGER IPIV(M)
      INTEGER INFO
      INTEGER I

      CALL DGETRF(M, M, A, M, IPIV, INFO)

      DET_A = 1

      DO 10 I=1, M
         DET_A = DET_A * A(I,I)
         IF (IPIV(I) .NE. I) THEN
            DET_A = -DET_A
         END IF
 10   CONTINUE
      
      END
