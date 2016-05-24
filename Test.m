
function success = Test(r,m,fixedE)
[G, ~] = getGeneratorMatrixRM(r,m);
[K, N] = size(G);
NC = 2^K; % number of codeworkds
noCodewordTest = 2^10; % maximum number of codewords to test
inc = max(1,round(NC/noCodewordTest));
rm = RM(r,m);
success = 1;
for i=0:inc:NC-1
    v = de2bi(i,K);
    x = mod(v*G, 2);
    e = ones(1,N)*fixedE;
    xe = x + e;
    y = decode(rm,xe);
    if (sum(x~=y)>0)
        disp(x);
        success = 0;
    end
end