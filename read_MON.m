function [nit,tt,ke,et,tm,sm,um,vm,wm,cfl,zm,sct] = read_MON(rac_nam,list_on,nrec)
% [nit,tt,ke,et,tm,sm,um,vm,wm,cfl,zm,sct] = read_MON(rac_nam,list_on,[nrec])
%-----------------------------------------------------------------
% read MONITOR output var from single-var output files ;
% read var that are "on" (=1) the list "list_on" (0 => not read) ;
% NB: time(=tt) not in list_on and Always read ;
% e.g.: list_on=[1 1 0 0 0 0 0 1] => read tt(time), et, ke & cfl
%-----------------------------------------------------------------

namfil=[rac_nam,'.tim']; D=dir(namfil);
if size(D,1) == 1,
 fprintf(['read ',namfil]); var=load(namfil);
else fprintf(['file: ',namfil,' not found => EXIT \n']); return; end
nit=size(var,1);
if (nargin < 3), nrec=nit ; end
nit=min(nit,nrec);
tt=zeros(nrec,1); tt(1:nit)=var(1:nit); msgA=' ';
%-----

ke=zeros(nrec,5);
et=zeros(nrec,4);
tm=zeros(nrec,4);
sm=zeros(nrec,4);
um=zeros(nrec,4);
vm=zeros(nrec,4);
wm=zeros(nrec,4);
zm=zeros(nrec,4);
cfl=zeros(nrec,4);
sct=zeros(nrec,4);

if list_on(1) == 1
 var=load([rac_nam,'.keX']); ke(1:nit,1)=var(1:nit); fprintf(' keX');
 var=load([rac_nam,'.keA']); ke(1:nit,2)=var(1:nit); fprintf(',A');
 namfil=[rac_nam,'.amE']; D=dir(namfil); sfx=',amE';
  if size(D,1) == 0, namfil=[rac_nam,'.keV']; D=dir(namfil); sfx=',V' ; end
  if size(D,1) == 1, var=load(namfil); ke(1:nit,3)=var(1:nit); fprintf(sfx); end
 namfil=[rac_nam,'.amU']; D=dir(namfil); sfx=',U';
  if size(D,1) == 0, namfil=[rac_nam,'.peA']; D=dir(namfil); sfx=',P'; end
  if size(D,1) == 1, var=load(namfil); ke(1:nit,4)=var(1:nit); fprintf(sfx); end
 namfil=[rac_nam,'.amT']; D=dir(namfil);
  if size(D,1) == 1, var=load(namfil); ke(1:nit,5)=var(1:nit); fprintf(',T'); end
end
%fprintf('\n nrec,nit, %i , %i \n', nrec,nit);
%fprintf('tt:  %i %i \n',size(tt));
%fprintf('ke:  %i %i \n',size(ke));

if list_on(2) == 1, [et,msg] =read_MON_1v([rac_nam,'.et'],nit,nrec) ;
                if length(msg) ~= 1, msgA=sprintf([msgA,msg]) ; end ; end
if list_on(3) == 1, [tm,msg] =read_MON_1v([rac_nam,'.t_'],nit,nrec) ;
                if length(msg) ~= 1, msgA=sprintf([msgA,msg]) ; end ; end
if list_on(4) == 1, [sm,msg] =read_MON_1v([rac_nam,'.s_'],nit,nrec) ;
                if length(msg) ~= 1, msgA=sprintf([msgA,msg]) ; end ; end
if list_on(5) == 1, [um,msg] =read_MON_1v([rac_nam,'.u_'],nit,nrec) ;
                if length(msg) ~= 1, msgA=sprintf([msgA,msg]) ; end ; end
if list_on(6) == 1, [vm,msg] =read_MON_1v([rac_nam,'.v_'],nit,nrec) ;
                if length(msg) ~= 1, msgA=sprintf([msgA,msg]) ; end ; end
if list_on(7) == 1, [wm,msg] =read_MON_1v([rac_nam,'.w_'],nit,nrec) ;
                if length(msg) ~= 1, msgA=sprintf([msgA,msg]) ; end ; end
if list_on(8) == 1, [cfl,msg]=read_MON_1v([rac_nam,'.cf'],-nit,nrec);
                if length(msg) ~= 1, msgA=sprintf([msgA,msg]) ; end ; end
%--------
if list_on(9) == 1, [zm,msg]=read_MON_1v([rac_nam,'.z_'],nit,nrec);
  namfil=[rac_nam,'.z_D']; D=dir(namfil); if size(D,1) == 1,
   zm(:,3)=zm(:,4); var=load(namfil); zm(1:nit,4)=var(1:nit); fprintf(',sd'); end
                if length(msg) ~= 1, msgA=sprintf([msgA,msg]) ; end ; end
%--------
if list_on(10) == 1, [sct,msg]=read_MON_1v([rac_nam,'.sc'],-nit,nrec);
                if length(msg) ~= 1, msgA=sprintf([msgA,msg]) ; end ; end
fprintf(' <= end \n');
if length(msgA) ~= 1, fprintf(['  not found:',msgA,'\n']) ; end

return

function [var,msg] = read_MON_1v(nam,nit,nrec)
prt=0; msg=' ';
ll=size(nam,2);
fprintf([' ',nam(ll-2:ll)]);
%sufx='NXAD';
sufx='NXAS';
if nit < 0,
 if     nam(end-1:end) == 'cf', sufx='uvwW';
 elseif nam(end-1:end) == 'sc', sufx='TSHE';
 end
 nit=-nit;
end
var=zeros(nrec,4);
for n=1:length(sufx),
 namfil=[nam,sufx(n)]; D=dir(namfil);
  if size(D,1) == 1, tmp=load(namfil); var(1:nit,n)=tmp(1:nit);
  else msg=sprintf([msg,namfil,' ']); prt=1 ;
  end
end
return
