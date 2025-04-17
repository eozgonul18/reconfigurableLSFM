
function [E_target,maxIntensity] = makeZernTri(row, Amp)

% Take two images, one for intensity and one for phase, and combine them
% into a complex field:


I = zeros(768,1024);
phase = zeros(768,1024);
ypx = 768;
xpx = 1024;
[Xorg, Yorg] = meshgrid(1:xpx, 1:ypx);

% row = 7;
% Amp = 50;
spotsize = 100;


for n = 0:(row -1)
    mindex = 1;
    for m = -n:2:n
        spotposx = round(mindex*xpx/(n+2));
        spotposy = round((n+1)*ypx/(row+1));
        
        A = sqrt((Xorg-spotposx).^2 + (Yorg-spotposy).^2);
        Ii = double(A < spotsize/2);
        I = I + Ii;
        mindex = mindex + 1;

        x = linspace(-1,1,spotsize);
        [X,Y] = meshgrid(x,x);
        [theta,r] = cart2pol(X,Y);
        idx = r<=1;
        z = zeros(size(X));
        z(idx) = zernfun(n,m,r(idx),theta(idx));
        phasei = wrapToPi(Amp*z);
        phaseipad = padarray(phasei,(size(phase) - size(phasei))/2,'both');
        phasei = circshift(phaseipad,[-(ypx/2-spotposy),-(xpx/2-spotposx)]);
        phase = phase + phasei;
    end
end

I = I/(max(max(I)));
I = min(1,I*1.3);

E_target = sqrt(abs(I)).*exp(phase*1i);
maxIntensity = max(max(abs(I)))/sum(sum(abs(I)));




    


