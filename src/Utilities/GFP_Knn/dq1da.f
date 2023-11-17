      SUBROUTINE DQ1DA(F,A,B,EPS,R,E,KF,IFLAG)
      implicit none
C***BEGIN PROLOGUE  Q1DA
C***DATE WRITTEN   821018   (YYMMDD)
C***REVISION DATE  870525   (YYMMDD)
C***CATEGORY NO.  H2A1A1
C***KEYWORDS   ADAPTIVE  QUADRATURE, AUTOMATIC  QUADRATURE
C***AUTHOR  KAHANER, DAVID K., SCIENTIFIC COMPUTING DIVISION, NBS.
C***PURPOSE  Approximates one dimensional integrals of user defined
C            functions, easy to use.
C
C***DESCRIPTION
C       Q1DA IS A SUBROUTINE FOR THE AUTOMATIC EVALUATION
C            OF THE DEFINITE INTEGRAL OF A USER DEFINED FUNCTION
C            OF ONE VARIABLE.
C
C       From the book "Numerical Methods and Software"
C            by  D. Kahaner, C. Moler, S. Nash
C               Prentice Hall 1988
C
C       A R G U M E N T S   I N   T H E   C A L L   S E Q U E N C E
C
C       A
C       B     (INPUT) THE ENDPOINTS OF THE INTEGRATION INTERVAL
C       EPS   (INPUT) THE ACCURACY TO WHICH YOU WANT THE INTEGRAL
C                COMPUTED.  IF YOU WANT 2 DIGITS OF ACCURACY SET
C                EPS=.01, FOR 3 DIGITS SET EPS=.001, ETC.
C                EPS MUST BE POSITIVE.
C       R     (OUTPUT) Q1DA'S BEST ESTIMATE OF YOUR INTEGRAL
C       E     (OUTPUT) AN ESTIMATE OF ABS(INTEGRAL-R)
C       KF    (OUTPUT) THE COST OF THE INTEGRATION, MEASURED IN
C                   NUMBER OF EVALUATIONS OF YOUR INTEGRAND.
C                   KF WILL ALWAYS BE AT LEAST 30.
C       IFLAG (OUTPUT) TERMINATION FLAG...POSSIBLE VALUES ARE
C               0   NORMAL COMPLETION, E SATISFIES
C                        E<EPS  AND  E<EPS*ABS(R)
C               1   NORMAL COMPLETION, E SATISFIES
C                        E<EPS, BUT E>EPS*ABS(R)
C               2   NORMAL COMPLETION, E SATISFIES
C                        E<EPS*ABS(R), BUT E>EPS
C               3   NORMAL COMPLETION BUT EPS WAS TOO SMALL TO
C                     SATISFY ABSOLUTE OR RELATIVE ERROR REQUEST.
C
C               4   ABORTED CALCULATION BECAUSE OF SERIOUS ROUNDING
C                     ERROR.  PROBABLY E AND R ARE CONSISTENT.
C               5   ABORTED CALCULATION BECAUSE OF INSUFFICIENT STORAGE.
C                     R AND E ARE CONSISTENT.
C               6   ABORTED CALCULATION BECAUSE OF SERIOUS DIFFICULTIES
C                     MEETING YOUR ERROR REQUEST.
C               7   ABORTED CALCULATION BECAUSE EPS WAS SET <= 0.0
C
C            NOTE...IF IFLAG=3, 4, 5 OR 6 CONSIDER USING Q1DAX INSTEAD.
C
C    W H E R E   I S   Y O U R   I N T E G R A N D ?
C
C        YOU MUST WRITE A FORTRAN FUNCTION, CALLED F, TO EVALUATE
C        THE INTEGRAND.  USUALLY THIS LOOKS LIKE...
C                 FUNCTION F(X)
C                    F=(EVALUATE THE INTEGRAND AT THE POINT X)
C                    RETURN
C                 END
C
C
C    T Y P I C A L   P R O B L E M   S E T U P
C
C          A=0.0
C          B=1.0          (SET INTERVAL ENDPOINTS TO [0,1])
C          EPS=0.001       (SET ACCURACY REQUEST FOR 3 DIGITS)
C          CALL Q1DA(A,B,EPS,R,E,KF,IFLAG)
C          END
C          FUNCTION F(X)
C            F=SIN(2.*X)-SQRT(X)     (FOR EXAMPLE)
C            RETURN
C          END
C      FOR THIS SAMPLE PROBLEM, THE OUTPUT IS
C  0.0    1.0     .001    .041406750    .69077E-07    30    0
C
C    R E M A R K   I.
C
C           A SMALL AMOUT OF RANDOMIZATION IS BUILT INTO THIS PROGRAM.
C           CALLING Q1DA A FEW TIMES IN SUCCESSION WILL GIVE DIFFERENT
C           BUT HOPEFULLY CONSISTENT RESULTS.
C
C   R E M A R K   II.
C
C           THIS ROUTINE IS DESIGNED FOR INTEGRATION OVER A FINITE
C           INTERVAL.  THUS THE INPUT ARGUMENTS A AND B MUST BE
C           VALID REAL NUMBERS ON YOUR COMPUTER.  IF YOU WANT TO DO
C           AN INTEGRAL OVER AN INFINITE INTERVAL SET A OR B OR BOTH
C           LARGE ENOUGH SO THAT THE INTERVAL [A,B] CONTAINS MOST OF
C           THE INTEGRAND.  CARE IS NECESSARY, HOWEVER.  FOR EXAMPLE,
C           TO INTEGRATE EXP(-X*X) ON THE ENTIRE REAL LINE ONE COULD
C           TAKE A=-20., B=20. OR SIMILAR VALUES TO GET GOOD RESULTS.
C           IF YOU TOOK A=-1.E10 AND B=+1.E10 TWO BAD THINGS WOULD
C           OCCUR. FIRST, YOU WILL CERTAINLY GET AN ERROR MESSAGE FROM
C           THE EXP ROUTINE, AS ITS ARGUMENT IS TOO SMALL.  OTHER
C           THINGS COULD HAPPEN TOO, FOR EXAMPLE AN UNDERFLOW.
C           SECOND, EVEN IF THE ARITHMETIC WORKED PROPERLY Q1DA WILL
C           SURELY GIVE AN INCORRECT ANSWER, BECAUSE ITS FIRST TRY
C           AT SAMPLING THE INTEGRAND IS BASED ON YOUR SCALING AND
C           IT IS VERY UNLIKELY TO SELECT EVALUATION POINTS IN THE
C           INFINITESMALLY SMALL INTERVAL [-20,20] WHERE ALL THE
C           INTEGRAND IS CONCENTRATED, WHEN A, B ARE SO LARGE.
C
C    M O R E   F L E X I B I L I T Y
C
C           Q1DA IS AN EASY TO USE DRIVER FOR ANOTHER PROGRAM, Q1DAX.
C           Q1DAX PROVIDES SEVERAL OPTIONS WHICH ARE NOT AVAILABLE
C                WITH Q1DA.
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  Q1DAX
C***END PROLOGUE  Q1DA
C
      double precision A,B,E,EPS,F,FMAX,FMIN,R,W(50,6)
      integer nint, nmax, kf, iflag
      LOGICAL RST
      EXTERNAL F
C
C***FIRST EXECUTUTABLE STATEMENT  Q1DA
      NINT=1
      RST = .FALSE.
      NMAX=50
      CALL Q1DAX(F,A,B,EPS,R,E,NINT,RST,W,NMAX,FMIN,FMAX,KF,IFLAG)
      RETURN
      END
      SUBROUTINE Q1DAX(F,A,B,EPS,R,E,NINT,RST,W,NMAX,FMIN,FMAX,KF,IFLAG)
      implicit none
C***BEGIN PROLOGUE  Q1DAX
C     THIS PROLOGUE HAS BEEN REMOVED FOR REASONS OF SPACE
C     FOR A COMPLETE COPY OF THIS ROUTINE CONTACT THE AUTHORS
C***END PROLOGUE  Q1DAX
C
      integer nint, nmax, kf, iflag
      double precision A,B,E,EB,EPMACH,EPS,F,FMAX,FMAXL,FMAXR,FMIN,
     *  FMINL,
     *  FMINR,FMN,FMX,R,D1MACH,RAB,RABS,RAV,T,TE,TE1,TE2,TR,
     *  TR1,TR2,UFLOW,W(NMAX,6),XM
      real uni
      external uni
      INTEGER C
      EXTERNAL F
      LOGICAL RST
      integer MXTRY
      integer i
      integer iroff
      integer loc
      external IDAMAX
      integer IDAMAX
C
C***FIRST EXECUTABLE STATEMENT  Q1DAX
      EPMACH = D1MACH(4)
      UFLOW = D1MACH(1)
      MXTRY=NMAX/2
C          In case there is no more room, we can toss out easy intervals,
C             at most MXTRY times.
      IF(A.EQ.B) THEN
          R=0.0d+0
          E=0.0d+0
          NINT=0
          IFLAG=0
          KF=1
          FMIN=F(A)
          FMAX=FMIN
          GO TO 20
      ENDIF
      IF(RST) THEN
         IF(IFLAG.LT.3) THEN
           EB=MAX(100.0d+0*UFLOW,MAX(EPS,50.0d+0*EPMACH)*ABS(R))
           DO 19 I=1,NINT
               IF(ABS(W(I,3)).GT.(EB*(W(I,2)-W(I,1))/(B-A)))THEN
                                 W(I,3)=ABS(W(I,3))
               ELSE
                                 W(I,3)=-ABS(W(I,3))
               ENDIF
   19      CONTINUE
           GOTO 15
         ELSE
           GOTO 20
         ENDIF
      ENDIF
      KF=0
      IF(EPS .LE. 0. .OR. NINT .LE. 0 .OR. NINT .GE. NMAX) THEN
          IFLAG=7
          GO TO 20
      ENDIF
      IF(NINT.EQ.1)
     1  THEN
          W(1,1)=A
          W(2,2)=B
          W(1,5)=A
          W(1,6)=B
          W(2,5)=A
          W(2,6)=B
C          SELECT FIRST SUBDIVISION RANDOMLY
          W(1,2)=A+(B-A)/2.0d+0*(2*UNI()+7.0d+0)/8.0d+0
          W(2,1)=W(1,2)
          NINT=2
        ELSE
          IF(W(1,1).NE.A .OR. W(NINT+1,1).NE.B) THEN
               IFLAG=8
               GO TO 20
          ENDIF
          W(1,5)=A
          DO 89 I=1,NINT
             W(I,2)=W(I+1,1)
             W(I,5)=W(I,1)
             W(I,6)=W(I,2)
   89     CONTINUE
      ENDIF
C
      IFLAG = 0
      IROFF=0
      RABS=0.0
      DO 3 I=1,NINT
          CALL GL15T(F,W(I,1),W(I,2),DBLE(W(I,5)),DBLE(W(I,6)),
     1          W(I,4),W(I,3),RAB,RAV,FMN,FMX)
          KF=KF+15
          IF(I.EQ.1)
     1       THEN
               R=W(I,4)
               E=W(I,3)
               RABS=RABS+RAB
               FMIN=FMN
               FMAX=FMX
             ELSE
               R=R+W(I,4)
               E=E+W(I,3)
               RABS=RABS+RAB
               FMAX=MAX(FMAX,FMX)
               FMIN=MIN(FMIN,FMN)
          ENDIF
    3 CONTINUE
      DO 10 I=NINT+1,NMAX
          W(I,3) = 0.0d+0
   10 CONTINUE
   15 CONTINUE
C
C   MAIN SUBPROGRAM LOOP
C
      IF(100.0d+0*EPMACH*RABS.GE.ABS(R) .AND. E.LT.EPS)GO TO 20
      EB=MAX(100.0d+0*UFLOW,MAX(EPS,50.0d+0*EPMACH)*ABS(R))
      IF(E.LE.EB) GO TO 20
      IF (NINT.LT.NMAX)
     1 THEN
        NINT = NINT+1
        C = NINT
       ELSE
        C=0
   16   IF(C.EQ.NMAX .OR. MXTRY.LE.0) THEN
            IFLAG=5
            GO TO 20
        ENDIF
        C=C+1
        IF(W(C,3).GT.0.0d+0) GO TO 16
C            Found an interval to throw out
        MXTRY=MXTRY-1
      END IF
      LOC=IDAMAX(NINT,W(1,3),1)
      XM = W(LOC,1)+(W(LOC,2)-W(LOC,1))/2.0d+0
      IF ((MAX(ABS(W(LOC,1)),ABS(W(LOC,2)))).GT.
     1   ((1.0d+0+100.0d+0*EPMACH)*(ABS(XM)+0.1d+04*UFLOW)))
     2    THEN
            CALL GL15T(F,W(LOC,1),XM,DBLE(W(LOC,5)),DBLE(W(LOC,6)),
     1                    TR1,TE1,RAB,RAV,FMINL,FMAXL)
            KF=KF+15
            IF (TE1.LT.(EB*(XM-W(LOC,1))/(B-A))) TE1=-TE1
            CALL GL15T(F,XM,W(LOC,2),DBLE(W(LOC,5)),DBLE(W(LOC,6)),
     1                    TR2,TE2,RAB,RAV,FMINR,FMAXR)
            KF=KF+15
            FMIN=MIN(FMIN,FMINL,FMINR)
            FMAX=MAX(FMAX,FMAXL,FMAXR)
            IF (TE2.LT.(EB*(W(LOC,2)-XM)/(B-A))) TE2=-TE2
            TE = ABS(W(LOC,3))
            TR = W(LOC,4)
            W(C,3) = TE2
            W(C,4) = TR2
            W(C,1) = XM
            W(C,2) = W(LOC,2)
            W(C,5) = W(LOC,5)
            W(C,6) = W(LOC,6)
            W(LOC,3) = TE1
            W(LOC,4) = TR1
            W(LOC,2) = XM
            E = E-TE+(ABS(TE1)+ABS(TE2))
            R = R-TR+(TR1+TR2)
            IF(ABS(ABS(TE1)+ABS(TE2)-TE).LT.0.001*TE) THEN
                IROFF=IROFF+1
                IF(IROFF.GE.10) THEN
                     IFLAG=4
                     GO TO 20
                ENDIF
            ENDIF
          ELSE
            IF (EB.GT.W(LOC,3))
     1         THEN
                   W(LOC,3) = 0.0d+0
               ELSE
                   IFLAG=6
                   GO TO 20
            END IF
      END IF
      GO TO 15
C
C        ALL EXITS FROM HERE
C
   20 CONTINUE
      IF(IFLAG.GE.4)RETURN
      IFLAG=3
      T=EPS*ABS(R)
      IF(E.GT.EPS .AND. E.GT.T)RETURN
      IFLAG=2
      IF(E.GT.EPS .AND. E.LT.T)RETURN
      IFLAG=1
      IF(E.LT.EPS .AND. E.GT.T)RETURN
      IFLAG=0
      RETURN
      END
      SUBROUTINE GL15T(F,A,B,XL,XR,R,AE,RA,
     1                 RASC,FMIN,FMAX)
      implicit none
C***BEGIN PROLOGUE  GL15T
C***REFER TO  Q1DA,Q1DAX
C***END PROLOGUE  GL15T
      SAVE EPMACH,UFLOW
      double precision A,AE,B,DHLGTH,EPMACH,F,FC,FMAX,FMIN,FSUM,FV1,FV2,
     *  FVAL1,FVAL2,
     *  HLGTH,PHI,PHIP,PHIU,R,D1MACH,RA,RASC,RESG,RESK,RESKH,SL,SR,
     *  UFLOW,WG,WGK,XGK
      DOUBLE PRECISION XL,XR,CENTR,ABSC,U
      INTEGER J,JTW,JTWM1
C
      DIMENSION FV1(7),FV2(7),WG(4),WGK(8),XGK(8)
C
C           THE ABSCISSAE AND WEIGHTS ARE GIVEN FOR THE INTERVAL (-1,1)
C           BECAUSE OF SYMMETRY ONLY THE POSITIVE ABSCISSAE AND THEIR
C           CORRESPONDING WEIGHTS ARE GIVEN.
C
C           XGK    - ABSCISSAE OF THE 15-POINT KRONROD RULE
C                    XGK(2), XGK(4), ...  ABSCISSAE OF THE 7-POINT
C                    GAUSS RULE
C                    XGK(1), XGK(3), ...  ABSCISSAE WHICH ARE OPTIMALLY
C                    ADDED TO THE 7-POINT GAUSS RULE
C
C           WGK    - WEIGHTS OF THE 15-POINT KRONROD RULE
C
C           WG     - WEIGHTS OF THE 7-POINT GAUSS RULE
C
      DATA WG  (  1) / 0.1294849661 6886969327 0611432679 082 D0 /
      DATA WG  (  2) / 0.2797053914 8927666790 1467771423 780 D0 /
      DATA WG  (  3) / 0.3818300505 0511894495 0369775488 975 D0 /
      DATA WG  (  4) / 0.4179591836 7346938775 5102040816 327 D0 /
C
      DATA XGK (  1) / 0.9914553711 2081263920 6854697526 329 D0 /
      DATA XGK (  2) / 0.9491079123 4275852452 6189684047 851 D0 /
      DATA XGK (  3) / 0.8648644233 5976907278 9712788640 926 D0 /
      DATA XGK (  4) / 0.7415311855 9939443986 3864773280 788 D0 /
      DATA XGK (  5) / 0.5860872354 6769113029 4144838258 730 D0 /
      DATA XGK (  6) / 0.4058451513 7739716690 6606412076 961 D0 /
      DATA XGK (  7) / 0.2077849550 0789846760 0689403773 245 D0 /
      DATA XGK (  8) / 0.0000000000 0000000000 0000000000 000 D0 /
C
      DATA WGK (  1) / 0.0229353220 1052922496 3732008058 970 D0 /
      DATA WGK (  2) / 0.0630920926 2997855329 0700663189 204 D0 /
      DATA WGK (  3) / 0.1047900103 2225018383 9876322541 518 D0 /
      DATA WGK (  4) / 0.1406532597 1552591874 5189590510 238 D0 /
      DATA WGK (  5) / 0.1690047266 3926790282 6583426598 550 D0 /
      DATA WGK (  6) / 0.1903505780 6478540991 3256402421 014 D0 /
      DATA WGK (  7) / 0.2044329400 7529889241 4161999234 649 D0 /
      DATA WGK (  8) / 0.2094821410 8472782801 2999174891 714 D0 /
C
      PHI(U)=XR-(XR-XL)*U*U*(2.0d+0*U+3.0d+0)
      PHIP(U)=-6.0d+0*U*(U+1.0d+0)
C
C           LIST OF MAJOR VARIABLES
C           -----------------------
C
C           CENTR  - MID POINT OF THE INTERVAL
C           HLGTH  - HALF-LENGTH OF THE INTERVAL
C           ABSC   - ABSCISSA
C           FVAL*  - FUNCTION VALUE
C           RESG   - R OF THE 7-POINT GAUSS FORMULA
C           RESK   - R OF THE 15-POINT KRONROD FORMULA
C           RESKH  - APPROXIMATION TO THE MEAN VALUE OF F OVER (A,B),
C                    I.E. TO I/(B-A)
C
C           MACHINE DEPENDENT CONSTANTS
C           ---------------------------
C
C           EPMACH IS THE LARGEST RELATIVE SPACING.
C           UFLOW IS THE SMALLEST POSITIVE MAGNITUDE.
C
      DATA EPMACH,UFLOW/0.00d+0,0.00d+0/
C***FIRST EXECUTABLE STATEMENT  GL15T
      IF(EPMACH.EQ.0.00d+0) THEN
         EPMACH=D1MACH(4)
         UFLOW=D1MACH(1)
      ENDIF
C
      IF(XL.LT.XR)THEN
         SL=SNGL(XL)
         SR=SNGL(XR)
        ELSE
         SL=SNGL(XR)
         SR=SNGL(XL)
      ENDIF
      HLGTH = 0.5d+00*(B-A)
      CENTR = A+HLGTH
      DHLGTH = ABS(HLGTH)
C
C           COMPUTE THE 15-POINT KRONROD APPROXIMATION TO
C           THE INTEGRAL, AND ESTIMATE THE ABSOLUTE ERROR.
C
      U=(CENTR-XR)/(XR-XL)
      PHIU=PHI(U)
      IF(PHIU.LE.SL .OR. PHIU.GE.SR) PHIU=CENTR
      FMIN=F(PHIU)
      FMAX=FMIN
      FC=FMIN*PHIP(U)
      RESG = FC*WG(4)
      RESK = FC*WGK(8)
      RA = ABS(RESK)
      DO 10 J=1,3
        JTW = J*2
        ABSC = HLGTH*XGK(JTW)
        U=(CENTR-ABSC-XR)/(XR-XL)
        PHIU=PHI(U)
        IF(PHIU.LE.SL .OR. PHIU.GE.SR) PHIU=CENTR
        FVAL1=F(PHIU)
        FMAX=MAX(FMAX,FVAL1)
        FMIN=MIN(FMIN,FVAL1)
        FVAL1=FVAL1*PHIP(U)
        U=(CENTR+ABSC-XR)/(XR-XL)
        PHIU=PHI(U)
        IF(PHIU.LE.SL .OR. PHIU.GE.SR) PHIU=CENTR
        FVAL2=F(PHIU)
        FMAX=MAX(FMAX,FVAL2)
        FMIN=MIN(FMIN,FVAL2)
        FVAL2=FVAL2*PHIP(U)
        FV1(JTW) = FVAL1
        FV2(JTW) = FVAL2
        FSUM = FVAL1+FVAL2
        RESG = RESG+WG(J)*FSUM
        RESK = RESK+WGK(JTW)*FSUM
        RA = RA+WGK(JTW)*(ABS(FVAL1)+ABS(FVAL2))
   10 CONTINUE
      DO 15 J = 1,4
        JTWM1 = J*2-1
        ABSC = HLGTH*XGK(JTWM1)
        U=(CENTR-ABSC-XR)/(XR-XL)
        PHIU=PHI(U)
        IF(PHIU.LE.SL .OR. PHIU.GE.SR) PHIU=CENTR
        FVAL1=F(PHIU)
        FMAX=MAX(FMAX,FVAL1)
        FMIN=MIN(FMIN,FVAL1)
        FVAL1=FVAL1*PHIP(U)
        U=(CENTR+ABSC-XR)/(XR-XL)
        PHIU=PHI(U)
        IF(PHIU.LE.SL .OR. PHIU.GE.SR) PHIU=CENTR
        FVAL2=F(PHIU)
        FMAX=MAX(FMAX,FVAL2)
        FMIN=MIN(FMIN,FVAL2)
        FVAL2=FVAL2*PHIP(U)
        FV1(JTWM1) = FVAL1
        FV2(JTWM1) = FVAL2
        FSUM = FVAL1+FVAL2
        RESK = RESK+WGK(JTWM1)*FSUM
        RA = RA+WGK(JTWM1)*(ABS(FVAL1)+ABS(FVAL2))
   15 CONTINUE
      RESKH = RESK*0.5d+00
      RASC = WGK(8)*ABS(FC-RESKH)
      DO 20 J=1,7
        RASC = RASC+WGK(J)*(ABS(FV1(J)-RESKH)+ABS(FV2(J)-RESKH))
   20 CONTINUE
      R = RESK*HLGTH
      RA = RA*DHLGTH
      RASC = RASC*DHLGTH
      AE = ABS((RESK-RESG)*HLGTH)
      IF(RASC.NE.0.0d+00.AND.AE.NE.0.0d+00)
     *  AE = RASC*MIN(0.1d+01,
     *  (0.2d+03*AE/RASC)**1.5d+00)
      IF(RA.GT.UFLOW/(0.5d+02*EPMACH)) AE = MAX(
     *  (EPMACH*0.5d+02)*RA,AE)
      RETURN
      END

