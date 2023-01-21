function A = masking(A,B,thresh,detail)

[ra ca] = size(A);             
PA = zeros(ra + 2,ca + 2);     
PA(2:end - 1,2:end - 1) = A;   

switch detail
    case 'LH'  
        for p = 1:ra
            for q = 1:ca
                mask = PA(p:2 + p,q:2 + q);
              
                if mask(4)<thresh || mask(6)<thresh
                    A(p,q) = B(p,q);
                end
            end
        end

    case 'HL'   
        for p = 1:ra
            for q = 1:ca
                mask = PA(p:2 + p,q:2 + q);
                
                if mask(2)<thresh || mask(8)<thresh
                    A(p,q) = B(p,q);
                end

            end
        end
        
    case 'HH'   
        for p = 1:ra
            for q = 1:ca
                mask = PA(p:2 + p,q:2 + q);
                
                if mask(1)<thresh || mask(3)<thresh ||...
                   mask(7)<thresh || mask(9)<thresh
                    A(p,q) = B(p,q);
                end
            end
        end
        
    otherwise
        error(['Unhandeled detail = ', detail]);
        
end