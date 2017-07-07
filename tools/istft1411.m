function x = istft1411(d)
% X = istft1411(D)                    Inverse short-time Fourier transform.
%	Performs overlap-add resynthesis from the short-time Fourier transform 
%	data in D.  Each column of D is taken as the result of an 1411-point
%	fft; each successive frame was offset by 1411/4 points.  Data is
%	hann-windowed at 1411 pts.  This version scales the output so the loop
%	gain is 1.0 for hann-win an-syn with 25% overlap.
% dpwe 1994may24.  Uses built-in 'ifft' etc.
% takshingchan 2014dec15.  Used parameters for ICASSP and modified code to
% allow for odd windows and fractional hops

ftsize = 1411;
win = 2/3*hann(1411,'periodic')';
h = 1411/4;

s = size(d);
if s(1) ~= floor(ftsize/2)+1
  error('number of rows should be fftsize/2+1')
end
cols = s(2);

xlen = ftsize + (cols-1)*h;
x = zeros(1,floor(xlen));

for b = 0:h:(h*(cols-1))
  ft = d(:,1+b/h)';
  ft = [ft, conj(ft([(ceil(ftsize/2)):-1:2]))];
  px = real(ifft(ft));
  x(floor(b+1):floor(b+ftsize)) = x(floor(b+1):floor(b+ftsize))+px.*win;
end;
