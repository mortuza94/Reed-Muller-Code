function Test1611
[G, Gc, C] = GenerateCodewordsRM(2,4);
rm = RM(2,4);
for i=0:7:2^11-1
    v = de2bi(i,11);
    x = mod(v*G,2);  
    y = DecodeRM1611(x);
    if (sum(x~=y)>0)
        disp(x);
    end
end