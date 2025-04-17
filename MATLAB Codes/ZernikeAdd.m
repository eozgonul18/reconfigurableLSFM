function [phasepluszern] = ZernikeAdd(phase,A)
%Zernike Add-ins

%A = 10;
rpx = 768;
x = linspace(-1,1,rpx);
[X,Y] = meshgrid(x,x);
[theta,r] = cart2pol(X,Y);
idx = r<=1;
z = zeros(size(X));
z(idx) = zernfun(2,0,r(idx),theta(idx));
%-pi/2lambda*f = A for defocus
z = wrapToPi(A*z);
phasepluszern = phase + padarray(z,(size(phase) - rpx)/2,0,'both');
% figure
% pcolor(phasepluszern), shading interp
% axis square, colorbar
% title('Zernike function Z_5^1(r,\theta)')