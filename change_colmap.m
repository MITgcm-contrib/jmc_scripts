function [col,mapC]=change_colmap(kchg);
% CHANGE_COLMAP :: simple function to modify the default colormap
%   [col,mapC]=change_colmap(-1) :: replace 1rst color with white
%   [col,mapC]=change_colmap(2)  :: I don't remember ...

% $Header:  $
% $Name:  $

 col=[1:64];
 colormap('default'); mapC=colormap; 
if kchg == -1,
  mapC(1,:)=[1 1 1]; colormap(mapC);
elseif kchg == 2,
 col(3:18)=[46 33 44 27 42:-2:20] ; col(9)=51; col(13)=50; col(16)=35;
 col(19:34)=[58 49:-2:37 23 48 31 43 30 25:-2:21]; col(23)=52;
 col(35:47)=[29 53:64]; col(41)=38;
 col(48:64)=19:-1:3;
 map2=zeros(64,3); map2([1:64],:)=mapC(col([1:64]),:); mapC=map2;
 mapC(1,:)=[1 1 1]; colormap(mapC);
end
return

