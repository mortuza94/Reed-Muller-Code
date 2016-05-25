clear;
fixedE = 0;
for m=1:5
    for r=0:m-1
        N = 2^m;
        ecr = 2^(m-r-2) - 0.0001;
        fixedE = sqrt(ecr/N);
        success = Test(r,m,fixedE);
        disp([r m, success]);
    end
end