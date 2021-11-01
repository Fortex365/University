function [ picture_output ] = matrix_dithering2( picture )
   
    [m, n] = size(picture);
    m2 = 2* m;
    n2 = 2* n;
    picture_output = zeros(m2 , n2);

        for i = 2 : 2 : m2
            for j = 2 : 2 : n2

             if (picture(i/2 , j/2) <= 255/5)
                picture_output(i-1, j-1) = 0;
                picture_output(i-1, j) = 0;            
                picture_output(i, j-1) = 0;          
                picture_output(i, j) = 0;         

             elseif (picture(i/2 , j/2) <= 2*255/5)
                picture_output(i-1, j-1) = 0;
                picture_output(i-1, j) = 0;
                picture_output(i, j-1) = 0;          
                picture_output(i, j) = 1; 

             elseif (picture(i/2 , j/2) <= 3*255/5)
                picture_output(i-1, j-1) = 0;                   
                picture_output(i-1, j) = 1;
                picture_output(i, j-1) = 1;   
                picture_output(i, j) = 0; 

            elseif (picture(i/2 , j/2) <= 4*255/5)
                picture_output(i-1, j-1) = 0;      
                picture_output(i-1, j) = 1;
                picture_output(i, j-1) = 1;    
                picture_output(i, j) = 1; 

            elseif (picture(i/2 , j/2) <= 5*255/5)
                picture_output(i-1, j-1) = 1;
                picture_output(i-1, j) = 1;
                picture_output(i, j-1) = 1;          
                picture_output(i, j) = 1; 

             end
            end
        end

end

