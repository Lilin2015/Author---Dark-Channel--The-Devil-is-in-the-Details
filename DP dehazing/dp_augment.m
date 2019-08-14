function [Ti,W] = dp_augment(Iw,Ti,W)
    [m,n,c] = size(Iw);
    Iw_color = reshape(Iw,[m*n,c]);
    Ti_v = reshape(Ti,[m*n,1]);
    W_v = reshape(W,[m*n,1]);
    Ti_vr = Ti_v;
    W_vr = W_v;
    
        
    dp_color = Iw_color;
    dp_color(W(:)~=1,:)=repmat(-1,[sum(W(:)~=1),3]);
	[~, Locb] = ismember(round(Iw_color*1000)/1000,round(dp_color*1000)/1000,'rows');
    
    
    Ti_vr(Locb~=0) = Ti_v(Locb(Locb~=0));
    W_vr(Locb~=0) = W_v(Locb(Locb~=0));
    
    Ti = reshape(Ti_vr,[m,n]);
    W = reshape(W_vr,[m,n]);
%     figure;
%     subplot(3,2,1); imshow(Iw);
%     subplot(3,2,3); imshow(reshape(Ti_v,[m,n]));
%     subplot(3,2,4); imshow(reshape(Ti_vr,[m,n]));
%     subplot(3,2,5); imshow(reshape(W_v,[m,n]));
%     subplot(3,2,6); imshow(reshape(W_vr,[m,n]));
end

