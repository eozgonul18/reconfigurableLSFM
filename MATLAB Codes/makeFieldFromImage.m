
function [E_target,maxIntensity] = makeFieldFromImage()



clear I
clear phase
I = imread('images/Gölge.jpg');
I = (double(I(:,:,1))+double(I(:,:,2))+double(I(:,:,3)))/3;
I = I / 255;
I = min(1,I*1.3);
phase = imread('images/Behzat.jpg');
phase = double(phase(:,:,1)); 
phase = phase/max(max(phase))*pi;
E_target = sqrt(I).*exp((1.9*pi*phase/max(max(phase))-pi)*1i);

maxIntensity = max(max(I))/sum(sum(I));




    


