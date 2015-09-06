 prefix='dynStD';
%prefix='iceStD';
 namA={'g02','b02'};
%namA={'r17a'};
 Nexp=size(namA,2);
%-

% $Header: /u/gcmpack/MITgcm_contrib/jmc_script/grph_StD.m,v 1.7 2015/03/07 14:45:49 jmc Exp $
% $Name:  $

nItMx=1e10*ones(1,Nexp); %nItMx(3)=11;
%nItMx=2400*ones(1,Nexp);
namLg=namA ; namLg=strrep(namLg,'_','\_');
undef=123456.7;
%-----------
%- test if the variable krd is define :
if size(who('krd'),1) > 0,
 fprintf('krd is defined and = %i \n',krd);
else
 fprintf('krd undefined ; set to 1 \n'); krd=1 ;
end
if krd > 0,
%- define list of fields to read in:
%listV={'Eta','U','V','W','T','S','DETADT2','RELHUM','Phi'};
%listV={'Eta','W','T','S','CONVADJ','DETADT2'};
%listV={'Eta','UE_VEL_C','VN_VEL_C','W','T','DETADT2','Phi'};
%- or take all them:
 clear listV ; listV='all_flds';
%-----------

%- start to read the longest record:
  n=1; rf=-1; if strcmp(char(listV),'all_flds'), rf=0; end
  [ntA(n),rList,tim,vv1,listV] = ...
    read_StD(prefix,namA(n),listV);
  nIt=ntA(n); nk=size(vv1,1); nRg=size(vv1,3);
%- set global dims: & load vvA --> vvB
  nbV=size(listV,2);
  nrec=nIt; n3d=nk; nReg=nRg;
  vvA=zeros(n3d,nrec,nReg,5,nbV,Nexp); tiA=zeros(nrec,2,Nexp);
  vvA(1:nk,1:nIt,1:nRg,:,:,n)=vv1; tiA(1:nIt,:,n)=tim;
%----
 for n=2:Nexp,
  [ntA(n),rList,tim,vv1,listV] = ...
    read_StD(prefix,namA(n),listV);
  nIt=ntA(n); nk=size(vv1,1); nRg=size(vv1,3);
  if (nrec < nIt),
    fprintf('\n');
    error([' Nb of records=',int2str(nIt),' exceeds nrec=',int2str(nrec)]);
  end
  if (n3d < nk),
    fprintf('\n');
    error([' Nb of Levels=',int2str(nk),' exceeds n3d=',int2str(n3d)]);
  end
  vvA(1:nk,1:nIt,1:nRg,:,:,n)=vv1; tiA(1:nIt,:,n)=tim;
 end;
 if krd == 2,
   fprintf('save to "sav_StD.mat" file ...');
   save('sav_StD.mat','vvA','tiA','ntA','rList','listV');
   fprintf(' done\n')
 end
elseif krd < 0,
 fprintf('load from "sav_StD.mat" file ...');
 load sav_StD
 fprintf(' done\n'); nbV=size(listV,2);
end
if krd ~= 0,
 ttA=squeeze(tiA(:,2,:));
 ttA=ttA/3600; titT='hrs';  ttA=ttA/24; titT='days';
 ttA=ttA/30 ; titT='month'; ttA=ttA/12 ; titT='year';
end
%=========================================================

ttax1=0 ; ttax2=0 ; ttay=zeros(nbV,2);
%-- fixed time axis bound :
% ttax1=15.; ttax2=20.;
%-- fixed Y axis bound :
% ttay(4,:)=[0 0.6];
%-----------
fprintf('Total length: ntA=');fprintf(' %i ,',ntA); fprintf(' \n');
for n=1:Nexp,
fprintf(' exp %i : time(d):%10.2f ->%10.2f \n', n,ttA(1,n),ttA(ntA(n),n) );
end;
%--

list_on=zeros(1,nbV);
nbG=18;
nbG=min(nbG,nbV); list_on(1:nbG)=1 ;
%if nbG < nbV, list_on=0; list_on(nbG:nbV)=1; end %- to get 2nd set of plots
%list_on(1:6)=[1 1 1 1 1 1];

isA=ones(1,Nexp); ieA=ntA;
%- limit the length : for search of isA <->1500y: find(ttA(:,2) == 1500)
%isA=isA*31 ; % drop the 1rst mnth (1 Monitor/d)
isA=isA*2 ; % drop the 1rst mnth (1 Monitor/30d)
%isA(1)=31 ; isA(2)=4 ; % drop the 1rst mnth
%ieA(:)=240; %isA(:)=1;

linA(1,:)='k-'; % ieA(1)=60 ; % ieA(1)=1152 ;
linA(2,:)='b-';
linA(3,:)='r-';
linA(4,:)='g-';
linA(5,:)='m-';
linA(6,:)='c-';

ieA=min(ieA,nItMx);
%titall='AIM , Cubic-G (32x32) , cpl-FM Forcing' ;
titall='Global Ocean, Cubic-G (32x32) , CORE Forc (2)' ;
%titall='Dyncore test-case 5 (cs-32)' ;

%=========================================================
ng=0; fxb=100; fyb=60;
%fyb=160; fxb=-2600;

for jv=1:nbV,
%-------------------
 flag=list_on(jv); kl=0;
 vv1=vvA(:,:,:,:,jv,:); namV=char(listV(jv));
 titv=strrep(namV,'_','\_');
%if strcmp(namV,'Eta'), vv1=vv1/100; titv='Eta [mb]'; end
%if strcmp(namV,'T'), kl=1; end		% <-- to get surf.Temp
 if kl > 0, titv=[titv,'\_',int2str(kl)];
   fprintf([' var= ',namV,' at level k= %i \n'],kl);
 end

 if flag == 1
%--
  ng=ng+1;
%- reset "ng" to jv for fix fig number (independent of which one is in list_on):
  %ng=jv;
  figure(ng); set(ng,'position',[fxb+100*ng fyb+40*ng 500 700]);clf;
  var=squeeze(vv1(1+kl,:,1,:,:)); dd=zeros(5,Nexp); av=zeros(5,Nexp);
  for n=1:Nexp,
   tmp=var(isA(n):ieA(n),:,n); [I]=find(tmp(:,1)==undef); tmp(I,:)=0;
   av(:,n)=sum(tmp);
   if length(I) < size(tmp,1), av(:,n)=av(:,n)/(size(tmp,1)-length(I)); end
   tmp(I,:)=NaN; dd(:,n)=max(tmp)-min(tmp);
  end
  var(find(var==undef))=NaN;
  for nv=1:4,
    subplot(410+nv); ttmn=' Mx-mn:'; ttav=' Av:';
    for n=1:Nexp,
      plot(ttA(isA(n):ieA(n),n),var(isA(n):ieA(n),nv,n),linA(n,:));
      if n == 1, hold on ; end ;
      ttmn=sprintf([ttmn,' %2.1e ;'],dd(nv,n));
      ttav=sprintf([ttav,' %3.2e ;'],av(nv,n));
    end ; hold off ;
    AA=axis ; dAA=AA(4)-AA(3);
    if AA(3)*AA(4) <= 0, AA(3)=min(AA(3),-dAA/10); AA(4)=max(AA(4),dAA/10); end
    if ttax1 < ttax2, AA(1)=ttax1; AA(2)=ttax2; end;
    axis(AA); grid ;
    if nv == 1, title(['Avr ',titv,'  ',ttmn]); end
    if nv == 2, title(['Std-Dev ',titv,'  ',ttav]); end
    if nv == 3, title(['min ',titv,'  ',ttav]); legend(namLg,0); end
    if nv == 4, title(['Max ',titv,'  ',ttav]); end
  end ; xlabel(titT);
%--
  axes('position',[.01,.01,.99,.99],'Visible','off');
  T=text(0.5,0.97,titall);
  set(T,'HorizontalAlignment','center','FontSize',12);
  Td=text(0.99,0.01,date);
  set(Td,'HorizontalAlignment','right','FontSize',6);
%---
 end

%-------------------
end

%=========================================================
