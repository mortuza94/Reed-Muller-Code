function [point, d] = DecodeRM1605(x)
S = [
    0 0 0 0;
    1 1 1 1;
    0 0 1 1;
    1 1 0 0;
    0 1 0 1;
    1 0 1 0;
    0 1 1 0;
    1 0 0 1
    ];
E1 = sum(xor(S, repmat(x(1:4),8,1)),2);
E2 = sum(xor(S, repmat(x(5:8),8,1)),2);
E3 = sum(xor(S, repmat(x(9:12),8,1)),2);
E4 = sum(xor(S, repmat(x(13:16),8,1)),2);

Node1 = E1;
P1 = S;
[Node2, P2] = InteriorNode(Node1, E2, P1, S);
[Node3, P3] = InteriorNode(Node2, E3, P2, S);
[d, point] = FindMin(Node3, E4, P3, S);
end

function [Node, P] = InteriorNode(prevNode, E, prevPath, S)
Node = zeros(8,1);
P = zeros(size(prevPath)+[0 4]);
for i=1:4
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

