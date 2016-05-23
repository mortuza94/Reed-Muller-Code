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
        
        baseRM;
        cosetRep;
    end
    methods
    %%%%%%%%%%%%%%%%%%%%%%%% CONSTRUCTOR METHODS %%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = RM(r, m)
            if (r==-1)
                obj= obj.init_1(m);
            elseif (r==0)
                obj = obj.init_0(m);
            elseif (r==2) && (m==4)
                obj = obj.init1611();
            elseif (r==1) && (m==4)
                obj = obj.init1605();
            elseif (r==1) && (m==3)
                obj = obj.init84();
            elseif (r==1) && (m==5)
                obj = obj.init3206();
            elseif (r==2) && (m==5)
                obj = obj.init3216();
            elseif (r==3) && (m==5)
                obj = obj.init3226();
            else
                obj = obj.init1611();
            end
        end

        function [point, d] = decode(obj, x)
            if (obj.noOfStage==1)
                v = repmat(x,obj.noOfNodePerStage,1);
                e = sum(xor(v, obj.cosetRep),2);
                [d, idx] = min(e);
                point = obj.cosetRep(idx,:);
            else
                W = obj.edgeLabelLength;
                S = zeros(obj.noOfNodePerStage, obj.edgeLabelLength);
                E = zeros(obj.noOfNodePerStage,1);
                for i=1:obj.noOfStage
                    tx = repmat(x(1+(i-1)*W:i*W),obj.noOfNodePerStage,1);
                    T = mod(tx + obj.cosetRep,2);
                    for j=1:obj.noOfNodePerStage
                        [v, d] = decode(obj.baseRM, T(j,:));
                        E(j) = d;
                        S(j,:) = v;
                    end
                    obj.nodeCost(:,i) = E;
                    obj.edgeLabel(:,:,i) = mod(S + obj.cosetRep,2);
                end
                
                Node1 = obj.nodeCost(:,1);
                P1 = obj.edgeLabel(:,:,1);
                [Node2, P2] = InteriorNode(obj, Node1, P1, 2);
                [Node3, P3] = InteriorNode(obj, Node2, P2, 3);
                [point, d] = FindMin(obj, Node3, P3, 4);
            end
        end       
    end    
    %%%%%%%%%%%%%%%%%%%%%%%% PRIVATE METHODS %%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        function obj = init_1(obj, m)
            obj.N = 2^m;
            obj.noOfStage = 1;
            obj.noOfNodePerStage = 1;
            obj.cosetRep = zeros(1,obj.N);
        end
        
        function obj = init_0(obj, m)
            obj.N = 2^m;
            obj.noOfStage = 1;
            obj.noOfNodePerStage = 2;
            obj.cosetRep = [zeros(1,obj.N); ones(1,obj.N)];
        end
        
        function obj = init84(obj)
            obj.cosetRep = [
                0 0;
                1 1;
                0 1;
                1 0
                ];
            obj.nodeEdgeOrder = [
                1 2;
                2 1
                ];
            obj.baseRM = RM(-1,1);
            obj.N = 2^3;
            obj.noOfNodePerStage = 4;
            obj.noOfNodePerClique = 2;
            obj.noOfClique = obj.noOfNodePerStage/obj.noOfNodePerClique;
            obj.edgeLabelLength = obj.N/obj.noOfStage;
            obj.nodeCost = zeros(obj.noOfNodePerStage,obj.noOfStage);
            obj.edgeLabel = zeros(obj.noOfNodePerStage,obj.edgeLabelLength,obj.noOfStage);
        end
        
        function obj = init1605(obj)
            obj.cosetRep = [
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
            obj.baseRM = RM(-1,2);
            obj.N = 2^4;
            obj.noOfNodePerStage = 8;
            obj.noOfNodePerClique = 2;
            obj.noOfClique = obj.noOfNodePerStage/obj.noOfNodePerClique;
            obj.edgeLabelLength = obj.N/obj.noOfStage;
            obj.nodeCost = zeros(obj.noOfNodePerStage,obj.noOfStage);
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
        
        function obj = init3206(obj)
            obj.codeMain = [
                0 0 0 0 0 0 0 0;
                1 1 1 1 1 1 1 1;
                0 0 0 0 1 1 1 1;
                1 1 1 1 0 0 0 0;
                0 0 1 1 0 0 1 1;
                1 1 0 0 1 1 0 0;
                0 0 1 1 1 1 0 0;
                1 1 0 0 0 0 1 1;
                0 1 0 1 0 1 0 1;
                1 0 1 0 1 0 1 0;
                0 1 0 1 1 0 1 0;
                1 0 1 0 0 1 0 1;
                0 1 1 0 0 1 1 0;
                1 0 0 1 1 0 0 1;
                0 1 1 0 1 0 0 1;
                1 0 0 1 0 1 1 0
                ];
            obj.nodeEdgeOrder = [
                1 2;
                2 1
                ];
            obj.flagComplement = 0;
            obj.N = 2^5;
            obj.noOfNodePerStage = 16;
            obj.noOfNodePerClique = 2;
            obj.noOfClique = obj.noOfNodePerStage/obj.noOfNodePerClique;
            obj.edgeLabelLength = obj.N/4;            
            obj.nodeCost = zeros(obj.noOfNodePerStage,obj.edgeLabelLength);
            obj.edgeLabel = zeros(obj.noOfNodePerStage,obj.edgeLabelLength,obj.noOfStage);
        end
        
        function obj = init3216(obj)
            obj.flagComplement = 1;
            A = [
                0 0 0 0 0 0 0 0;
                0 0 0 0 1 1 1 1;
                0 0 1 1 0 0 1 1;
                0 0 1 1 1 1 0 0;
                0 1 0 1 0 1 0 1;
                0 1 0 1 1 0 1 0;
                0 1 1 0 0 1 1 0;
                0 1 1 0 1 0 0 1;
                ];
            A = repmat(A,8,1);
            B = xor(A,ones(size(A)));
            cosetRM87RM84 = kron([
                0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 1 1;
                0 0 0 0 0 1 0 1;
                0 0 0 1 0 0 0 1;
                0 0 0 0 0 1 1 0;
                0 0 0 1 0 1 0 0;
                0 0 0 1 0 0 1 0;
                0 0 0 1 0 1 1 1;
                ], [1 1 1 1 1 1 1 1]');
            
            obj.codeMain = mod(A + cosetRM87RM84,2);
            obj.codeComplement = mod(B + cosetRM87RM84,2);
            obj.nodeEdgeOrder = [
                1 2 3 4 5 6 7 8;
                2 1 4 3 6 5 8 7;
                3 4 1 2 7 8 5 6;
                4 3 2 1 8 7 6 5;
                5 6 7 8 1 2 3 4;
                6 5 8 7 2 1 4 3;
                7 8 5 6 3 4 1 2;
                8 7 6 5 4 3 2 1
                ];
            obj.N = 2^5;
            obj.noOfNodePerStage = 64;
            obj.noOfNodePerClique = 8;
            obj.noOfClique = obj.noOfNodePerStage/obj.noOfNodePerClique;
            obj.edgeLabelLength = obj.N/4;
            obj.nodeCost = zeros(obj.noOfNodePerStage,obj.edgeLabelLength);
            obj.edgeLabel = zeros(obj.noOfNodePerStage,obj.edgeLabelLength,obj.noOfStage);
        end
        
        function obj = init3226(obj)
            obj.cosetRep = [
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
            obj.nodeEdgeOrder = [
                1 2 3 4 5 6 7 8;
                2 1 4 3 6 5 8 7;
                3 4 1 2 7 8 5 6;
                4 3 2 1 8 7 6 5;
                5 6 7 8 1 2 3 4;
                6 5 8 7 2 1 4 3;
                7 8 5 6 3 4 1 2;
                8 7 6 5 4 3 2 1
                ];
            obj.baseRM = RM(1,3);
            obj.N = 2^5;
            obj.noOfNodePerStage = 16;
            obj.noOfNodePerClique = 8;
            obj.noOfClique = obj.noOfNodePerStage/obj.noOfNodePerClique;
            obj.edgeLabelLength = obj.N/4;
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
        
        function [P, minVal] = FindMin(obj, PrevNode, PrevPath, ind)
            E = obj.nodeCost(:,ind);
            S = obj.edgeLabel(:,:,ind);
            [minVal, idx] = min(PrevNode + E);
            P = [PrevPath(idx,:) S(idx,:)];
        end
        
    end
end


        %%%%%%%%%%%%%%%%%%%%%%%% PUBLIC METHODS %%%%%%%%%%%%%%%%%%%%%%%%%
%         function [point, d] = decodeOld(obj, x)
%             W = obj.edgeLabelLength;
%             E = zeros(obj.noOfNodePerStage, 1);
%             S = zeros(obj.noOfNodePerStage, obj.edgeLabelLength);
%             if (obj.flagComplement == 1)
%                 for i=1:obj.noOfStage
%                     tA = sum(xor(obj.codeMain, repmat(x(1+(i-1)*W:i*W),obj.noOfNodePerStage,1)),2);
%                     tB = sum(xor(obj.codeComplement, repmat(x(1+(i-1)*W:i*W),obj.noOfNodePerStage,1)),2);
%                     E(tA<=tB) = tA(tA<=tB);
%                     E(tA>tB) = tB(tA>tB);
%                     S(tA<=tB,:) = obj.codeMain(tA<=tB,:);
%                     S(tA>tB,:) = obj.codeComplement(tA>tB,:);
%                     obj.nodeCost(:,i) = E;
%                     obj.edgeLabel(:,:,i) = S;
%                 end
%             else
%                 for i=1:obj.noOfStage
%                     obj.nodeCost(:,i) = sum(xor(obj.codeMain, repmat(x(1+(i-1)*W:i*W),obj.noOfNodePerStage,1)),2);
%                     obj.edgeLabel(:,:,i) = obj.codeMain;
%                 end
%             end
%             Node1 = obj.nodeCost(:,1);
%             P1 = obj.edgeLabel(:,:,1);
%             [Node2, P2] = InteriorNode(obj, Node1, P1, 2);
%             [Node3, P3] = InteriorNode(obj, Node2, P2, 3);
%             [point, d] = FindMin(obj, Node3, P3, 4);
%         end
