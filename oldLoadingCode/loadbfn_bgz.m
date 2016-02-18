function om = loadbfn_bgz(fn,dim,sz)
% loadbfn -- loads a binary file fn after gunzipping to /tmp
%	of dim ([nrows ncols]) of sz 'float','int', etc.
%
%	by DKB on 2/5/96
%	  changed to big-endian by default  050930
%	  use loadbfn_l.m  for little-end
%
%	revised here to gunzip to /tmp file first
%

if(nargin < 3)
	sz = 'float32';
end

%need to fake basename to handle input
%bn=eval(['! basename ' fn ' .gz '])

clk = fix(clock);
MS = sprintf('%-2.2d%-2.2d',clk(5),clk(6));


lc=fliplr(find(fn == '.'));
if(isempty(lc))
	lc = length(fn)+1;
end
fc=fliplr(find(fn == '/'));
if(isempty(fc))
	fc = 0;
end


%tmpn=['/tmp/' fn(fc(1)+1:lc(1)-1) MS ];
tmpn=['tmp/' fn(fc(1)+1:lc(1)-1) MS ];
eval(['!gunzip -c ' fn ' > ' tmpn ]);

f = fopen(tmpn,'r','b');

if(nargout > 0)
	om = fread(f,flipud(dim(:))',sz)';
end
fclose(f);

delete(tmpn);

