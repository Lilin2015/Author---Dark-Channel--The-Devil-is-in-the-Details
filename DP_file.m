%% dark pixel dehazing
% this is a demo of the paper "Dark channel: the devil is in the details"
% step 1. put interested hazy images in the file "inputs"
% step 2. check the params
% step 3. run this script
% step 4. check results in the file "results"

%% prepare
clear
close all
path(path,strcat(pwd,'/inputs'));
path(path,strcat(pwd,'/DP dehazing'))
loadfile = dir(strcat(pwd,'/inputs'));
savefile = strcat(pwd,'/results'); 
image_num = length(loadfile);
%% params
lambda  = 0.02;     % control transmission map smoothness
epsilon = 0.05;     % control transmission map compensation
lsize   = 640;      % the maximum of input width and height, 
                    % if this param is enlarged, remember to also check the block size below.
bsz     = 25;       % size of the Omega(x)
%% dehaze
for i = 1:image_num
    fileName = loadfile(i).name;
    [~,name,suffix] = fileparts(fileName);
    if strcmpi(suffix,'.jpg') || strcmpi(suffix,'.bmp') || strcmpi(suffix,'.png')
        % read input
        I = im2double(imread(fileName));
        % set size of the input.
        I = imresize(I,lsize/max(size(I,1),size(I,2)));   
        % estimate A
        A = dp_airLight(I,bsz);
        %A = [1,1,1]; % use this if you want to exclude the effect of air-light estimation
        % solve T
        Iw = dp_whiteImage(I,A);                
        B  = min(Iw,[],3);
        B25 = imerode(B,strel('disk',25));
        
        %%%%%%%%%%%%%%%%%%%
        B15 = imerode(B,strel('disk',15));
        B35 = imerode(B,strel('disk',35));
        Bop = imerode(B,strel('disk',25));
        [L,Num] = superpixels(Iw,1000);
        Bsp = B;
        for i = 1 : Num
            content = B(L==i);
            LowContent = min(content(:));
            Bsp(L==i) = LowContent;
        end
        
        Ti = 1-Bsp;
        Ti = Ti/0.95;
        W = 0.001./max( (B-imerode(B,strel('disk',bsz))).^2,0.001);
        [Ti,W] = dp_augment(Iw,Ti,W);
        
        Tt = wls_optimization(Ti, W, Iw, lambda);
        % dehaze
        haze_factor = 1 + epsilon;
        T = (max(0.1,max(1-B,Tt)) + (haze_factor-1) )/haze_factor;
        J = dp_radiance(I,max(0,min(1,T)),A);
        % result save/
        imwrite(J,[savefile,'/',name,'_J_dp.bmp']);
        imwrite(ind2rgb(gray2ind(T,255),jet(255)),[savefile,'/',name,'_T_dp.jpg']);
    end
end