 prefix='dynStD';
%prefix='oceStD';
 pCoords=0;
 namA='c06';
 Nexp=1; Nc=size(namA,2);
 nAvr=1;
%- to plot annual mean instead of 10.d aver:
%nAvr=36;
%--

% $Header: /u/gcmpack/MITgcm_contrib/jmc_script/plot_StD.m,v 1.4 2015/03/05 20:57:26 jmc Exp $
% $Name:  $

nItMx=1e10*ones(1,Nexp); %nItMx(3)=11;
%nItMx=60*ones(1,Nexp);
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
%listV={'Eta','U','V','W','T','S','CONVADJ','DETADT2'};
%listV={'Eta','UE_VEL_C','VN_VEL_C','W','T','DETADT2','Phi'};
%- or take all them:
 clear listV ; listV='all_flds';
%-----------

%- start to read the longest record:
  n=1; rf=-1; if strcmp(char(listV),'all_flds'), rf=0; end
  [ntA(n),rList,tim,vv1,listV,kList] = ...
    read_StD(prefix,namA(n,:),listV);
  nIt=ntA(n); nk=size(vv1,1); nRg=size(vv1,3);
  vv1(find(vv1==undef))=NaN;
%- set global dims: & load vvA --> vvB
  nbV=size(listV,2);
  nrec=nIt; n3d=nk; nReg=nRg;
  vvA=zeros(n3d,nrec,nReg,5,nbV,Nexp); tiA=zeros(nrec,2,Nexp);
  vvA(1:nk,1:nIt,1:nRg,:,:,n)=vv1; tiA(1:nIt,:,n)=tim;
%----
 for n=2:Nexp,
  [ntA(n),rList,tim,vv1,listV] = ...
    read_StD(prefix,namA(n,:),listV);
  nIt=ntA(n); nk=size(vv1,1); nRg=size(vv1,3);
  vv1(find(vv1==undef))=NaN;
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
 ttA=ttA/3600; titT='hrs';  ttA=ttA/24 ; titT='days';
 ttA=ttA/30 ; titT='month'; ttA=ttA/12 ; titT='year';
%- change to plot annual mean:
 if nAvr > 1 & rem(nrec,nAvr)==0,
  nrec=nrec/nAvr; ntA=ntA/nAvr;
  vvA=reshape(   vvA,[n3d nAvr nrec nReg 5 nbV Nexp]);
  vvA=reshape(mean(vvA,2),[n3d nrec nReg 5 nbV Nexp]);
  ttA=reshape(   ttA,[nAvr nrec Nexp]);
  ttA=reshape(mean(ttA,1),[nrec Nexp]);
 end
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
%-

list_on=zeros(1,nbV);
nbG=10;
nbG=min(nbG,nbV); list_on(1:nbG)=1 ;
%list_on(1:6)=[1 1 1 1 1 1];
%list_on(5:7)=0;

isA=ones(1,Nexp); ieA=ntA;
%- limit the length : for search of isA <->1500y: find(ttA(:,2) == 1500)
%isA=isA*3 ; % drop the 1rst mnth (1 Monitor/10.d)
%ieA(:)=360; isA(:)=1;

linA(1,:)='k-'; % ieA(1)=60 ; % ieA(1)=1152 ;
linA(2,:)='b-';
linA(3,:)='r-';
linA(4,:)='g-';
linA(5,:)='m-';
linA(6,:)='c-';

ieA=min(ieA,nItMx);
titall=['Exp: ',namLg(1,:)];

%=========================================================

%-default: dxRed=0; dyRed=0; dxB=0.1; dyB=0.9;
dxRed=0; dyRed=0.03; dxB=0.02; dyB=0.9;
[xyP,xyB]=def_subP(-4,dxRed,dyRed,dxB,dyB);
xyP(:,2)=xyP(:,2)+0.010;
xyB(:,2)=xyB(:,2)+0.010;

fxb=100; fyb=60;
%fxb=-2600; fyb=160; %fxb=100;

for ng=1:nbV,
%-------------------
 yax=[1:nk-1]; if pCoords == 0, yax=-[1:nk-1]; end
 flag=list_on(ng);
 vv1=vvA(:,:,:,:,ng,:); namV=char(listV(ng));
 titv=strrep(namV,'_','\_');
 if strcmp(namV,'Eta') & pCoords == 1, vv1=vv1/100; titv='Eta [mb]'; end
 if strcmp(namV,'T') & pCoords == 1,
   namfil=['../res_',namA(1:end),'/RC']; D=dir([namfil,'.data']);
   if size(D,1) == 1,
     rC=rdmds(namfil);
     fprintf(' convert Pot.Temp to Temp.:');
%    fprintf(' convert Pot.Temp to Temp.:'); fprintf(' %i',size(vv1));
     kappa=2/7; facP=squeeze(rC)/1.e+5; facP=facP.^kappa;
     var=facP*ones(1,nrec*4*Nexp); var=reshape(var,[nk-1 nrec 1 4 Nexp]);
     vv1([2:nk],:,1,[1:4],:)=vv1([2:nk],:,1,[1:4],:).*var;
%    for k=2:nk, vv1(k,:,1,[1:4],:)=vv1(k,:,1,[1:4],:)*facP(k-1); end
     fprintf(' OK\n');
   else
     fprintf(' no file: %s\n',namfil);
   end
 end

 if flag == 1
%--
  figure(ng); set(ng,'position',[fxb+100*ng fyb+40*ng 500 700]);clf;
  colormap jet
  if kList(ng) == 1,
   var=squeeze(vv1(1,:,1,:,:));
   dd=squeeze(max(var)-min(var)); av=squeeze(mean(var));
   if Nexp == 1, av=av'; dd=dd'; end ;
   for nv=1:4,
    axes('position',xyP(nv,:)); ttmn=' Mx-mn:'; ttav=' Av:';
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
    if nv == 1, title(['Avr ',titv,'  ',ttmn]); xlabel(titT); end
    if nv == 2, title(['Std-Dev ',titv,'  ',ttav]); end
    if nv == 3, title(['min ',titv,'  ',ttav]); legend(namLg(1:Nexp,:),0); end
    if nv == 4, title(['Max ',titv,'  ',ttav]); end
   %if nv == 2, title(['Del-2 ',titv,'  ',ttav]); end
   end ; %xlabel(titT);
  else
   n=1; k1=2;
   if strcmp(namV,'CONVADJ') || strcmp(namV,'DRHODR'),
     k1=3; yax=yax(2:nk-1);
   end
   for nv=1:4,
    axes('position',xyP(nv,:));
    var=squeeze(vv1(k1:nk,:,1,nv,n))'; mnV=min(var(:)); MxV=max(var(:));
    ccv=c_levs(mnV,MxV,-12); %ccv=c_levs(mnV,MxV,-20);
    if MxV > mnV,
     [cs,h]=contour(ttA(isA(n):ieA(n),n),yax,var(isA(n):ieA(n),:)',ccv);
    %clabel(cs);isoline0(h);
     BB=colorbar; set(BB,'Position',xyB(nv,:));
    end
    if nv == 1, title(['Avr ',titv]); xlabel(titT); end
    if nv == 2, title(['Std-Dev ',titv]); end
    if nv == 3, title(['min ',titv]); ; end
    if nv == 4, title(['Max ',titv]); end
    AA=axis; dAA=AA(4)-AA(3);
    ttmn=sprintf('mn= %4.3g , Mx= %4.3g',mnV,MxV);
    text(AA(1)*.4+AA(2)*.6,AA(3)-0.20*dAA,ttmn);
   end ; %xlabel(titT);
  end
%--
  axes('position',[.01,.01,.99,.99],'Visible','off');
  T=text(0.2,0.98,titall);
  set(T,'HorizontalAlignment','center','FontSize',12);
  Td=text(0.01,0.01,date);
  set(Td,'HorizontalAlignment','left','FontSize',6);
%---
 end

%-------------------
end

%=========================================================
