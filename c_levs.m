function [ctl]=c_levs(mn,Mx,dc,dBug);
% [ctl]=c_levs(mn,Mx,dc,[option]);
%- return contour levels
%  dc > 0 : select contour-levels as multiple of "dc" within [mn,Mx]
%  dc < 0 : select aproximatively |dc| contour levels, within [mn,Mx]

% $Header:  $
% $Name:  $

if nargin < 3,
  error('Not enough argument (need at least 3)');
  return
end
if nargin < 4, dBug=0; end

if dc > 0,
  dd=dc;
else
  d0=(mn-Mx)/dc;
  k0=log(d0)/log(10); 
  kd=round(k0); 
  pp=10.^kd; 
  dd=round(d0/pp);
  if dd == 0, 
    kd=floor(k0); 
    pp=10.^kd; 
    dd=round(d0/pp);
  end
  dd=pp*dd;
  if dBug > 0, fprintf(' -dc= %i ; d0 = %e ; kd,k0= %i,%f ; pp=%e ; dd=%e\n', ...
               -dc,d0,kd,k0,pp,dd); end
end

ctl=[ceil(mn/dd):floor(Mx/dd)]*dd;

return
