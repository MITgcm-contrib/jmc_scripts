
%namA={'u04','u06'};
 namA={'s01','n01','u01'};
%namA={'n01','n05','n11','n15'};
%namA={'u01','u05','u11','u15'};

%sfx={'.cg2Mx','.cg3Mx'};
 sfx={'.cg2Mx','.cg3Mx','.cg2it','.cg3it','.iRes2','.iRes3','.lRes2','.lRes3'};
%sfx={'.cg2Mx','.cg2it','.iRes2','.lRes2'};

%- just to get time-axis:
% deltaT=60.; % <-- get this from *.parms, for each exp.

Nexp=size(namA,2);
nbV=size(sfx,2);

namLg=namA ; namLg=strrep(namLg,'_','\_');

nRec=zeros(nbV,Nexp);
for n=1:Nexp,

  fprintf('loading "%s", var:',char(namA(n)));

  %- first load parameters:
    namV='.parms';  dBug=0;
    namf=[char(namA(n)),namV];
    fprintf(' %s',namV(2:end));
    [P(n),nbp] = load_parms( namf, dBug );

  %- then load Monitor Iters
    namV='.Iter';
    namf=[char(namA(n)),namV];
    fprintf(' %s',namV(2:end));
    tmp=load(namf);
    nit=length(tmp);
    if n == 1, itMon=zeros(nit,Nexp); end
    itMon(1:nit,n)=tmp(1:nit);

  for nv=1:nbV,
    namV=char(sfx(nv));
    namf=[char(namA(n)),namV];
    fprintf(', %s',namV(2:end));
    tmp=load(namf);
    if nv == nbV, fprintf(' <- done\n'); end
    nit=length(tmp);
    if n*nv == 1, vAll=zeros(nit,nbV,Nexp); end
    nRec(nv,n)=nit;
    vAll(1:nit,nv,n)=tmp(1:nit);
  end

end

%-- ini_res & last_res : multiply by rhsMax if using cg2d/cg3dNormaliseRHS
I=strcmp(sfx,'.cg2Mx'); j2=find(I == 1); if length(j2) ~= 1, j2=0; end
I=strcmp(sfx,'.cg3Mx'); j3=find(I == 1); if length(j3) ~= 1, j3=0; end
scale=zeros(nbV,1);
for nv=1:nbV;
  namV=char(sfx(nv));
  if strcmp(namV(3:6),'Res2'), scale(nv)=j2; end
  if strcmp(namV(3:6),'Res3'), scale(nv)=j3; end
end
%scale=zeros(nbV,1);
for n=1:Nexp,
  if ( j2*P(n).cg2dTargetResWunit < 0. || j3*P(n).cg3dTargetResWunit < 0. ),
    tmp=char(namA(n));
    fprintf(' exp. %s , scale Residual by rhsMax :',tmp);
    for nv=1:nbV,
      jj=scale(nv);
      if ( jj == j2 && P(n).cg2dTargetResWunit >= 0. ), jj= 0; end
      if ( jj == j3 && P(n).cg3dTargetResWunit >= 0. ), jj= 0; end
      if jj > 0,
        fprintf(' %s ,',char(sfx(nv)) );
        nit=nRec(nv,n);
        if nit == nRec(jj,n),
          vAll(1:nit,nv,n)=vAll(1:nit,nv,n).*vAll(1:nit,jj,n);
        else
          %- get corresponding time-series of rhsMax:
          %- rhsMax printed every time-step ; residual only at multiple of monitorFreq
          n2j=nRec(jj,n);
          if mod(n2j,nit) > 0,
            %-- not clear what to do if length of simulation not multiple of monitorFreq
            fprintf('\n record Number matching Fail !\n');
          else
            %- if nIter0 multiple of monitorFreq, matching is with the last in [1:frq]
            frq=n2j/nit;
            var=reshape(vAll(1:n2j,jj,n),[frq nit]);;
            vAll(1:nit,nv,n)=vAll(1:nit,nv,n).*var(frq,:)';
          end
        end
      end
    end
    fprintf(' \n');
  end
end
%=========================================================
lThick=0; %- default line thickness
linA={'k-','b-','r-','g-','m-','c-'};
  lThick=1.5;

ng=0; fxb=100; fyb=60; fdx=100; fdy=40; fsc=1.;
  fyb= 30;  fxb= 50;   fdy=30; fsc=1.;
% fyb= 160; fxb=-2600; fdy=60; fsc=1.5;

nbSp=2;
sbp=nbSp*100+10;

ns=0;
for nv=1:nbV;
 ns=mod(ns,nbSp);
 if ns == 0,
  ng=ng+1;
  figure(ng); set(ng,'position',[fxb+fdx*ng fyb+fdy*ng [500 700]*fsc]);clf;
 end
 ns=ns+1;
  namV=char(sfx(nv));
  rhsMax=strcmp(namV(5:6),'Mx');

  subplot(sbp+ns)
  hold on;
  for n=1:Nexp,
   nit=nRec(nv,n);
   xtim=[1:nit]; var=vAll(1:nit,nv,n);
   if ~rhsMax ,
    %xtim(1:nit)=itMon(2:nit+1,n)-itMon(1,n)+1;
     xtim=itMon(2:nit+1,n);
    %xtim=xtim-itMon(1,n);
   end
   %-- Convert iter number to time (in h) for X-axis units:
   deltaT=P(n).deltaTClock ;
   xtim=xtim*deltaT/3600; titxax='time [h]';
   plot(xtim,var,char(linA(n)));
   if n==1, xt1=xtim(1);          xt2=xtim(nit);
   else xt1=min(xtim(1),xt1); xt2=max(xtim(nit),xt2); end
  end
  hold off
  %-- round-off by xtFac
  xtFac=1; %xtFac=5;
  xt1=floor(xt1/xtFac)*xtFac; xt2=ceil(xt2/xtFac)*xtFac;
  % fprintf(' -- %s , time_S,E: %f , %f\n',namV,xt1,xt2);
  AA=axis; axis([xt1 xt2 AA(3:4)]);
  legend(namLg,'Location','best');
  grid;
  xlabel(titxax);
  titv=namV(2:end);
  title(titv);

end
