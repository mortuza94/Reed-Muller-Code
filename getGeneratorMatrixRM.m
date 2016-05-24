function [G, Gc] = getGeneratorMatrixRM(r,n)
% G is the generator matrix and Gc complementary generator matrix
B = [0 1; 1 1];
C = B;
for i=2:n
    B = kron(B,C);
end
N = 2^n;
W = 2^(n-r);
K = 0;
for k=0:r
    K = K + nchoosek(n, k);
end
G = zeros(K,N);
Gc = zeros(N-K,N);
j=0;
k=0;
for i=1:N
    if (sum(B(i,:))<W)
        k=k+1;
        Gc(k,:) = B(i,:);
    else
        j=j+1;
        G(j,:) = B(i,:);
    end
end
end