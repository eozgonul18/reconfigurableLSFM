
function [E_target,maxIntensity] = makeBesselFromScratch(n, ang, A)

% Take two images, one for intensity and one for phase, and combine them
% into a complex field:


I = zeros(768,1024);
ypx = 768;
xpx = 1024;
[X, Y] = meshgrid(1:xpx, 1:ypx);

% Simple aperture 

% A = sqrt((X-xpx/2).^2 + (Y-ypx/2).^2);
% I = double(A < 100);

%J_0 Amplitude & Phase
[Xa, Ya] = meshgrid(1:xpx, 1:ypx);
Ra = sqrt((Xa-xpx/2).^2 + (Ya-ypx/2).^2);
I = besselj(0,Ra/n);


I = I/(max(max(I)));
I = min(1,I*1.3);

R = sqrt((X-xpx/2).^2 + (Y-ypx/2).^2);
kr = 1/n;

phase = -kr*R;

phase = ZernikeAdd(phase,A);
E_target = sqrt(abs(I)).*exp(phase*1i);

maxIntensity = max(max(abs(I)))/sum(sum(abs(I)));


    


