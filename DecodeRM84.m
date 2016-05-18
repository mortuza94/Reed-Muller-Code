function [point,d] = DecodeRM84(x)
S = SectionLabeling([0 0; 0 1]);
E1 = sum(xor(S, repmat(x(1:2),4,1)),2);
E2 = sum(xor(S, repmat(x(3:4),4,1)),2);
E3 = sum(xor(S, repmat(x(5:6),4,1)),2);
E4 = sum(xor(S, repmat(x(7:8),4,1)),2);

Node1 = E1;
P1 = S;
[Node2, P2] = InteriorNode(Node1, E2, P1, S);
[Node3, P3] = InteriorNode(Node2, E3, P2, S);
[d, point] = FindMin(Node3, E4, P3, S);
end

function [Node, P] = InteriorNode(prevNode, E, prevPath, S)
% Calculate minimum path cost at interior nodes
Node = zeros(4,1);
P = zeros(size(prevPath)+[0 2]);
for i=1:2
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

function [S] = SectionLabeling(T)
S = zeros(4,2);
for i=1:2
    edge = T(i,:);
    One = ones(1,2);
    S(1+2*(i-1),:) = edge;
    S(2*i,:) = xor(edge, One);
end
end

function [minVal, P] = FindMin(PrevNode, E, PrevPath, S)
[minVal, idx] = min(PrevNode + E);
P = [PrevPath(idx,:) S(idx,:)];
end
