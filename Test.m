function Test
[~, ~, C] = GenerateCodewordsRM(1,3);
k=4;
for i=1:2^k
    y = DecodeRM84(C(i,:));
    if (sum(C(i,:)~=y)>0)
        disp(x);
    end
end