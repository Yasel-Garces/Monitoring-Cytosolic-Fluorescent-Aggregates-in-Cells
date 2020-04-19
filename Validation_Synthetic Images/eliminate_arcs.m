% Esta funcion esta disenada para eliminar los arcos que contengan una
% cantidad de puntos menor que una valor cant prefijado. Los arcos
%       que tengan menos puntos que 'num_point' seran eliminados.
% INPUT:---------
%       Bo: Conjunto de arcos almacenados en forma de cell array.
%       num_point: cantidad minima de puntos permitida en los arcos. 
% OUTPUT:--------
%        Bo: nuevo conjunto de arcos almacenados en forma de cell array.
function [Bo,index_arc]=eliminate_arcs(Bo, num_point)

% La variable se inicia vacia
Bo1=[];
index_arc=[];
% Se realiza el filtro eliminando los arcos con menos puntos que cant.
for t=1:length(Bo)
    if length(Bo{t})>=num_point
        Bo1{end+1}=Bo{t};
        index_arc(end+1)=length(Bo{t});
    end
end
Bo=Bo1;

