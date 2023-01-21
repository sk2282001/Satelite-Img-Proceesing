function [thresh,MSE,PSNR,EI] = subfunction(OI,set1,set2,set3,n,thresh)


            
            ALH3 = set1.dec{2,1};BLH3 = set2.dec{2,1};CLH3 = set3.dec{2,1};   
            AHL3 = set1.dec{3,1};BHL3 = set2.dec{3,1};CHL3 = set3.dec{3,1};   
            AHH3 = set1.dec{4,1};BHH3 = set2.dec{4,1};CHH3 = set3.dec{4,1};  
            ALH2 = set1.dec{5,1};BLH2 = set2.dec{5,1};CLH2 = set3.dec{5,1};  
            AHL2 = set1.dec{6,1};BHL2 = set2.dec{6,1};CHL2 = set3.dec{6,1};  
            AHH2 = set1.dec{7,1};BHH2 = set2.dec{7,1};CHH2 = set3.dec{7,1};  
            vertical_band = set1.dec{8,1};vertical_band_B = set2.dec{8,1};vertical_band_C = set3.dec{8,1};    
            hors_band_C = set1.dec{9,1};hors_band_B = set2.dec{9,1};hors_band_A = set3.dec{9,1};   
            diag_band_A = set1.dec{10,1};diag_band_B = set2.dec{10,1};diag_band_C = set3.dec{10,1};
            ALH3(ALH3<thresh) = CLH3(ALH3<thresh);
            ALH3 = masking(ALH3,BLH3,thresh,'LH');

            ALH3 = smooth_filte(ALH3,3);
            AHL3(AHL3<thresh) = CHL3(AHL3<thresh);

            AHL3 = masking(AHL3,BHL3,thresh,'HL');

            AHL3 = smooth_filte(AHL3,3);
            AHH3(AHH3<thresh) = CHH3(AHH3<thresh);
            AHH3 = masking(AHH3,BHH3,thresh,'HH');
            AHH3 = smooth_filte(AHH3,3);

            ALH2(ALH2<thresh) = CLH2(ALH2<thresh);
            ALH2 = masking(ALH2,BLH2,thresh,'LH');
            ALH2 = smooth_filte(ALH2,3);
            AHL2(AHL2<thresh) = CHL2(AHL2<thresh);
            AHL2 = masking(AHL2,BHL2,thresh,'HL');
            AHL2 = smooth_filte(AHL2,3);
            AHH2(AHH2<thresh) = CHH2(AHH2<thresh);
            AHH2 = masking(AHH2,BHH2,thresh,'HH');
            AHH2 = smooth_filte(AHH2,3);
            vertical_band(vertical_band<thresh) = vertical_band_C(vertical_band<thresh);
            vertical_band = masking(vertical_band,vertical_band_B,thresh,'LH');
            vertical_band = smooth_filte(vertical_band,3);
            hors_band_C(hors_band_C<thresh) = hors_band_A(hors_band_C<thresh);
            hors_band_C = masking(hors_band_C,hors_band_B,thresh,'HL');
            hors_band_C = smooth_filte(hors_band_C,3);
            diag_band_A(diag_band_A<thresh) = diag_band_C(diag_band_A<thresh);
           
            diag_band_A = masking(diag_band_A,diag_band_B,thresh,'HH');
            
            diag_band_A = smooth_filte(diag_band_A,3);
            
            set1.dec{2,1} = ALH3;
            set1.dec{3,1} = AHL3;
            set1.dec{4,1} = AHH3;
            set1.dec{5,1} = ALH2;
            set1.dec{6,1} = AHL2;
            set1.dec{7,1} = AHH2;
            set1.dec{8,1} = vertical_band;
            set1.dec{9,1} = hors_band_C;
            set1.dec{10,1} = diag_band_A;
           
            EI = indwt2(set1,'aa',1);
            
            [MSE,PSNR] = GetPSNR(OI,EI);
            
       
end

