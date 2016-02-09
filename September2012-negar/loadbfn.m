function om = loadbfn(fn,dim,sz)
% loadbfn -- loads a binary file fn of dim
%	([nrows ncols]) of sz 'float','int', etc.
%
%	by DKB on 2/5/96
%	  changed to big-endian by default  050930
%	  use loadbfn_l.m  for little-end
%

if(nargin < 3)
	sz = 'float32';
end

f = fopen(fn,'r','b');

if(nargout > 0)
	om = fread(f,flipud(dim(:))',sz)';
end
fclose(f);
