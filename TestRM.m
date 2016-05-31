function success = TestRM(r,m,fixedE)
rm = RM(r,m);
[K, N] = getDimensionGeneratorMatrix(rm);
NC = 2^K; % number of codeworkds
noCodewordTest = 2^10; % maximum number of codewords to test
inc = max(1,round(NC/noCodewordTest));
success = 1;
for i=0:inc:NC-1
    v = de2bi(i,K);
    x = encode(rm,v);
    e = ones(1,N)*fixedE;
    xe = x + e;
    y = decode(rm,xe);
    if (sum(x~=y)>0)
        disp(x);
        success = 0;
    end
end