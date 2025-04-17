
function [E_target,maxIntensity] = makeBesselBFPZern(xdecenter, Amp)

% Take two images, one for intensity and one for phase, and combine them
% into a complex field:


I = zeros(768,1024);
phase = zeros(768,1024);
ypx = 768;
xpx = 1024;
[Xorg, Yorg] = meshgrid(1:xpx, 1:ypx);

% Amp = 50;
spotsize = 768;


spotposx = round((xpx+xdecenter)/2);
spotposy = round((ypx)/2);

A = sqrt((Xorg-spotposx).^2 + (Yorg-spotposy).^2);
Ii = double(A < spotsize/2);
I = I + Ii;

kr = 1/3;
phase = -kr*A;

x = linspace(-1,1,spotsize);
[X,Y] = meshgrid(x,x);
[theta,r] = cart2pol(X,Y);
idx = r<=1;
z = zeros(size(X));
z(idx) = zernfun(2,0,r(idx),theta(idx));
phasei = wrapToPi(Amp*z);
phaseipad = padarray(phasei,(size(phase) - size(phasei))/2,'both');
phasei = circshift(phaseipad,[-(ypx/2-spotposy),-(xpx/2-spotposx)]);
phase = phase + phasei;

E_target = sqrt(abs(I)).*exp(-phase*1i);
maxIntensity = max(max(abs(I)))/sum(sum(abs(I)));




    


