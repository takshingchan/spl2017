function d = stft1411(x)
% D = stft1411(X)                             Short-time Fourier transform.
%	Returns some frames of short-term Fourier transform of x.  Each 
%	column of the result is one 1411-point fft; each successive frame is
%	offset by 1411/4 points until X is exhausted. Data is hann-windowed at
%	1411 pts.  See also 'istft1411.m'.
% dpwe 1994may05.  Uses built-in 'fft'
% takshingchan 2014dec15.  Used parameters for ICASSP and modified code to
% allow for odd windows and fractional hops

f = 1411;
win = hann(1411,'periodic')';
h = 1411/4;

% expect x as a row
if size(x,1) > 1
  x = x';
end

s = length(x);
c = 1;

% pre-allocate output array
d = zeros((1+floor(f/2)),1+fix((s-f)/h));

for b = floor(0:h:(s-f))
  u = win.*x((b+1):(b+f));
  t = fft(u);
  d(:,c) = t(1:(1+floor(f/2)))';
  c = c+1;
end;
