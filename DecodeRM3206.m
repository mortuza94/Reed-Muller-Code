function [point] = DecodeRM3206(x)
S = [
 0,0,0,0,0,0,0,0;
 1,1,1,1,1,1,1,1;
 0,0,0,0,1,1,1,1;
 1,1,1,1,0,0,0,0;
 0,0,1,1,0,0,1,1;
 1,1,0,0,1,1,0,0; 
 0,0,1,1,1,1,0,0;
 1,1,0,0,0,0,1,1;
 0,1,0,1,0,1,0,1; 
 1,0,1,0,1,0,1,0;
 0,1,0,1,1,0,1,0;
 1,0,1,0,0,1,0,1;
 0,1,1,0,0,1,1,0; 
 1,0,0,1,1,0,0,1;
 0,1,1,0,1,0,0,1;
 1,0,0,1,0,1,1,0 
];

[E1] = sum(xor(S, repmat(x(1:8),16,1)),2);
[E2] = sum(xor(S, repmat(x(9:16),16,1)),2);
[E3] = sum(xor(S, repmat(x(17:24),16,1)),2);
[E4] = sum(xor(S, repmat(x(25:32),16,1)),2);

Node1 = E1;
P1 = S;
[Node2, P2] = InteriorNode(Node1, E2, P1, S);
[Node3, P3] = InteriorNode(Node2, E3, P2, S);
[~, point] = FindMin(Node3, E4, P3, S);
end

function [Node, P] = InteriorNode(prevNode, E, prevPath, S)
% Calculate minimum path cost at interior nodes
Node = zeros(16,1);
P = zeros(size(prevPath)+[0 8]);
for i=1:8
    if (prevNode(2*i-1)+E(2*i-1) < prevNode(2*i)+E(2*i))
        Node(2*i-1) = prevNode(2*i-1)+E(2*i-1);
        P(2*i-1,:) = [prevPath(2*i-1,:) S(2*i-1,:)];
    else
        Node(2*i-1) = prevNode(2*i)+E(2*i);
        P(2*i-1,:) = [prevPath(2*i,:) S(2*i,:)];
    end 
    if (prevNode(2*i-1)+E(2*i)<prevNode(2*i)+E(2*i-1))
        Node(2*i) = prevNode(2*i-1)+E(2*i);
        P(2*i,:) = [prevPath(2*i-1,:) S(2*i,:)];
    else
        Node(2*i) = prevNode(2*i)+E(2*i-1);
        P(2*i,:) = [prevPath(2*i,:) S(2*i-1,:)];
    end
end
end

function [minVal, P] = FindMin(PrevNode, E, PrevPath, S)
[minVal, idx] = min(PrevNode + E);
P = [PrevPath(idx,:) S(idx,:)];
end


