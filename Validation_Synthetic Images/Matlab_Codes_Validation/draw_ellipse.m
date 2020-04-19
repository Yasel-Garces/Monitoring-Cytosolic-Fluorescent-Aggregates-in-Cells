% This function is to generate ellipses using the parametric form and the
% polar angle. See
% https://es.wikipedia.org/wiki/Elipse#En_coordenadas_polares for more
% information.
% INPUT:
% parameter: vector [a b cx cy angle] where a is major axis, b is a minor axis,
% cx is the displacement respect to X, cy is the displacement respect to
% Y and angle is a rotation of the elllipse
% eliminate: This parameter is a vector of two components that represents
% the sweeping angle to eliminate points in a ellipse.
% OUTPUT:
% Points: vector [X Y] whit the points of the ellipse
% Uthor: Yasel Garces (88yasel@gmail.com)

function Points=draw_ellipse(parameter,eliminate)

if nargin==2
    theta=min(eliminate):0.01:max(eliminate);
else
    theta=0:0.01:2*pi;
end

% Compute the square root
cos_factor=((cos(theta)).^2)./(parameter(1)^2);
sin_factor=((sin(theta)).^2)./(parameter(2)^2);
root= 1./(sqrt(cos_factor + sin_factor));

% Compute the X and Y values
Point(:,1)=root.*cos(theta);
Point(:,2)=root.*sin(theta);

if length(parameter)==5
    % Rotation
    Points(:,1)=(Point(:,1).*cos(parameter(5))) - (Point(:,2).*sin(parameter(5)));
    Points(:,2)=(Point(:,2).*cos(parameter(5))) + (Point(:,1).*sin(parameter(5)));
    
    % Translation
    Points(:,1)=Points(:,1)+parameter(3);
    Points(:,2)=Points(:,2)+parameter(4);
else
    % Translation
    Points(:,1)=Point(:,1)+parameter(3);
    Points(:,2)=Point(:,2)+parameter(4);
end