classdef RM
    properties (Access = private)
        codeMain; % A
        flagComplement;
        codeComplement; % B
        nodeCost; % E
        edgeLabel; % S
        N; % dimension of vector 2^m
        noOfNodePerStage; % number of node in each stage
        noOfNodePerClique; % number of clique
        noOfClique; % noOfNodePerStage/noOfNodePerClique
        nodeEdgeOrder;
        edgeLabelLength; % N/4
        noOfStage = 4;
    end
    methods
        %%%%%%%%%%%%%%%%%%%%%%%% CONSTRUCTOR METHODS %%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = RM(r, m)
            if (r==2) && (m==4)
                obj = obj.init1611();
            elseif (r==1) && (m==4)
                obj = obj.init1605();
            elseif (r==1) && (m==3)
                obj = obj.init84();
            else
                obj = obj.init1611();
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%% PUBLIC METHODS %%%%%%%%%%%%%%%%%%%%%%%%%
        function [point, d] = decode(obj, x)
            W = obj.edgeLabelLength;
            E = zeros(obj.noOfNodePerStage, 1);
            S = zeros(obj.noOfNodePerStage, obj.edgeLabelLength);
            if (obj.flagComplement == 1)
                for i=1:obj.noOfStage
                    tA = sum(xor(obj.codeMain, repmat(x(1+(i-1)*W:i*W),obj.noOfNodePerStage,1)),2);
                    tB = sum(xor(obj.codeComplement, repmat(x(1+(i-1)*W:i*W),obj.noOfNodePerStage,1)),2);
                    E(tA<=tB) = tA(tA<=tB);
                    E(tA>tB) = tB(tA>tB);
                    S(tA<=tB,:) = obj.codeMain(tA<=tB,:);
                    S(tA>tB,:) = obj.codeComplement(tA>tB,:);
                    obj.nodeCost(:,i) = E;
                    obj.edgeLabel(:,:,i) = S;
                end
            else
                for i=1:obj.noOfStage
                    obj.nodeCost(:,i) = sum(xor(obj.codeMain, repmat(x(1+(i-1)*W:i*W),obj.noOfNodePerStage,1)),2);
                    obj.edgeLabel(:,:,i) = obj.codeMain;
                end
            end
            Node1 = obj.nodeCost(:,1);
            P1 = obj.edgeLabel(:,:,1);
            [Node2, P2] = InteriorNode(obj, Node1, P1, 2);
            [Node3, P3] = InteriorNode(obj, Node2, P2, 3);
            [d, point] = FindMin(obj, Node3, P3, 4);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%% PRIVATE METHODS %%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        function obj = init84(obj)
            obj.codeMain = [
                0 0;
                1 1;
                0 1;
                1 0
                ];
            obj.nodeEdgeOrder = [
                1 2;
                2 1
                ];
            obj.flagComplement = 0;
            obj.N = 2^3;
            obj.noOfNodePerStage = 4;
            obj.noOfNodePerClique = 2;
            obj.noOfClique = obj.noOfNodePerStage/obj.noOfNodePerClique;
            obj.edgeLabelLength = obj.N/4;
            %             obj.codeComplement = xor(obj.codeMain, repmat(zeros(size(obj.codeMain(1,:))), obj.noOfNodePerStage, 1));
            obj.nodeCost = zeros(obj.noOfNodePerStage,obj.edgeLabelLength);
            obj.edgeLabel = zeros(obj.noOfNodePerStage,obj.edgeLabelLength,obj.noOfStage);
        end
        function obj = init1605(obj)
            obj.codeMain = [
                0 0 0 0;
                1 1 1 1;
                0 0 1 1;
                1 1 0 0;
                0 1 0 1;
                1 0 1 0;
                0 1 1 0;
                1 0 0 1
                ];
            obj.nodeEdgeOrder = [
                1 2;
                2 1
                ];
            obj.flagComplement = 0;
            obj.N = 2^4;
            obj.noOfNodePerStage = 8;
            obj.noOfNodePerClique = 2;
            obj.noOfClique = obj.noOfNodePerStage/obj.noOfNodePerClique;
            obj.edgeLabelLength = obj.N/4;
            %             obj.codeComplement = xor(obj.codeMain, repmat(zeros(size(obj.codeMain(1,:))), obj.noOfNodePerStage, 1));
            obj.nodeCost = zeros(obj.noOfNodePerStage,obj.edgeLabelLength);
            obj.edgeLabel = zeros(obj.noOfNodePerStage,obj.edgeLabelLength,obj.noOfStage);
        end
        function obj = init1611(obj)
            obj.codeMain = [
                0 0 0 0;
                0 0 1 1;
                0 1 0 1;
                0 1 1 0;
                0 0 0 1;
                0 0 1 0;
                0 1 0 0;
                0 1 1 1
                ];
            obj.nodeEdgeOrder = [
                1 2 3 4;
                2 1 4 3;
                3 4 1 2;
                4 3 2 1];
            obj.flagComplement = 1;
            obj.N = 2^4;
            obj.noOfNodePerStage = 8;
            obj.noOfNodePerClique = 4;
            obj.noOfClique = obj.noOfNodePerStage/obj.noOfNodePerClique;
            obj.edgeLabelLength = obj.N/4;
            obj.codeComplement = xor(obj.codeMain, repmat(ones(size(obj.codeMain(1,:))), obj.noOfNodePerStage, 1));
            obj.nodeCost = zeros(obj.noOfNodePerStage,obj.edgeLabelLength);
            obj.edgeLabel = zeros(obj.noOfNodePerStage,obj.edgeLabelLength,obj.noOfStage);
        end
        
        function [Node, P] = InteriorNode(obj, prevNode, prevPath, ind)
            E = obj.nodeCost(:,ind);
            S = obj.edgeLabel(:,:,ind);
            P = zeros(size(prevPath)+[0 obj.edgeLabelLength]);
            CS = obj.noOfNodePerClique;
            Node = zeros(obj.noOfNodePerStage,1);
            for j=1:obj.noOfClique
                d = (j-1)*CS;
                prevVec = prevNode(d+1:d+CS);
                curE = E(d+1:d+CS);
                curS = S(d+1:d+CS,:);
                for i=1:CS
                    k = d + i;
                    tE = curE(obj.nodeEdgeOrder(:,i));
                    tS = curS(obj.nodeEdgeOrder(:,i),:);
                    [e, idx] = min(prevVec + tE);
                    Node(k) = e;
                    P(k,:) = [prevPath(d+idx,:) tS(idx,:)];
                end
            end
        end
        
        function [minVal, P] = FindMin(obj, PrevNode, PrevPath, ind)
            E = obj.nodeCost(:,ind);
            S = obj.edgeLabel(:,:,ind);
            [minVal, idx] = min(PrevNode + E);
            P = [PrevPath(idx,:) S(idx,:)];
        end
        
    end
end