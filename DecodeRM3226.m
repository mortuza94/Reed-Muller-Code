function [point, d] = DecodeRM3226(x)
E1 = zeros(16,1);
E2 = zeros(16,1);
E3 = zeros(16,1);
E4 = zeros(16,1);

S1 = zeros(16,8);
S2 = zeros(16,8);
S3 = zeros(16,8);
S4 = zeros(16,8);
L = [
    0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 1 1;
    0 0 0 0 0 1 0 1;
    0 0 0 1 0 0 0 1;
    0 0 0 0 0 1 1 0;
    0 0 0 1 0 1 0 0;
    0 0 0 1 0 0 1 0;
    0 0 0 1 0 1 1 1;
    0 0 0 0 0 0 0 1;
    0 0 0 0 0 0 1 0;
    0 0 0 0 0 1 0 0;
    0 0 0 1 0 0 0 0;
    0 0 0 0 0 1 1 1;
    0 0 0 1 0 1 0 1;
    0 0 0 1 0 0 1 1;
    0 0 0 1 0 1 1 0;    
    ];

for j=1:4
    tx = x(1+(j-1)*8:j*8);    
    for i=1:16
        cosetRep = L(i,:);
        t = mod(tx + cosetRep,2);
        [v, d] = DecodeRM84(t);
        switch j
            case 1
                E1(i) = d;
                S1(i,:) = mod(v + cosetRep,2);
            case 2
                E2(i) = d;
                S2(i,:) = mod(v + cosetRep,2);
            case 3
                E3(i) = d;
                S3(i,:) = mod(v + cosetRep,2);
            otherwise
                E4(i) = d;
                S4(i,:) = mod(v + cosetRep,2);                
        end
    end
end

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

% function [Node, P] = InteriorNode(prevNode, E, prevPath, S)
% % Calculate minimum path cost at interior nodes
% Node = zeros(16,1);
% P = zeros(size(prevPath)+[0 8]);
% for j=1:2
%     d = (j-1)*8;
%     prevVec = prevNode(d+1:d+8);
%     curE = E(d+1:d+8);
%     curS = S(d+1:d+8,:);
%     for i=1:8
%         k = d + i;
%         tE =  circshift(curE,i-1);
%         [e, idx] = min(prevVec + tE);
%         Node(k) = e;
%         tS = circshift(curS,i-1);
%         P(k,:) = [prevPath(idx,:) tS(idx,:)];
%     end
% end
% end

function [minVal, P] = FindMin(PrevNode, E, PrevPath, S)
[minVal, idx] = min(PrevNode + E);
P = [PrevPath(idx,:) S(idx,:)];
end

