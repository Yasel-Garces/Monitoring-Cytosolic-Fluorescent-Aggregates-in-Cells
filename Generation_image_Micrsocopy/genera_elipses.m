% Generador de elipses segun datos de la siguiente forma::
% caso elipse : [a b cx cy theta]
% a: semieje mayor
% b: semieje menor
% cx: desplazamiento en abscizas
% cy: desplazamiento en ordenadas.
% Theta: angulo de rotacion.
clear all
close all

for m=1:1000
    ima_b=256*zeros(256);
    
    EP=[120 120 128 128 0];
    Points1=draw_ellipse(EP(1,:),[0 2*pi]);
    %r1= repmat(255,1,size(Points,1));
    for j=1:size(Points1,1)
        ima_b(round(Points1(j,1)),round(Points1(j,2)))=255;
    end
    
    % Juego de elipses a plotear.
    A=random('unif',0.5,1.5,10,1);
    CX=randi([35,230],10,1);
    CY=randi([35,200],10,1);
    theta=rand(10,1)*2*pi;
    Ellipses=[A A CX CY theta];
    
    Img=256*zeros(256);
    for t=1:size(Ellipses,1)
        this_ellipse=Ellipses(t,:);
        
        PointsT=[];
        Points=draw_ellipse(this_ellipse,[0 2*pi]);
        r= randi([200,256],1,size(Points,1));
        
        Points=round(Points);
        for h=1:size(Points,1)
            Img(Points(h,1),Points(h,2))=r(h);
        end
        % PointsT=[PointsT; Points];
    end
    [GT_Number,GT_Area,GT_Perimeter,GT_Centroid]=computeStatistics(Img,Img);
    if length(GT_Number)~=10
        continue
    end
    
    % Convolution annd normalization
    ImAdan=imread('PSF510nm_n1.33_NA1.3_px100nm.tif');
    T=conv2(Img,ImAdan,'same');
    T1=T/max(max(T));
    
    noise=linspace(0.0001,0.003,20);
    value=[];
    Error_Area=[];
    for i=1:length(noise)
        CX1=CX;
        CY1=CY;
        
        TP=0; FP=0;
        % Adding gaussian noise
        T=imnoise(T1,'gaussian',0,noise(i));
        % Adding poisson noise
        T=imnoise(T,'poisson');
        T=sqrt(2).*T;
        %--------------
        % Compute the signal noise ratio
        num=sum(sum(T1.^2));
        denom=sum(sum((T1-T).^2));
        SNR(m,i)=10*log10(num/denom);
        
        % Create the image
        T=cat(3,im2double(ima_b),T,256*zeros(256));
         
        imshow(T); %muestra la imágen en escala de grises
        % A partir de aquí la parte de la segmentación de la imagen generada.
        % Se ha puesto como si fuera desde el principio.
        % Channel selection
        NewImage = uint8(255 * mat2gray(T(:,:,2)));
        
        [Number_l{i},threshold{i}, Area_l{i},Perimeter_l{i},Centroid_l{i}]=...
            find_lisosomas(NewImage);
        
        for j=1:length(Centroid_l{i}(:,1))
            error=sqrt((CX1-Centroid_l{i}(j,2)).^2 + (CY1-Centroid_l{i}(j,1)).^2);
            
            if sum(error/10<=0.5)>=1
                TP=TP+1;
                [value(end+1),index]=min(error);
                Error_Area(end+1)=abs(Area_l{i}(j)-GT_Area(index))/100;
                
                CX1(index)=[];
                CY1(index)=[];
            else
                FP=FP+1;
            end
        end
        FN=10-TP;
        Jaccard(m,i)=TP/(TP+FN+FP);
        Recall(m,i)=TP/(TP+FN);
        Precision(m,i)=TP/(TP+FP);
        
        displacement(m,i)=mean(value/10);
        final_error_Area(m,i)=mean(Error_Area);
    end
end
%-----------------------------------------------------------
% Cell array creation with all the information
dlmwrite('Jaccard.csv', Jaccard)
dlmwrite('Recall.csv', Recall)
dlmwrite('Precision.csv', Precision)
dlmwrite('Displacement.csv', displacement)
dlmwrite('Area.csv', final_error_Area)
dlmwrite('SNR.csv', SNR)