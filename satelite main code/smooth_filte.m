function I = smooth_filte(I,ms)

if nargin<2
    ms = 3;
elseif rem(ms,2)==0
    error('Mask dimension should be odd with only 3X3, 5X5, or 7X7');
elseif ms ~= 3 && ms ~= 5 && ms~= 7
    error(['Mask dimension size of ',num2str(ms),' X ',num2str(ms),...
            ' not handeled']);
end
if nargin<1,error('Input argument: Image missing');end


[r c] = size(I);                  
PI = zeros(r + ms - 1,c + ms - 1);

PI((ms/2+0.5):end - (ms/2 - 0.5),(ms/2 + 0.5):end - (ms/2 - 0.5)) = I;

for p = 1:r
    for q = 1:c
        mask = PI(p:ms + p - 1,q:ms + q - 1);

        if ms == 3

            d1 = [mask(3) mask(5) mask(7)];
            d2 = [mask(4) mask(5) mask(6)];
            d3 = [mask(1) mask(5) mask(9)];
            d4 = [mask(2) mask(5) mask(8)];
        elseif ms == 5

            d1 = [mask(5) mask(9) mask(13) mask(17) mask(21)];
            d2 = [mask(11) mask(12) mask(13) mask(14) mask(15)];
            d3 = [mask(1) mask(7) mask(13) mask(19) mask(25)];
            d4 = [mask(3) mask(8) mask(13) mask(18) mask(23)];
        elseif ms == 7

            d1 = [mask(7) mask(13) mask(19) mask(25) mask(31) mask(37) mask(43)];
            d2 = [mask(22) mask(23) mask(24) mask(25) mask(26) mask(27) mask(28)];
            d3 = [mask(1) mask(9) mask(17) mask(25) mask(33) mask(41) mask(49)];
            d4 = [mask(4) mask(11) mask(18) mask(25) mask(32) mask(39) mask(46)];
        else
            error('Situation could not be handeled');
        end
        

        v = mean([d1 d2 d3 d4]);
        V1 = abs(v - mask(ms/2 + 0.5,ms/2 + 0.5));
        [~,index] = min(V1);
        I(p,q) = v(index);
    end
end