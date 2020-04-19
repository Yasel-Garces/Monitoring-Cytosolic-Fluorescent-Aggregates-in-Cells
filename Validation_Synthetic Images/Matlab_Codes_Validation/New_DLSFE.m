% Esta funcion detecta multiples elipses en una imagen RGB tomando en
% cuenta solo el canal rojo, para cambiar el tipo de canal especificar en
% primera linea de codigo.
% Author: YASEL GARCES SUAREZ (9-febrero-2015)
% Input:
%      NewImage_ Imagen en escala de grises que representa el canal seleccionado
%      minimal_intensitive: intensidad minima requerida en los pixeles que
%      se van a seleccionar.
%      maximal_distance: Se toman en el arco solo los puntos que tienen
%      una distancia inferior a maximal_distance.
% Output:
%      ellipse: Matriz donde cada fila representa una elipse detectada. El
%      formato de la elipse por columnas es [a b ax by theta].

function ellipse=New_DLSFE(NewImage,minimal_intensitive)

% Se seleccionan los pixeles con mayor intensidad que un umbral prefijado.
In=NewImage>=minimal_intensitive;
% La imagen se convierte a unit8
BW=NewImage.*uint8(In);
%.----------------------------

% Se seleccionan los arcos que tengan una estructura convexa.
[Bo, ~]= bwboundaries(BW,8,'noholes');

% Se eliminan los arcos que tienen una cantidad de puntos inferior a
% 'minimal_point'.
[Bo,~]=eliminate_arcs(Bo,15);

% Se eliminan los puntos de los arcos que tienen mayor distancia que
% maximal_distance con respecto a la media ponderada del arco.
%Bo=distance_point(Bo,maximal_distance,BW);

ellipse=[];
for i=1:length(Bo)
    CA=Bo{i};
    v = fit_ellipse_LSFE(CA(:,1), CA(:,2));
    if isempty(v)
        continue
    else
        if sqrt(1-(v(2)/v(1)))<1 && v(1)<size(NewImage,1)/2;
            ellipse(end+1,:)=v;
        end
    end
end