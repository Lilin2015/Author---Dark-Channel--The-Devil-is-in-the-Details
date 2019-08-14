function [ J ] = dp_radiance( I, T, A)
    c = size(I,3);
    if c==3
        J = ( I - repmat(reshape(A,[1,1,3]),size(I,1),size(I,2)))./repmat(T,[1,1,size(I,3)])+repmat(reshape(A,[1,1,3]),size(I,1),size(I,2));
    elseif c==1
        J = ( I - repmat(A,size(I,1),size(I,2)))./T+repmat(A,size(I,1),size(I,2));
    end
    
end

