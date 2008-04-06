%- matlab script to write 1 global pickup file from a set of tiled pickup files
%  to start, type: >> rdwrpick

% $Header:  $
% $Name:  $

namInp='pickup';

 fprintf(' suffix for pickup file: 0=std ; 1=nh ; 2=cd ; 3=seaice ; 4=ice ; 5=pTrs\n');
%kr=input('   8=fizhi ; 9=vegtiles ; select one those: ? \n');
 kr=input('   6=land ; 7=cpl ; 8=fizhi ; 9,10=somT,S ; select one those: ? \n');
switch kr
 case 1,  namInp=[namInp,'_nh'];
 case 2,  namInp=[namInp,'_cd'];
 case 3,  namInp=[namInp,'_seaice'];
 case 4,  namInp=[namInp,'_ic'];
 case 5,  namInp=[namInp,'_ptracers'];
 case 6,  namInp=[namInp,'_land'];
 case 7,  namInp=[namInp,'_cpl'];
 case 8,  namInp=[namInp,'_fizhi'];
%case 9,  namInp=[namInp,'_vegtiles'];
 case 9,  namInp=[namInp,'_somT'];
 case 10, namInp=[namInp,'_somS'];
end
 
nit=input([' put together all partial ',namInp,  ...
           ' files : input n_iter = ? (-1,-2:ckptA,B) \n']);

if nit < 0,
 if nit == -1, namfil=[namInp,'.ckptA'];
 else namfil=[namInp,'.ckptB'];
 end
else
 namfil=fname(namInp,nit);
end
%-----------
%u,gu,gum v,gv,gvm, t,gt,gtm, s,gs,gsm, eta 

fprintf(['read files: ',namfil,'* \n \n']);
va=rdmds(namfil); 
%fprintf(' read full size : %i %i %i \n \n',size(va));
fprintf(' read full size :'); fprintf(' %i',size(va)); fprintf('\n\n');

wrfile=[namfil,'.Uni.data'];
fid=fopen(wrfile,'w','b');
fwrite(fid,va,'real*8');
fclose(fid);

fprintf([' ==> write file: ',wrfile,'\n']);

return
