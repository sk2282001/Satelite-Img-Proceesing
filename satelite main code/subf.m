function [thresh,MSE,PSNR,EI] = subf(data_set,set1,set2,set3,n)
 subband_low_hig = set1.dec{2,1};subband_low_hig_B = set2.dec{2,1};subband_low_hig_C = set3.dec{2,1};    
            subband_hig_low = set1.dec{3,1};subband_hig_low_B = set2.dec{3,1};subband_hig_low_C = set3.dec{3,1};  
            subband_hig_hig = set1.dec{4,1};subband_hig_hig_B = set2.dec{4,1};subband_hig_hig_C = set3.dec{4,1};  
            subband_low_hig_2 = set1.dec{5,1};subband_low_hig_B_2 = set2.dec{5,1};subband_low_hig_C_2 = set3.dec{5,1};  
            subband_hig_low_2 = set1.dec{6,1};subband_hig_low_B_2 = set2.dec{6,1};subband_hig_low_C_2 = set3.dec{6,1};  
            subband_hig_hig_2 = set1.dec{7,1};subband_hig_hig_B_2 = set2.dec{7,1};subband_hig_hig_C_2 = set3.dec{7,1};  
            vertical_band = set1.dec{8,1};vertical_band_B = set2.dec{8,1};vertical_band_C = set3.dec{8,1};  
            hors_band_C = set1.dec{9,1};hors_band_B = set2.dec{9,1};hors_band_A = set3.dec{9,1};    
            diag_band_A = set1.dec{10,1};diag_band_B = set2.dec{10,1};diag_band_C = set3.dec{10,1}; 
            Aminmax = [min(min(subband_low_hig)) max(max(subband_low_hig));...
               min(min(subband_hig_low)) max(max(subband_hig_low));...
               min(min(subband_hig_hig)) max(max(subband_hig_hig));...
               min(min(subband_low_hig_2)) max(max(subband_low_hig_2));...
               min(min(subband_hig_low_2)) max(max(subband_hig_low_2));...
               min(min(subband_hig_hig_2)) max(max(subband_hig_hig_2));...
               min(min(vertical_band)) max(max(vertical_band));...
               min(min(hors_band_C)) max(max(hors_band_C));...
               min(min(diag_band_A)) max(max(diag_band_A))];
            thresh = zeros(9,n);
            MSE = zeros(9,n);
            PSNR = zeros(9,n);
          
            coeff = linspace(Aminmax(1,1),Aminmax(1,2),n);
            for k = 1:length(coeff)
                subband_low_hig(subband_low_hig<coeff(k)) = subband_low_hig_C(subband_low_hig<coeff(k));
                subband_low_hig = masking(subband_low_hig,subband_low_hig_B,coeff(k),'LH');
                subband_low_hig = smooth_filte(subband_low_hig,3);
                set1.dec{2,1} = subband_low_hig;
                set1.dec{3,1} = subband_hig_low;
                set1.dec{4,1} = subband_hig_hig;
                set1.dec{5,1} = subband_low_hig_2;
                set1.dec{6,1} = subband_hig_low_2;
                set1.dec{7,1} = subband_hig_hig_2;
                set1.dec{8,1} = vertical_band;
                set1.dec{9,1} = hors_band_C;
                set1.dec{10,1} = diag_band_A;
                EI = indwt2(set1,'aa',1);
                [MSE(1,k) PSNR(1,k)] = GetPSNR(data_set,EI);
                thresh(1,k) = coeff(k);
            end
            coeff = linspace(Aminmax(2,1),Aminmax(2,2),n);
            for k = 1:length(coeff)
                subband_hig_low(subband_hig_low<coeff(k)) = subband_hig_low_C(subband_hig_low<coeff(k));
                subband_hig_low = masking(subband_hig_low,subband_hig_low_B,coeff(k),'HL');
                subband_hig_low = smooth_filte(subband_hig_low,3);
                set1.dec{2,1} = subband_low_hig;
                set1.dec{3,1} = subband_hig_low;
                set1.dec{4,1} = subband_hig_hig;
                set1.dec{5,1} = subband_low_hig_2;
                set1.dec{6,1} = subband_hig_low_2;
                set1.dec{7,1} = subband_hig_hig_2;
                set1.dec{8,1} = vertical_band;
                set1.dec{9,1} = hors_band_C;
                set1.dec{10,1} = diag_band_A;
                EI = indwt2(set1,'aa',1);
                [MSE(2,k) PSNR(2,k)] = GetPSNR(data_set,EI);
                thresh(2,k) = coeff(k);
            end
            coeff = linspace(Aminmax(3,1),Aminmax(3,2),n);
            for k = 1:length(coeff)
                subband_hig_hig(subband_hig_hig<coeff(k)) = subband_hig_hig_C(subband_hig_hig<coeff(k));
                subband_hig_hig = masking(subband_hig_hig,subband_hig_hig_B,coeff(k),'HH');
                subband_hig_hig = smooth_filte(subband_hig_hig,3);
                set1.dec{2,1} = subband_low_hig;
                set1.dec{3,1} = subband_hig_low;
                set1.dec{4,1} = subband_hig_hig;
                set1.dec{5,1} = subband_low_hig_2;
                set1.dec{6,1} = subband_hig_low_2;
                set1.dec{7,1} = subband_hig_hig_2;
                set1.dec{8,1} = vertical_band;
                set1.dec{9,1} = hors_band_C;
                set1.dec{10,1} = diag_band_A;
                EI = indwt2(set1,'aa',1);
                [MSE(3,k) PSNR(3,k)] = GetPSNR(data_set,EI);
                thresh(3,k) = coeff(k);
            end
            coeff = linspace(Aminmax(4,1),Aminmax(4,2),n);
            for k = 1:length(coeff)
                subband_low_hig_2(subband_low_hig_2<coeff(k)) = subband_low_hig_C_2(subband_low_hig_2<coeff(k));
                subband_low_hig_2 = masking(subband_low_hig_2,subband_low_hig_B_2,coeff(k),'LH');
                subband_low_hig_2 = smooth_filte(subband_low_hig_2,3);
                set1.dec{2,1} = subband_low_hig;
                set1.dec{3,1} = subband_hig_low;
                set1.dec{4,1} = subband_hig_hig;
                set1.dec{5,1} = subband_low_hig_2;
                set1.dec{6,1} = subband_hig_low_2;
                set1.dec{7,1} = subband_hig_hig_2;
                set1.dec{8,1} = vertical_band;
                set1.dec{9,1} = hors_band_C;
                set1.dec{10,1} = diag_band_A;
                EI = indwt2(set1,'aa',1);
                [MSE(4,k) PSNR(4,k)] = GetPSNR(data_set,EI);
                thresh(4,k) = coeff(k);
            end
            coeff = linspace(Aminmax(5,1),Aminmax(5,2),n);
            for k = 1:length(coeff)
                subband_hig_low_2(subband_hig_low_2<coeff(k)) = subband_hig_low_C_2(subband_hig_low_2<coeff(k));
                subband_hig_low_2 = masking(subband_hig_low_2,subband_hig_low_B_2,coeff(k),'HL');
                subband_hig_low_2 = smooth_filte(subband_hig_low_2,3);
                set1.dec{2,1} = subband_low_hig;
                set1.dec{3,1} = subband_hig_low;
                set1.dec{4,1} = subband_hig_hig;
                set1.dec{5,1} = subband_low_hig_2;
                set1.dec{6,1} = subband_hig_low_2;
                set1.dec{7,1} = subband_hig_hig_2;
                set1.dec{8,1} = vertical_band;
                set1.dec{9,1} = hors_band_C;
                set1.dec{10,1} = diag_band_A;
                EI = indwt2(set1,'aa',1);
                [MSE(5,k) PSNR(5,k)] = GetPSNR(data_set,EI);
                thresh(5,k) = coeff(k);
            end
            coeff = linspace(Aminmax(6,1),Aminmax(6,2),n);
            for k = 1:length(coeff)
                subband_hig_hig_2(subband_hig_hig_2<coeff(k)) = subband_hig_hig_C_2(subband_hig_hig_2<coeff(k));
                subband_hig_hig_2 = masking(subband_hig_hig_2,subband_hig_hig_B_2,coeff(k),'HH');
                subband_hig_hig_2 = smooth_filte(subband_hig_hig_2,3);
                set1.dec{2,1} = subband_low_hig;
                set1.dec{3,1} = subband_hig_low;
                set1.dec{4,1} = subband_hig_hig;
                set1.dec{5,1} = subband_low_hig_2;
                set1.dec{6,1} = subband_hig_low_2;
                set1.dec{7,1} = subband_hig_hig_2;
                set1.dec{8,1} = vertical_band;
                set1.dec{9,1} = hors_band_C;
                set1.dec{10,1} = diag_band_A;
                EI = indwt2(set1,'aa',1);
                [MSE(6,k) PSNR(6,k)] = GetPSNR(data_set,EI);
                thresh(6,k) = coeff(k);
            end
            coeff = linspace(Aminmax(7,1),Aminmax(7,2),n);
            for k = 1:length(coeff)
                vertical_band(vertical_band<coeff(k)) = vertical_band_C(vertical_band<coeff(k));
                vertical_band = masking(vertical_band,vertical_band_B,coeff(k),'LH');
                vertical_band = smooth_filte(vertical_band,3);
                set1.dec{2,1} = subband_low_hig;
                set1.dec{3,1} = subband_hig_low;
                set1.dec{4,1} = subband_hig_hig;
                set1.dec{5,1} = subband_low_hig_2;
                set1.dec{6,1} = subband_hig_low_2;
                set1.dec{7,1} = subband_hig_hig_2;
                set1.dec{8,1} = vertical_band;
                set1.dec{9,1} = hors_band_C;
                set1.dec{10,1} = diag_band_A;
                EI = indwt2(set1,'aa',1);
                [MSE(7,k) PSNR(7,k)] = GetPSNR(data_set,EI);
                thresh(7,k) = coeff(k);
            end
    
            coeff = linspace(Aminmax(8,1),Aminmax(8,2),n);
            for k = 1:length(coeff)
                hors_band_C(hors_band_C<coeff(k)) = hors_band_A(hors_band_C<coeff(k));
                                hors_band_C = masking(hors_band_C,hors_band_B,coeff(k),'HL');
                hors_band_C = smooth_filte(hors_band_C,3);
                set1.dec{2,1} = subband_low_hig;
                set1.dec{3,1} = subband_hig_low;
                set1.dec{4,1} = subband_hig_hig;
                set1.dec{5,1} = subband_low_hig_2;
                set1.dec{6,1} = subband_hig_low_2;
                set1.dec{7,1} = subband_hig_hig_2;
                set1.dec{8,1} = vertical_band;
                set1.dec{9,1} = hors_band_C;
                set1.dec{10,1} = diag_band_A;
                EI = indwt2(set1,'aa',1);
                [MSE(8,k) PSNR(8,k)] = GetPSNR(data_set,EI);
                thresh(8,k) = coeff(k);
            end
            coeff = linspace(Aminmax(9,1),Aminmax(9,2),n);
            for k = 1:length(coeff)
                    diag_band_A(diag_band_A<coeff(k)) = diag_band_C(diag_band_A<coeff(k));
                
                diag_band_A = masking(diag_band_A,diag_band_B,coeff(k),'HH');
                
                diag_band_A = smooth_filte(diag_band_A,3);
                                set1.dec{2,1} = subband_low_hig;
                set1.dec{3,1} = subband_hig_low;
                set1.dec{4,1} = subband_hig_hig;
                set1.dec{5,1} = subband_low_hig_2;
                set1.dec{6,1} = subband_hig_low_2;
                set1.dec{7,1} = subband_hig_hig_2;
                set1.dec{8,1} = vertical_band;
                set1.dec{9,1} = hors_band_C;
                set1.dec{10,1} = diag_band_A;
                
                EI = indwt2(set1,'aa',1);
                
                [MSE(9,k) PSNR(9,k)] = GetPSNR(data_set,EI);
                thresh(9,k) = coeff(k);
            end
end