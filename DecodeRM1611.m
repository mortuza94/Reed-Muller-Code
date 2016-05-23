function [point, d] = DecodeRM1611(x)
E1 = zeros(8,1);
E2 = zeros(8,1);
E3 = zeros(8,1);
E4 = zeros(8,1);

S1 = zeros(8,4);
S2 = zeros(8,4);
S3 = zeros(8,4);
S4 = zeros(8,4);
A = [
    0 0 0 0;
    0 0 1 1;
    0 1 0 1;
    0 1 1 0;
    0 0 0 1;
    0 0 1 0;
    0 1 0 0;
    0 1 1 1
    ];
B = xor(A,repmat([1 1 1 1], 8, 1));

tA1 = sum(xor(A, repmat(x(1:4),8,1)),2);
tA2 = sum(xor(A, repmat(x(5:8),8,1)),2);
tA3 = sum(xor(A, repmat(x(9:12),8,1)),2);
tA4 = sum(xor(A, repmat(x(13:16),8,1)),2);

tB1 = sum(xor(B, repmat(x(1:4),8,1)),2);
tB2 = sum(xor(B, repmat(x(5:8),8,1)),2);
tB3 = sum(xor(B, repmat(x(9:12),8,1)),2);
tB4 = sum(xor(B, repmat(x(13:16),8,1)),2);

E1(tA1<=tB1) = tA1(tA1<=tB1);
E1(tA1>tB1) = tB1(tA1>tB1);
S1(tA1<=tB1,:) = A(tA1<=tB1,:);
S1(tA1>tB1,:) = B(tA1>tB1,:);

E2(tA2<=tB2) = tA2(tA2<=tB2);
E2(tA2>tB2) = tB2(tA2>tB2);
S2(tA2<=tB2,:) = A(tA2<=tB2,:);
S2(tA2>tB2,:) = B(tA2>tB2,:);

E3(tA3<=tB3) = tA3(tA3<=tB3);
E3(tA3>tB3) = tB3(tA3>tB3);
S3(tA3<=tB3,:) = A(tA3<=tB3,:);
S3(tA3>tB3,:) = B(tA3>tB3,:);

E4(tA4<=tB4) = tA4(tA4<=tB4);
E4(tA4>tB4) = tB4(tA4>tB4);
S4(tA4<=tB4,:) = A(tA4<=tB4,:);
S4(tA4>tB4,:) = B(tA4>tB4,:);
Node1 = E1;
P1 = S1;
[Node2, P2] = InteriorNode(Node1, E2, P1, S2);
[Node3, P3] = InteriorNode(Node2, E3, P2, S3);
[d, point] = FindMin(Node3, E4, P3, S4);
end

function [Node, P] = InteriorNode(prevNode, E, prevPath, S)
[N, W] = size(S);
Node = zeros(N,1);
NS = 2;
CS = N/NS;
P = zeros(size(prevPath)+[0 W]);
for j=1:NS
    d = (j-1)*CS;
    prevVec = prevNode(d+1:d+CS);
    curE = E(d+1:d+CS);
    curS = S(d+1:d+CS,:);
    for i=1:CS
        k = d + i;
        tE =  circshift(curE,i-1);
        [e, idx] = min(prevVec + tE);
        Node(k) = e;
        tS = circshift(curS,i-1);
        P(k,:) = [prevPath(idx,:) tS(idx,:)];
    end
end
end

function [minVal, P] = FindMin(PrevNode, E, PrevPath, S)
[minVal, idx] = min(PrevNode + E);
P = [PrevPath(idx,:) S(idx,:)];
end

