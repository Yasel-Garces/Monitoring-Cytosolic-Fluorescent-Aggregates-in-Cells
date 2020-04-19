% Run the simulation to validated the segmentation algorithm
% You can control: 
% 1. The number of experiments N (images generated)
% 2. The number of ellipses (lysosomes) to include in each syntetic image
% 3. The differents levels of noise to include.
% OUTPUT: 6 csv files (Jaccard, Jaccard, Recall, Precision, 
%         Precision, Displacement, Area, SNR.  The columns represents
%         increase in the signal noise ratio and the rows the experiments.

N=1000; % Number of experiments
num_lys=10; % Number of ellipses (lysosomes) to include
level_noise= 20; % How many differents level of noise.

%-----------------------------------------------------------------
% Create a 256x256 image for the blue channel (represent the cell)
%-----------------------------------------------------------------
ima_b=256*zeros(256);
% Create a big ellipse to represent the cell (this is only for
% visualization propouses)
EP=[120 120 128 128 0];
Points1=draw_ellipse(EP(1,:),[0 2*pi]);
% Transform the points to int values (pixels)
Points1=round(Points1);
% Draw the ellipse like a cell
idx = sub2ind(size(ima_b),Points1(:,1),Points1(:,2));
ima_b(idx) = repmat(255,1,size(Points1,1));
%-----------------------------------------------------------------

for m=1:N
    % Generate 10 random ellipses (represents the lysosomes)
    A=random('unif',0.5,1.5,num_lys,1);
    CX=randi([35,230],num_lys,1);
    CY=randi([35,200],num_lys,1);
    theta=rand(num_lys,1)*2*pi;
    Ellipses=[A A CX CY theta];
    % Create an array like an image
    Img=256*zeros(256);
    for t=1:size(Ellipses,1)
        % Select only one ellipse
        actual_ellipse=Ellipses(t,:);
        
        %PointsT=[];
        % Generate the points of the ellipse
        Points=draw_ellipse(actual_ellipse,[0 2*pi]);
        % Generate the pixel intensity level
        r= randi([200,256],1,size(Points,1));
        % Transform the points to int values (pixels)
        Points=round(Points);
        % Include the points in the image
        idx = sub2ind(size(Img),Points(:,1),Points(:,2));
        Img(idx) = r;
    end
    % Compute the ground truth values for each of the variables
    [GT_Number,GT_Area,GT_Perimeter,GT_Centroid]=computeStatistics(Img,ima_b);
    if length(GT_Number)~=10
        continue
    end
    
    % Convolution and normalization
    ImAdan=imread('PSF510nm_n1.33_NA1.3_px100nm.tif');
    T=conv2(Img,ImAdan,'same'); % Convolution
    T1=T/max(max(T)); %  Normalization
    % Create 20 differents levels of noise
    noise=linspace(0.0001,0.003,level_noise);
    % Error in the center displacement
    value=[];
    % Error in the area estimation
    Error_Area=[];
    for i=1:length(noise)
        CX1=CX;
        CY1=CY;
        TP=0; FP=0;
        % Adding gaussian noise
        T=imnoise(T1,'gaussian',0,noise(i));
        % Adding poisson noise
        T=imnoise(T,'poisson');
        % consider amplification in a EM-CCD detector
        T=sqrt(2).*T;
        %----------------------------------------------------
        % Compute the signal noise ratio (see Supplementary Information)
        num=sum(sum(T1.^2));
        denom=sum(sum((T1-T).^2));
        SNR(m,i)=10*log10(num/denom);
        
        % Create the image with the three channels
        Image=cat(3,im2double(ima_b),T,256*zeros(256));
        % Show the image
        imshow(Image);
        %==========================================================================
        %==========================================================================
        % At this point, the generation of the synthetic image is over, so,
        % now begins the segmentation and statistical computation.
        % Channel selection
        NewImage = uint8(255 * mat2gray(Image(:,:,2)));
        % Segmentation and computation of the area, perimeter, etc
        [Number_l{i},threshold{i}, Area_l{i},Perimeter_l{i},Centroid_l{i}]=...
            find_lysosomes(NewImage);
        % Compute the errors for each variable in each lysosome
        for j=1:length(Centroid_l{i}(:,1))
            % Displacement error (euclidean's distance between the centers)
            error=sqrt((CX1-Centroid_l{i}(j,2)).^2 + (CY1-Centroid_l{i}(j,1)).^2);
            % Compute the True Positive (TP) (see Supplementary Information)
            if sum(error/10<=0.5)>=1
                % Increase the TP
                TP=TP+1;
                % Inccclude the minimum error
                [value(end+1),index]=min(error);
                % Compute the area error
                Error_Area(end+1)=abs(Area_l{i}(j)-GT_Area(index))/100;
                % Transform to empty the center of the actual ellipse
                CX1(index)=[];
                CY1(index)=[];
            else
                % Increase a false postive (bad estimation)
                FP=FP+1;
            end
        end
        % Compute thee false negative
        FN=10-TP;
        % Compute the Jaccard, Recall and Precision index. Save the data in
        % a matrix with 1000 (number of experiments) trials and 20 level
        % noise levels
        Jaccard(m,i)=TP/(TP+FN+FP);
        Recall(m,i)=TP/(TP+FN);
        Precision(m,i)=TP/(TP+FP);
        % Mean displacement  error
        displacement(m,i)=mean(value/10);
        % Mean area error
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