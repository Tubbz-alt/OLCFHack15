      PROGRAM TESTPI

      IMPLICIT NONE

      INTERFACE 
         FUNCTION CALCPI (N)
         INTEGER, PARAMETER :: DP = KIND(1.0D0)
         INTEGER*8 , INTENT(IN) :: N
         REAL(DP) ::  CALCPI
         END FUNCTION CALCPI
      END INTERFACE

      INTEGER*8 ,PARAMETER :: N=2000000000
      INTEGER, PARAMETER :: DP = KIND(1.0D0)

      REAL(DP) OPI,NDP
      NDP=REAL(N,DP)
      
      OPI=CALCPI(N)

      PRINT *,'PI=',(OPI/NDP),'OPI=',OPI,'NDP=',NDP


      END PROGRAM TESTPI


      FUNCTION CALCPI( N)

      IMPLICIT NONE

      INTEGER, PARAMETER ::  VL=1024
      INTEGER, PARAMETER :: DP = KIND(1.0D0)
      INTEGER, PARAMETER :: SP = KIND(1.0)
      REAL(DP):: CALCPI
      REAL(DP) PI
      INTEGER*8 I
      REAL(DP) T,II,NDP
      INTEGER*8 , INTENT(IN) :: N

!$ACC PARALLEL VECTOR_LENGTH(VL) COPYOUT(PI) COPYIN(N,NDP,T,II)
      NDP=REAL(N,DP)
      T=0.D0
      II=0.D0
      PI=0.D0
!$ACC LOOP REDUCTION(+:PI)
      DO  I=0,N
         II=REAL(I,DP)
         T= ((II+0.D5)/NDP)
         PI = PI+4.D0/(1.D0+(T*T))
      ENDDO
!$ACC END PARALLEL 
      CALCPI=PI

      END FUNCTION CALCPI