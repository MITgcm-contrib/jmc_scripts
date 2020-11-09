function [nit,tt,ke,et,tm,sm,um,vm,wm,cfl,zm,sct] = readnc_MON(rac_nam,list_on,nrec)
% [nit,tt,ke,et,tm,sm,um,vm,wm,cfl,zm,sct] = readnc_MON(rac_nam,list_on,[nrec])
%-----------------------------------------------------------------
% read MONITOR output var from single NetCDF output files ;
% read var that are "on" (=1) the list "list_on" (0 => not read) ;
% NB: time(=tt) not in list_on and Always read ;
% e.g.: list_on=[1 1 0 0 0 0 0 1] => read tt(time), et, ke & cfl
%-----------------------------------------------------------------

% $Header: $
% $Name: $

namfil=strcat(rac_nam) ; D=dir(namfil);
if size(D,1) == 1,
%fprintf(['read ',namfil]); ncload(namfil,'time_secondsf'); var=time_secondsf;
 fprintf(['read ',namfil]); f = netcdf(namfil,'nowrite'); var=f{'time_secondsf'}(:);
else fprintf(['file: ',namfil,' not found => EXIT \n']); return; end
nit=size(var,1);
if (nargin < 3), nrec=nit ; end
tt=zeros(nrec,1); tt(1:nit)=var; msgA=' ';
%-----

ke=zeros(nrec,4);
et=zeros(nrec,4);
tm=zeros(nrec,4);
sm=zeros(nrec,4);
um=zeros(nrec,4);
vm=zeros(nrec,4);
wm=zeros(nrec,4);
zm=zeros(nrec,4);
cfl=zeros(nrec,4);
sct=zeros(nrec,4);

%return

if list_on(1) == 1
 nam0(1,:)='ke_max   '; fprintf(' keX');
 nam0(2,:)='ke_mean  '; fprintf(',A');
 nam0(3,:)='ke_vol   '; fprintf(',V');
 nam0(4,:)='pe_b_mean'; fprintf(',PE');
 for i=1:4,
   ke(1:nit,i)=f{strcat(nam0(i,:))}(:) ;
 end
%ncload(namfil,'ke_max','ke_mean','ke_vol','pe_b_mean');
%ke(1:nit,1)=ke_max  ;  fprintf(' keX');
%ke(1:nit,2)=ke_mean ;  fprintf(',A');
%ke(1:nit,3)=ke_vol  ;
%ke(1:nit,4)=pe_b_mean; fprintf(',PE');
end
%fprintf('\n nrec,nit, %i , %i \n', nrec,nit);
%fprintf('tt:  %i %i \n',size(tt));
%fprintf('ke:  %i %i \n',size(ke));

nam1='dynstat_' ;
 namS(1,:)='_min ' ;
 namS(2,:)='_max ' ;
 namS(3,:)='_mean' ;
 namS(4,:)='_sd  ' ;
 namS(5,:)='_del2' ;

if list_on(2) == 1,
 nam2='eta';
 for i=1:4,
%  fprintf([' >',strcat(nam1,nam2,namS(i,:)),'< \n']);
   et(1:nit,i)=f{strcat(nam1,nam2,namS(i,:))}(:) ;
 end
 fprintf([' ',nam2,' ']);
end

if list_on(3) == 1,
 nam2='theta';
 for i=1:4,
   tm(1:nit,i)=f{strcat(nam1,nam2,namS(i,:))}(:) ;
 end
 fprintf([' ',nam2,' ']);
end

if list_on(4) == 1,
 nam2='salt';
 for i=1:4,
   sm(1:nit,i)=f{strcat(nam1,nam2,namS(i,:))}(:) ;
 end
 fprintf([' ',nam2,' ']);
end

if list_on(5) == 1,
 nam2='uvel';
 for i=1:4,
   um(1:nit,i)=f{strcat(nam1,nam2,namS(i,:))}(:) ;
 end
 fprintf([' ',nam2,' ']);
end

if list_on(6) == 1,
 nam2='vvel';
 for i=1:4,
   vm(1:nit,i)=f{strcat(nam1,nam2,namS(i,:))}(:) ;
 end
 fprintf([' ',nam2,' ']);
end

if list_on(7) == 1,
 nam2='wvel';
 for i=1:4,
   wm(1:nit,i)=f{strcat(nam1,nam2,namS(i,:))}(:) ;
 end
 fprintf([' ',nam2,' ']);
end

if list_on(8) == 1,
 nam2='advcfl' ; namX='_max'; clear namA ;
 namA(1,:)='uvel';
 namA(2,:)='vvel';
 namA(3,:)='wvel';
 namA(4,:)='W_hf';
 for i=1:4,
   cfl(1:nit,i)=f{strcat(nam2,'_',namA(i,:),namX)}(:) ;
 end
 fprintf([' ',nam2,' ']);
end

%--------
if list_on(9) == 1,
 nam2='vort' ; namX='_max'; clear namA ;
 namA(1,:)='r_min ';
 namA(2,:)='r_max ';
%namA(3,:)='a_mean';
 namA(3,:)='a_sd  ';
 namA(4,:)='p_sd  ';
 for i=1:4,
   zm(1:nit,i)=f{strcat(nam2,'_',namA(i,:))}(:) ;
 end
 fprintf([' ',nam2,' ']);
end

%--------
if list_on(10) == 1,
 nam2='surfExpan' ; namX='_mean'; clear namA ;
 namA(1,:)='theta';
 namA(2,:)='salt ';
 for i=1:2,
   fprintf([' >',strcat(nam2,'_',namA(i,:),namX),'< \n']);
   sct(1:nit,i)=f{strcat(nam2,'_',namA(i,:),namX)}(:) ;
 end
 fprintf([' ',nam2,' ']);
end

close(f);

fprintf(' <= end \n');

return
