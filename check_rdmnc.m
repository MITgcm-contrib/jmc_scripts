
% $Header:  $
% $Name:  $

%- matlab script to test mnc output file: 
%  use rdmnc to read netcdf output files and print dimensions of fields.

%rDir='fizhi-cs-aqualev20/build/';
%rDir='global_ocean.90x40x15/build/';
%rDir='hs94.cs-32x32x5/build/';
%rDir='ideal_2D_oce/build/';
%rDir='isomip/build/';
%rDir='isomip/tr_run.htd/';
%rDir='lab_sea/build/';
%rDir='MLAdjust/build/';
%rDir='MLAdjust/tr_run.0.leithD/';
%rDir='MLAdjust/tr_run.0.leith/';
%rDir='MLAdjust/tr_run.0.smag/';
%rDir='MLAdjust/tr_run.1.leith/';
%rDir='rotating_tank/build/';
%rDir='tutorial_barotropic_gyre/build/';
 rDir='internal_wave/build/';


cd(rDir);
here=pwd;
fprintf(['======== check output from: ',here,' ========\n']);
listF=dir('mnc_test_0001/*.t001.nc');

for n=1:size(listF,1),
  namf=listF(n).name;
  nam2=['mnc_test_0001/',namf(1:end-7),'*.nc'];
  fprintf(['file:>',nam2,'<\n']);
  S=rdmnc(nam2);
  listV=fieldnames(S);
  for i=1:size(listV,1), cvar=char(listV(i)); fprintf([' ',cvar]); end; fprintf('\n');
  j=0; for i=1:size(listV,1), cvar=char(listV(i)); siz=size(S.(cvar)); 
   if prod(siz) ~= siz(1), j=j+1; fprintf([' > ',cvar,' :']); 
       fprintf(' %i',size(S.(cvar))); fprintf(' < |');
       if rem(j,4) == 0, fprintf('\n'); end
   end
  end;
  if rem(j,4) ~= 0, fprintf('\n'); end
end
cd ../..
