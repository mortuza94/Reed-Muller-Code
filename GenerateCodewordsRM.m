function [G, Gc, C] = GenerateCodewordsRM(r,n)
% G is the generator matrix, C is the codeword matrix Gc complementary
% generator matrix
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
NC = 2^K;
C = zeros(NC,N);
for i=0:NC-1
    v = de2bi(i,K);
    C(i+1,:) = mod(v*G, 2);
end
end