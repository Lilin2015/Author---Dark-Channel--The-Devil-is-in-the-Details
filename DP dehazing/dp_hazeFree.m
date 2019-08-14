function [ J, T, A] = dp_hazeFree( I, A, ref_map )
    
    if ~exist('A','var') || isempty(A)
        A = dp_airLight(I);
    end
    Iw = dp_whiteImage(I,A);    

    %% trans.
    Tr = dp_Trans(Iw,[],[],ref_map);
    
    %% brighter
    haze_factor = 1.1;
    T = (Tr + (haze_factor-1) )/haze_factor;
    
    J = dp_radiance(I,T,A);

end

