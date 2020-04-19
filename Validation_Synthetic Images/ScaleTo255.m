% This function convert image I to uint8.
% Input 
%     I: image to convert.
% Output
%     I255: image converted to uint8.
%     scale: resulting image scale.
%     
% Details
%     The minimun value in I becomes 0 in I255.
%     The maximun value in I becomes 255 in I255.
%     I225 is uint8 image.
    
function [I255,scale] = ScaleTo255(I)

I = double(I);
scale = 255;
mini = min(I(:)); % minimun value in I 

I1 = I-mini; % substract the minimun value (minimun value becomes zero value)
maxi = max(I1(:));
I2 = I1/maxi; % divide by the maximun value (maximun value becomes 1)
I3 = scale*I2; % multiply by scale value (maximun value becomes 255)
I255=uint8(I3); % Convert values to uint8 scale

end