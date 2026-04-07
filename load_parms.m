function [P,nbp,allparms] = load_parms( varargin )
% function [P,nbp,allparms] = load_parms( pfname, dBug )
%
% load parameters from parameter file "pfname" into structure array "P"
%  with "nbp" the number of loaded parameters
%  and  "allparms" a long-line containing all parameter setting
%  dBug : optional, > 0 : to print loaded params

if nargin == 0
  error(['need file-name as first argument'])
else
  pfname = varargin{1};
end
if nargin > 1,
     dBug = varargin{2};
else dBug = 0; end

fid = fopen(pfname,'r');
if (fid == -1)
  nb=-2;
  error(['File' pfname ' cannot be opened'])
end

% scan each line of the parms file
nb = 0;
while nb >= 0,
  line = fgetl(fid);
  if (line == -1)
    nbp=nb; nb=-1;
  else
    nb = nb + 1;
    i2=strfind(line,'='); i1=i2-1;
    pNam=strtrim(line(1:i1));
    if dBug > 1, fprintf(' pNam= "%s" ; line= "%s"\n',pNam,line); end
    lin2= strrep(line(i2:end),' T ',' ''T'' ');
    lin1= strrep(lin2,        ' F ',' ''F'' ');
    lin2=[line(1:i1) lin1];
    eval(lin2);
    if dBug > 0, fprintf(' pNam= "%s" ; lin2= "%s"\n',pNam,lin2); end
   %-- replace boolean value F / T with just 0 / 1 (easier this way)
   % lin2=strrep(line(i2:end),' T ',' 1 ');
   % line(i2:end)=strrep(lin2,' F ',' 0 ');
   % fprintf(' pNam= "%s" ; line= "%s"\n',pNam,line);
   % if dBug > 0, fprintf(' pNam= "%s" ; line= "%s"\n',pNam,line); end
   %eval(line);
    if nb == 1,
      var=eval(pNam);
      P=struct(pNam, var);
      allparms=strtrim(line);
    else
      var=eval(pNam);
      tmp=sprintf('P.%s = var ;',pNam);
      eval(tmp);
      %- add to total string (without starting & ending blanks)
      allparms=[allparms,' ',strtrim(line)];
    end
  end
end
fclose(fid);
if dBug > 0, fprintf('-- allparms = "%s"\n',allparms); end

return
