clear all
close all

addpath('misc_functions')
addpath('superpixel_lookupTable')
% Definitions
lambda = 0.532;   %um
f1 = 200;         %mm
f2 = 200;         %mm
d = 13.68;        %um distance between mirrors
n = 4;            %n x n is one superpixel

% Aperture Pos
a = lambda*f1/(n^2*d); %in mm since lambda & d are both in um
apt_X = -a;
apt_Y = n*a;



% Diffraction limited spot size in target plane in units of DMD pixels:
resolution = 8;

% Shape of spatial filter:
mask = 'circle';    % choose 'circle'/'square1'/'square2'/'gaussian'

% Create a target field of the size of the DMD:

%[E_target, maxIntensity] = makeBesselFromScratch(9,0,0); % n in Ra/n, ang, A == Zernike coeff.
%[E_target, maxIntensity] = makeBesselBFP(5,70,0,1);
%[E_target, maxIntensity] = makeBesselBFPZern(0,30);
[E_target, maxIntensity] = makeFieldFromImage();
%[E_target, maxIntensity] = makeZernTri(5,10);
%[E_target, maxIntensity] = makeSpecklePattern(8);


% Apply the superpixel method to the target field. Here superpixels of size
% 4x4 are used. 

[DMDpattern_superpixel, E_superpixel, fidelity_superpixel, efficiency_superpixel] = superpixelMethod(E_target, resolution, mask);

[E_sheet] = BFPMethod(E_superpixel);


% Apply the Lee method to the target field. 
% Spatial carrier frequency in units of DMD pixels:
%Lee_k = 1/12;

%[DMDpattern_Lee, E_Lee, fidelity_Lee, efficiency_Lee] = LeeMethod(E_target, resolution, mask, Lee_k, Lee_k);


E_target_lowres = spatialFilter(E_target,resolution);
fidelity_superpixel_lowres = abs(innerProduct(E_superpixel,E_target_lowres))^2
%fidelity_Lee_lowres = abs(innerProduct(E_Lee,E_target_lowres))^2


% Plot the results:

plot_E(E_target/sqrt(sum(sum(abs(E_target).^2))),maxIntensity,'gray','target');

plot_DMDpixels(DMDpattern_superpixel,'superpixel');
plot_E(E_superpixel,maxIntensity,'gray','superpixel');

%plot_DMDpixels(Sheetprofile,'Fourier of BFP');

E_sheet_intensity = max(max(abs(E_sheet)))/sum(sum(abs(E_sheet)));
plot_E(E_sheet,E_sheet_intensity,'gray','F(BFP)');

%imwrite(DMDpattern_Lee,'DMDpattern_Lee.tiff','Compression','none');
imwrite(DMDpattern_superpixel,'DMDpattern_superpixel.tiff','Compression','none');
