
function [E_target,maxIntensity] = makeBesselBFP(i,Amp,rin,rout)

% Take two images, one for intensity and one for phase, and combine them
% into a complex field:


I = zeros(768,1024);
ypx = 768;
xpx = 1024;
[X, Y] = meshgrid(1:xpx, 1:ypx);

% Simple aperture 

% A = sqrt((X-xpx/2).^2 + (Y-ypx/2).^2);
% I = double(A < 100);

% Bessel Amplitude
%rout = 0.6; % - (i-1)*0.1;
%rin = rout - 0.2;
%rin = 0;
R = sqrt((X-xpx/2).^2 + (Y-ypx/2).^2);
I = double((R < rout*ypx/2) & (R > rin*ypx/2));


maxIntensity = max(max(I))/sum(sum(I));


phase = zeros(768,1024);
R = sqrt((X-xpx/2).^2 + (Y-ypx/2).^2);
kr = 1/(i); % 2*pi/p
phase = -kr*R;
phase = ZernikeAdd(phase,Amp);
E_target = sqrt(I).*exp(1i*phase);


    


