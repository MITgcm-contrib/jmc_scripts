function [xyP,xyB]=def_subP(n,dxRed,dyRed,dxB,dyB);
% [xyP,xyB]=def_subP(n,dxRed,dyRed,dxB,dyB);
%
%     n = number of subplot in the page
% dxRed = reduction of Horizon. size (x-dir) on the right side
% dyRed = reduction of Vertical size (y-dir) splitted on both side
%         both dxRed,dyRed applies to all subplot
% dxB,dyB :: scaling factor (relative to sub-plot size) of vertical colorbar
%
%- to use:  [xyP,xyB]=def_subP(n*m,[dxRed,dyRed,dxB,dyB]);
% and then, to replace subplot(nmj):
%  axes('position',xyP(j,:)); {make the plot}
%  BB=colorbar; set(BB,'Position',xyB(j,:));

% $Header: /u/gcmpack/MITgcm_contrib/jmc_script/def_subP.m,v 1.1 2014/09/30 22:10:26 jmc Exp $
% $Name:  $

if nargin < 2, dxRed=0; end
if nargin < 3, dyRed=0; end
if nargin < 4, dxB=0.1; end
if nargin < 5, dyB=0.9; end
xyP=zeros(abs(n),4); xyB=xyP;

if n == 24,
%-- to replace subplot(64?):
xyP(:,1)=0.12/4  ; xyP(:,2)=0.10/6;
xyP(:,3)=0.84/4; ; xyP(:,4)=0.80/6;
xyP([2:4:n],1)=xyP(21,1)+0.90/4;
xyP([3:4:n],1)=xyP(21,1)+1.94/4;
xyP([4:4:n],1)=xyP(21,1)+2.90/4;
xyP( 1:4 ,2)=xyP(21,2)+4.86/6;
xyP( 5:8 ,2)=xyP(21,2)+3.94/6;
xyP( 9:12,2)=xyP(21,2)+2.86/6;
xyP(13:16,2)=xyP(21,2)+1.94/6;
xyP(17:20,2)=xyP(21,2)+0.90/6;
%-- to add a vertical colorbar on the 6th plot without changing its size:
%----------
end

if n == 8,
%-- to replace subplot(42?):
 xyP(:,1)=0.12/2  ; xyP(:,2)=0.10/4;
 xyP(:,3)=0.84/2  ; xyP(:,4)=0.80/4;
 xyP([2:2:n],1)=xyP(7,1)+0.5;
 xyP(1:2,2)=xyP(7,2)+2.85/4;
 xyP(3:4,2)=xyP(7,2)+1.90/4;
 xyP(5:6,2)=xyP(7,2)+0.95/4;
%-- reduction size in X dir:
 xyP([2:2:n],1)=xyP([2:2:n],1)-dxRed*xyP(1,3);
 xyP(:,3)=xyP(:,3)*(1-dxRed);
end

if n == 6,
%-- to replace subplot(32?):
 xyP(:,1)=0.12/2  ; xyP(:,2)=0.10/3;
 xyP(:,3)=0.84/2  ; xyP(:,4)=0.80/3;
 xyP([2:2:n],1)=xyP(5,1)+0.5;
 xyP(1:2,2)=xyP(5,2)+1.9/3;
 xyP(3:4,2)=xyP(5,2)+0.95/3;
%-- reduction size in X dir:
 xyP([2:2:n],1)=xyP([2:2:n],1)-dxRed*xyP(1,3);
 xyP(:,3)=xyP(:,3)*(1-dxRed);
%-- to add a vertical colorbar on the 6th plot without changing its size:
%xyP(6,3)=xyP(6,3)*1.17;
%--and after drawing the 6th plot:later:
%    BB=colorbar('vertical');
%    pos=get(BB,'position');
%    pos(1)=.49; pos(3)=pos(3)/5; pos(2)=pos(2)+pos(4)*.1; pos(4)=pos(4)*.8;
%    set(BB,'position',pos);
%----------
end

if n == 4,
%-- to replace subplot(22?):
%  [xyP,xyB]=def_subP(6); axes('position',xyP(j,:)); {make the plot}
%  BB=colorbar; set(BB,'Position',xyB(j,:));
 xyP(:,1)=0.10/2 ; xyP(:,2)=0.10/2;
 xyP(:,3)=0.80/2 ; xyP(:,4)=0.84/2;
 xyP([2:2:n],1)=xyP(1,1)+0.92/2;
 xyP(1:2,2)=xyP(n,2)+0.98/2;
%-- reduction size in X dir:
 xyP([2:2:n],1)=xyP([2:2:n],1)-dxRed*xyP(1,3);
 xyP(:,3)=xyP(:,3)*(1-dxRed);
%----------
end

if n == -4,
%-- to replace subplot(41?): [xyP]=def_subP(-4); axes('position',xyP(?,:));
 xyP(:,1)=0.10 ; xyP(:,2)=0.16/4;
 xyP(:,3)=0.78 ; xyP(:,4)=0.72/4;
%xyP(2:4,2)=xyP(1,2)+[1:3]*(0.98/4); %- put the 1rst @ the bottom
 xyP(1:3,2)=xyP(4,2)+[3:-1:1]*(0.98/4); %- put the 1rst @ the top
%-- reduction size in X dir:
 xyP(:,3)=xyP(:,3)*(1-dxRed);
%----------
end

if n == 3,
%-- to replace subplot(31?): [xyP]=def_subP(3); axes('position',xyP(?,:));
 xyP(:,1)=0.10 ; xyP(:,2)=0.10/3;
 xyP(:,3)=0.84 ; xyP(:,4)=0.80/3;
 xyP(1,2)=xyP(n,2)+1.9/3;
 xyP(2,2)=xyP(n,2)+0.95/3;
%-- reduction size in X dir:
 xyP(:,3)=xyP(:,3)*(1-dxRed);
%----------
end

if n == -3,
%-- to replace subplot(13?): [xyP]=def_subP(-3); axes('position',xyP(?,:));
 xyP(:,1)=0.10/3 ; xyP(:,2)=0.10;
 xyP(:,3)=0.80/3 ; xyP(:,4)=0.84;
 xyP(2,1)=xyP(1,1)+0.95/3;
 xyP(3,1)=xyP(1,1)+1.9/3;
%-- reduction size in X dir:
%xyP(2,1)=xyP(2,1)-dxRed*xyP(1,3);
 xyP(:,3)=xyP(:,3)*(1-dxRed);
%----------
end

if n == 2,
%-- to replace subplot(21?): [xyP]=def_subP(2); axes('position',xyP(?,:));
 xyP(:,1)=0.10 ; xyP(:,2)=0.10/2;
 xyP(:,3)=0.84 ; xyP(:,4)=0.80/2;
 xyP(1,2)=xyP(n,2)+0.98/2;
%-- reduction size in X dir:
 xyP(:,3)=xyP(:,3)*(1-dxRed);
%----------
end

if n == -2,
%-- to replace subplot(12?): [xyP]=def_subP(-2); axes('position',xyP(?,:));
 xyP(:,1)=0.10/2 ; xyP(:,2)=0.10;
 xyP(:,3)=0.80/2 ; xyP(:,4)=0.84;
 xyP(2,1)=xyP(1,1)+0.92/2;
%-- reduction size in X dir:
%xyP(2,1)=xyP(2,1)-dxRed*xyP(1,3);
 xyP(:,3)=xyP(:,3)*(1-dxRed);
%----------
end

%- reduce size in Y by dyRed fraction:
 xyP(:,2)=xyP(:,2)+xyP(:,4)*dyRed/2;
 xyP(:,4)=xyP(:,4)*(1.-dyRed);

%- colorbar position
 xyB(:,1)=xyP(:,1)+xyP(:,3)*(1+dxB);
 xyB(:,2)=xyP(:,2)+xyP(:,4)*(1-dyB)/2;
 xyB(:,3)=xyP(:,3)*dxB;
 xyB(:,4)=xyP(:,4)*dyB;

return
