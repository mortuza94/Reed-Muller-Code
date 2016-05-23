
function Test
r = 2;
m = 4;
N = 2^m;
skip = 2^2;
ecr = 2^(m-r)/2-1; % error correcting radius of RM(r,m) code
[~, ~, C] = GenerateCodewordsRM(r,m, skip);
rm = RM(r,m);
[NC,~] = size(C);
inc = max(1, round(NC/2^10)); % test maximum 1024 instances
for i=1:inc:NC
    x = C(i,:);
    e = zeros(1,N);
    e(randi(N, 1, ecr)) = 1; % introduces d_min/2-1 errors
    xe = x + e;
    y = decode(rm,xe);
    if (sum(x~=y)>0)
        disp(x);
    end
end