      program cmpnum
      implicit none
      real*8 a,b,diff
      integer linnum,tmp,best
      open(17,file='cmpnum.log',status='unknown')
      best=-22
  99  read(*,*,end=70,err=60) linnum,a,b
      diff=0.5*(abs(a)+abs(b))
c     print *,a,b,diff,abs(a-b)/diff
c     if (diff.gt.1.e-12) then
      if (diff.gt.0.) then
        diff=abs(a-b)/diff
        if (diff.gt.0.) then
c         print *,int(log10(diff)),diff
          tmp=nint(log10(diff))
        else
          tmp=-16;
        endif
        best=max(best,tmp)
      else
        tmp =-22
      endif
      write(17,'(I4,1P2E22.14,A,I4)') linnum,a,b,' :',-tmp
      goto 99
  60  stop 'cmpnum: An error occured reading a,b'
  70  continue
      close(17)
      print *,-best
      end
