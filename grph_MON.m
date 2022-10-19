
%namA={'s05'};
 namA={'s19c','s19'};
%namA={'s19c','s19','s19a'};
%namA={'s18c','s18b','s18a','s01'};
%namA={'s19a','s19','s18c','s18b','s18a','s04'};
%namA={'s19c','s19','s19a','s18b','s18a','s01','s04'};
 Nexp=size(namA,2); list_log=zeros(1,10);
%list_log=[1 0 0 1 1 1 1 1 0 0] ;
%-- set type of monitor output files: ncF=0 : ASCII output file ; ncF=1 : NetCDF file
ncF=zeros(1,Nexp);

% $Header: /u/gcmpack/MITgcm_contrib/jmc_script/grph_MON.m,v 1.3 2022/02/08 17:10:21 jmc Exp $
% $Name:  $

nItMx=1e10*ones(1,Nexp); %nItMx(3)=11;
namLg=namA ; namLg=strrep(namLg,'_','\_');
%-----------
%- ngEn = Nb of Energy plot: = 2 (ke: Mx+Av) ; = 3 (+AM) or = 4 (add Pe ?) ;
ngEn=2;
%- in case PE is missing from Monitor, use Mean-Eta and this "gdH" ratio to get PE
gdH=9.81/1000 ; % ratio gravity / mean_H (ocean) ; mean_Bo / mean_Pground (atmos)
%- test if the variable krd is define :
if size(who('krd'),1) > 0,
 fprintf('krd is defined and = %i \n',krd);
else
 fprintf('krd undefined ; set to 1 \n'); krd=1 ;
end
if krd == 1,
% list_on : controls which field to read-in (and plot):
%  1 : KE ; 2 : Eta ; 3,4 : T,S ; 5,6 : U,V ; 7 : W ; 8 : CFL ; 9 : Vort ; 10 : "sc"
%list_on=[1 1 1 1 0 0 1 1 0 0] ;
 list_on=[1 1 1 1 1 1 1 1 0 0] ;
%list_on=[1 1 0 0 0 0 0 0 1 1] ;
%- Warning: list_log works with fig # and do not match list_on !
%list_log=zeros(1,length(list_on));
%-----------

%- start to read the longest record:
  n=1;
  if ncF(n) == 1,
   [ntA(n),ttA(:,n),keA(:,:,n),etA(:,:,n),tmA(:,:,n),smA(:,:,n), ...
       umA(:,:,n),vmA(:,:,n),wmA(:,:,n),cfA(:,:,n),zmA(:,:,n),scA(:,:,n)] = ...
     readnc_MON(char(namA(n)),list_on);
  else
   [ntA(n),ttA(:,n),keA(:,:,n),etA(:,:,n),tmA(:,:,n),smA(:,:,n), ...
       umA(:,:,n),vmA(:,:,n),wmA(:,:,n),cfA(:,:,n),zmA(:,:,n),scA(:,:,n)] = ...
     read_MON(char(namA(n)),list_on);
  end
  nrec=ntA(1);
 for n=2:Nexp,
  if ncF(n) == 1,
   [ntA(n),ttA(:,n),keA(:,:,n),etA(:,:,n),tmA(:,:,n),smA(:,:,n), ...
       umA(:,:,n),vmA(:,:,n),wmA(:,:,n),cfA(:,:,n),zmA(:,:,n),scA(:,:,n)] = ...
     readnc_MON(char(namA(n)),list_on,nrec);
  else
   [ntA(n),ttA(:,n),keA(:,:,n),etA(:,:,n),tmA(:,:,n),smA(:,:,n), ...
       umA(:,:,n),vmA(:,:,n),wmA(:,:,n),cfA(:,:,n),zmA(:,:,n),scA(:,:,n)] = ...
     read_MON(char(namA(n)),list_on,nrec);
  end
 end;
 vol=squeeze(keA(:,3,:)); if vol(1,1) ~= 0,
  for n=1:Nexp, vol(:,n)=vol(:,n)/vol(1,n); end; end; % <- volume ratio = V/Vo
 %vol=squeeze(etA(:,3,:)); vol=(vol+1000)/1000 ;
%------------------
 if ngEn == 4,
  tt2e=' (+) '; tt3e=' (+) '; tt4e=' (+) ';
  for n=1:Nexp,
    keA(:,1,n)=etA(:,2,n)-etA(:,1,n);
    ddKe=max(keA(:,4,n));
     if ddKe > 0, keA(:,3,n)=keA(:,4,n); %- take PE from Monitor (since it's there)
     else keA(:,3,n)=etA(:,4,n).*etA(:,4,n);
          keA(:,3,n)=keA(:,3,n)*gdH/2; end
    keA(:,4,n)=keA(:,3,n)+keA(:,2,n);
   tt2e=sprintf([tt2e,' %1.1e ;'],keA(1,2,n)); keA(:,2,n)=keA(:,2,n)-keA(1,2,n);
   tt3e=sprintf([tt3e,' %1.1e ;'],keA(1,3,n)); keA(:,3,n)=keA(:,3,n)-keA(1,3,n);
   tt4e=sprintf([tt4e,' %1.1e ;'],keA(1,4,n)); keA(:,4,n)=keA(:,4,n)-keA(1,4,n);
  end
 else tt2e=' ' ; tt3e=' ' ; tt4e=' ' ; end;
 %-- set time units:
  titT='s'   ;  ttA=ttA/60; titT='mn' ;
  ttA=ttA/3600; titT='hrs' ;  ttA=ttA/24; titT='days';
  ttA=ttA/30 ; titT='month';  ttA=ttA/12 ; titT='year';
end
%-----------

ttax1=0 ; ttax2=0 ; ttay=zeros(size(list_on,2),2);
%-- fixed time axis bound :
% ttax1=3; ttax2=3.3;
%-- fixed Y axis bound :
% ttay(4,:)=[0 0.6];
%=========================================================
fprintf('Total length: ntA=');fprintf(' %i ,',ntA); fprintf(' \n');
for n=1:Nexp,
fprintf(' exp %i : time(d):%10.2f ->%10.2f \n', n,ttA(1,n),ttA(ntA(n),n) );
end;
%--

isA=ones(1,Nexp); ieA=ntA ;
%- limit the length : for search of isA <->1500y: find(ttA(:,2) == 1500)
%isA=isA*31 ; % drop the 1rst mnth
%ieA(1)=1681; ieA(2)=281;

linA={'k-','b-','r-','g-','m-','c-'};
%linA={'k-','k--','b-','r-','g-','m-','c-'};

ieA=min(ieA,nItMx);
%titall='AIM , Cubic-G (32x32) , NCEP Forc (2)' ;
 titall='S.Ocean Section (320x50), CORE Forcing' ;
%titall='Enceladus with Ice, Lat-Lon half-sphere' ;

%=========================================================
ng=0; fxb=100; fyb=60; fsc=1.5;
%fxb=-2600; %fyb=160;

for ng=1:size(list_on,2)
%-------------------
 flag=0;
 if ng == 1, flag=2*list_on(1) ; titv='Ke [m2/s2]'  ; vvA=keA ; end
 if ng == 2, flag=1*list_on(3) ; titv='Theta [K]'   ; vvA=tmA ; end
 if ng == 3, flag=1*list_on(4) ; titv='Salin [psu]' ; vvA=smA ; end
%if ng == 3, flag=1*list_on(4) ; titv='Spe.Hum [g/kg]';vvA=smA; end
 if ng == 4, flag=3*list_on(8) ; titv='CFL-max'     ; vvA=cfA ; end
 if ng == 5, flag=1*list_on(2) ; titv='Eta [m]'     ; vvA=etA ; end
 if ng == 6, flag=1*list_on(7) ; titv='W-vel [m/s]' ; vvA=wmA ; end
%if ng == 5, flag=1*list_on(2) ; titv='Eta [mb]'; vvA=etA/100 ; end
%if ng == 6, flag=1*list_on(7) ; titv='W-vel [Pa/s]'; vvA=wmA ; end
 if ng == 7, flag=1*list_on(5) ; titv='U-vel [m/s]' ; vvA=umA ; end
 if ng == 8, flag=1*list_on(6) ; titv='V-vel [m/s]' ; vvA=vmA ; end
 if ng == 9, flag=4*list_on(9) ; titv= 'Vort [s-1]' ; vvA=zmA ; end

 if flag == 1
%--
  figure(ng); set(ng,'position',[fxb+100*ng fyb+40*ng [500 700]*fsc]);clf;
  dd=squeeze(max(vvA)-min(vvA)); av=squeeze(mean(vvA));
   if Nexp == 1, av=av'; dd=dd'; end ;
  for nv=1:4,
    subplot(410+nv); ttmn=' Mx-mn:'; ttav=' Av:'; ttyax='';
    if list_log(ng) > 0,
      var=zeros(nrec,Nexp); for n=1:Nexp, var(isA(n):ieA(n),n)=vvA(isA(n):ieA(n),nv,n); end
      if min(var(:))*max(var(:)) >= 0, msk=var; ttyax='log';
        var(find(msk==0))=1; var=log10(abs(var)); var(find(msk==0))=NaN;
      end
    else var=squeeze(vvA(:,nv,:)); end
    for n=1:Nexp,
      plot(ttA(isA(n):ieA(n),n),var(isA(n):ieA(n),n),char(linA(n)));
      if n == 1, hold on ; end ;
      ttmn=sprintf([ttmn,' %2.1e ;'],dd(nv,n));
      ttav=sprintf([ttav,' %3.2e ;'],av(nv,n));
    end ; hold off ;
    if ttax1 < ttax2, AA=axis; axis([ttax1 ttax2 AA(3:4)]); end;
    AA=axis ; dAA=AA(4)-AA(3);
    if AA(3)*AA(4) <= 0, AA(3)=min(AA(3),-dAA/10); AA(4)=max(AA(4),dAA/10); end
    axis(AA); grid ;
   %AA=axis; text(AA(1)*.9+AA(2)*.1,AA(3)*0.1+AA(4)*0.9,ttmn);
    if nv == 1, title(['min ',titv,'  ',ttav]);
                legend(namLg,'Location','best'); end
    if nv == 2, title(['Max ',titv,'  ',ttav]); end
    if nv == 3, title(['Avr ',titv,'  ',ttmn]); end
    if nv == 4, title(['Std-Dev ',titv,'  ',ttav]); end
   %if nv == 4, title(['Del-2 ',titv,'  ',ttav]); end
    if length(ttyax) > 0, ylabel(ttyax); end
  end ; xlabel(titT);
%--
  axes('position',[.01,.01,.99,.99],'Visible','off');
  T=text(0.5,0.97,titall);
  set(T,'HorizontalAlignment','center','FontSize',12);
  put_date;
%---
 end

 if flag == 2
%--
 ngEx = ngEn ; if ngEn == 3, ngEx = 4; end ; ngEk = ngEx;
 if list_on(10) == 1, ngEx = 4; ngEk = 2; end
 if ngEx == 4,
  figure(ng); set(ng,'position',[fxb+100*ng fyb+40*ng [500 700]*fsc]);clf;
 else
  figure(ng); set(ng,'position',[fxb+100*ng fyb+140*ng [500 500]*fsc]);clf;
 end;
  dd=squeeze(max(vvA)-min(vvA)); av=squeeze(mean(vvA));
   if Nexp == 1, av=av'; dd=dd'; end ;
 % for n=1:Nexp,
 % for n=1:0,
 %   nt1=find(ttA(:,n)==4);
 %   vv1=min(vvA([nt1:ntA(n)],2,n));[I1]=find(vvA(:,2,n)==vv1);
 %   vv2=max(vvA([nt1:ntA(n)],3,n));[I2]=find(vvA(:,3,n)==vv2);
 %   if length(I1) ~= 1, I1, return ; end
 %   if length(I2) ~= 1, I2, return ; end
 %   fprintf('n= %i min(KE): %i %7.6f  ; max(PE): %i %7.6f \n',n,I1,vv1,I2,vv2);
 %   fprintf('   %i KE: %7.6f ; PE: %7.6f ',  I1-1,vvA(I1-1,2,n),vvA(I1-1,3,n));
 %   fprintf(' ; %i KE: %7.6f ; PE: %7.6f \n',I1+1,vvA(I1+1,2,n),vvA(I1+1,3,n));
 %   if n == 1, ii1=I1 ; end
 % end
  for np=1:ngEk,
    nv=np; if ngEn == 3, nv=np+1; end
    subplot(100*ngEx+10+np); ttmn=' Mx-mn:'; ttav=' Av:'; ttyax='';
    if list_log(ng) > 0,
      var=zeros(nrec,Nexp); for n=1:Nexp, var(isA(n):ieA(n),n)=vvA(isA(n):ieA(n),nv,n); end
      if min(var(:))*max(var(:)) >= 0, msk=var; ttyax='log';
        var(find(msk==0))=1; var=log10(abs(var)); var(find(msk==0))=NaN;
      end
    else var=squeeze(vvA(:,nv,:)); end
    for n=1:Nexp,
      plot(ttA(isA(n):ieA(n),n),var(isA(n):ieA(n),n),char(linA(n)));
      % LL(n)=plot(ttA(isA(n):ieA(n),n),var(isA(n):ieA(n),n),char(linA(n)));
      if n == 1, hold on ; end ;
      ttmn=sprintf([ttmn,' %2.1e ;'],dd(nv,n));
      ttav=sprintf([ttav,' %3.2e ;'],av(nv,n));
    end ; hold off ;
    % set(LL(1),'LineWidth',2);
    if ttax1 < ttax2, AA=axis; axis([ttax1 ttax2 AA(3:4)]); end;
    grid ;
    if np == 1, legend(namLg,'Location','best'); end
    if nv == 1, title(['Max ',titv,'  ',ttav]); end
    if nv == 2, title(['Avr ',titv,'  ',ttmn]); end
   if ngEn == 3,
    if nv == 3, title(['AM-eta [kg/s]   ',ttmn]); end
    if nv == 4, title(['AM-Uzo [kg/s]   ',ttmn]); end
    if nv == 5, title(['AM-Tot [kg/s]   ',ttmn]); end
   else
    if nv == 3, title('PE-eta [m2/s2]'); end
    if nv == 4, title('Tot-En [m2/s2]'); end
   end
   %if nv == 1, title('eta Max-min'); end % legend(namLg,0); end
   %if nv == 2, title(['Avr ',titv,'  ',tt2e]);legend(namLg,0); end
   %if nv == 3, title(['PE-eta [m2/s2]','  ',tt3e]); end
   %if nv == 4, title(['Tot-En [m2/s2]','  ',tt4e]); end
   if length(ttyax) > 0, ylabel(ttyax); end
  end ;
 if ngEn < 4 & list_on(10) == 1,
  titv1='surf-Cor : ' ; vvA=scA ;
  dd=squeeze(max(vvA)-min(vvA)); av=squeeze(mean(vvA));
   if Nexp == 1, av=av'; dd=dd'; end ;
  for nv=1:ngEx-ngEk,
    vvM=mean(vvA(max(2,isA(n)):ieA(n),nv,:),1);
    subplot(100*ngEx+10+nv+2); ttmn=' Mx-mn:'; ttav=' Av:';
    if nv == 1, titv2=' \theta'; else titv2=' S '; end
    if list_log(ng) > 0,
      var=zeros(nrec,Nexp); for n=1:Nexp, var(isA(n):ieA(n),n)=vvA(isA(n):ieA(n),nv,n); end
      if min(var(:))*max(var(:)) >= 0, msk=var; ttyax='log';
        var(find(msk==0))=1; var=log10(abs(var)); var(find(msk==0))=NaN;
      end
    else var=squeeze(vvA(:,nv,:)); end
    for n=1:Nexp,
      plot(ttA(isA(n):ieA(n),n),var(isA(n):ieA(n),n),char(linA(n)));
      if n == 1, hold on ; end ;
      ttmn=sprintf([ttmn,' %2.1e ;'],dd(nv,n));
      ttav=sprintf([ttav,' %3.2e ;'],av(nv,n));
    end ; hold off ;
    if ttax1 < ttax2, AA=axis; axis([ttax1 ttax2 AA(3:4)]); end;
    grid ;
   %title(['mean ',titv1,titv2]);
    title(['mean ',titv1,titv2,' ; ',ttav]);
%--
    titX='   '; for n=1:Nexp, titX=[titX,sprintf(' %4.3e,',vvM(n))]; end
    AA=axis; TM=text(AA(2),AA(3)+0.1*(AA(4)-AA(3)),titX(1:end-1));
    set(TM,'HorizontalAlignment','right');
%--
  end ;
 end ; xlabel(titT);
%--
  axes('position',[.01,.01,.99,.99],'Visible','off');
  T=text(0.5,0.97,titall);
  set(T,'HorizontalAlignment','center','FontSize',12);
  put_date;
%---
 end

 if flag == 3
%--
  figure(ng); set(ng,'position',[fxb+100*ng fyb+40*ng [500 700]*fsc]);clf;
  dd=squeeze(max(vvA)-min(vvA)); av=squeeze(mean(vvA));
  if Nexp == 1, av=av'; dd=dd'; end
  for nv=1:4,
    subplot(410+nv); ttmn=' Mx-mn:'; ttav=' Av:'; ttyax='';
    if list_log(ng) > 0,
      var=zeros(nrec,Nexp); for n=1:Nexp, var(isA(n):ieA(n),n)=vvA(isA(n):ieA(n),nv,n); end
      if min(var(:))*max(var(:)) >= 0, msk=var; ttyax='log';
        var(find(msk==0))=1; var=log10(abs(var)); var(find(msk==0))=NaN;
      end
    else var=squeeze(vvA(:,nv,:)); end
    for n=1:Nexp,
      plot(ttA(isA(n):ieA(n),n),var(isA(n):ieA(n),n),char(linA(n)));
      if n == 1, hold on ; end ;
      ttmn=sprintf([ttmn,' %2.1e ;'],dd(nv,n));
      ttav=sprintf([ttav,' %3.2e ;'],av(nv,n));
    end ; hold off ;
    if ttax1 < ttax2, AA=axis; axis([ttax1 ttax2 AA(3:4)]); end;
    if ttay(ng,1) < ttay(ng,2), AA=axis; AA(3)=max(AA(3),ttay(ng,1));
                                AA(4)=min(AA(4),ttay(ng,2)); axis(AA); end;
    grid ;
    if nv == 1, title(['U ',titv,'  ',ttav]);
                legend(namLg,'Location','best'); end
    if nv == 2, title(['V ',titv,'  ',ttav]); end
    if nv == 3, title(['W ',titv,'  ',ttav]); end
    if nv == 4, title(['W+h ',titv,'  ',ttav]); end
    if length(ttyax) > 0, ylabel(ttyax); end
  end ; xlabel(titT);
%--
  axes('position',[.01,.01,.99,.99],'Visible','off');
  T=text(0.5,0.97,titall);
  set(T,'HorizontalAlignment','center','FontSize',12);
  put_date;
%---
 end
%--

 if flag == 4
%--
% tt3i=' (+) '; for n=1:Nexp, tt3i=sprintf([tt3i,' %1.1e ;'],vvA(1,3,n));
%   vvA(:,3,n)=vvA(:,3,n)-vvA(1,3,n); end
% tt4i=' (+) '; for n=1:Nexp, tt4i=sprintf([tt4i,' %1.1e ;'],vvA(1,4,n));
%   vvA(:,4,n)=vvA(:,4,n)-vvA(1,4,n); end
  figure(ng); set(ng,'position',[fxb+100*ng fyb+40*ng [500 700]*fsc]);clf;
  dd=squeeze(max(vvA)-min(vvA)); av=squeeze(mean(vvA));
  if Nexp == 1, av=av'; dd=dd'; end
% for nv=1:6, subplot(610+nv);
  for nv=1:4, subplot(410+nv);
% for nV=1:4, nv=nV; subplot(410+nv); nv=max(1,2*(nv-1));
    ttmn=' Mx-mn:'; ttav=' Av:'; ttyax='';
    if list_log(ng) > 0,
      var=zeros(nrec,Nexp); for n=1:Nexp, var(isA(n):ieA(n),n)=vvA(isA(n):ieA(n),nv,n); end
      if min(var(:))*max(var(:)) >= 0, msk=var; ttyax='log';
        var(find(msk==0))=1; var=log10(abs(var)); var(find(msk==0))=NaN;
      end
    else var=squeeze(vvA(:,nv,:)); end
    for n=1:Nexp,
      plot(ttA(isA(n):ieA(n),n),var(isA(n):ieA(n),n),char(linA(n)));
      if n == 1, hold on ; end ;
      ttmn=sprintf([ttmn,' %2.1e ;'],dd(nv,n));
      ttav=sprintf([ttav,' %3.2e ;'],av(nv,n));
    end ; hold off ;
    if ttax1 < ttax2, AA=axis; axis([ttax1 ttax2 AA(3:4)]); end;
    grid ;
    if nv == 1, title(['min R.',titv,'  ',ttav]); end
    if nv == 2, title(['Max R.',titv,'  ',ttav]);
                legend(namLg,'Location','best'); end
%   if nv == 3, title(['av A.',titv,'  ',ttmn]); end
%   if nv == 4, title(['sd A.',titv,'  ',ttav]); end
%   if nv == 5, title(['av P.',titv,'  ',ttmn]); end
%   if nv == 6, title(['sd P.',titv,'  ',ttav]); end
    if nv == 3, title(['Std-Dev A.',titv,'  ',ttav]); end
    if nv == 4, title(['Std-Dev P.',titv,'  ',ttav]); end
  end ; xlabel(titT);
%--
  axes('position',[.01,.01,.99,.99],'Visible','off');
  T=text(0.5,0.97,titall);
  set(T,'HorizontalAlignment','center','FontSize',12);
  put_date;
%---
 end
%--

%-------------------
end

%=========================================================
