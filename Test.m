
function Test
r = 2;
m = 5;
ecr = 2^(m-r)/2-1; % error correcting radius of RM(r,m) code
[G, ~] = getGeneratorMatrixRM(r,m);
[K, N] = size(G);
NC = 2^K; % number of codeworkds
noCodewordTest = 2^10; % maximum number of codewords to test
inc = max(1,round(NC/noCodewordTest));
rm = RM(r,m);
for i=0:inc:NC-1
    v = de2bi(i,K);
    x = mod(v*G, 2);
    e = zeros(1,N);
    e(randi(N, 1, ecr)) = 1; % introduces d_min/2-1 errors
    xe = x + e;
    y = decode(rm,xe);
    if (sum(x~=y)>0)
        disp(x);
    end
end