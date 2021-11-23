function encoded_string = rle_encode(message)
%RLE 
encoded_string = "";
i = 1;

while(i <= length(message) - 1)
    cnt = 1;
    ch = message(i);
    j = i;
    while(j < length(message) - 1)
        if(message(j) == message(j + 1))
            cnt = cnt + 1;
            j = j + 1;
        else
           break;
        end
    end
    new_ch = convertCharsToStrings(ch);
    encoded_string = encoded_string + cnt + new_ch;
    i = j + 1;
end

end

