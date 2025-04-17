function [ITilt, phaseTilt] = tiltWavefront(I, phase, alpha)

theta = 2*pi/360*alpha;

Iup = imresize(I,2);
[nyI,nxI] = size(I);
[nyIup,nxIup] = size(Iup);

xUpcenter = nxIup/2+0.5;

ITilt = zeros(nyIup,nxIup);
for x=1:nxIup
    for y=1:nyIup
        newx = ceil((x-xUpcenter)*cos(theta)+xUpcenter);
        if ITilt(y,newx) == 0
            ITilt(y,newx) = Iup(y,x);
        end
    end
end

ITilt = imresize(ITilt,0.5);

xP = -nxI/2:nxI/2-1;
yP = -nyI/2:nyI/2-1;


[XP,YP] = meshgrid(xP,yP);


phase = phase.*exp(1i*2*pi*(XP*cos(theta) + YP*sin(theta))*tan(theta));

end