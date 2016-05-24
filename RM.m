classdef RM
    properties (Access = private)
        flagBoundary = 0;
        noOfStage = 4; % default is 4; for RM(-1,m) and RM(0,m) noOfStage = 1
        
        baseRM;
        cosetRep;
        nodeCost;
        edgeLabel;    
        
        G; % Generator matrix        
        N; % dimension of vector 2^m
        
        noOfNodePerStage = 1; % number of node in each stage
        noOfNodePerClique = 1; % number of clique
        noOfClique; % noOfNodePerStage/noOfNodePerClique
        nodeEdgeOrder;
        edgeLabelLength; % N/4
    end
    %%%%%%%%%%%%%%%%%%%%%%%% CONSTRUCTOR and PUBLIC METHODS %%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = public)
        function obj = RM(r, m)
            obj = obj.initPre(r, m);
            if (r==-1)
                obj= obj.init_1();
            elseif (r==0)
                obj = obj.init_0();
            elseif (r==1) && (m==3)
                obj = obj.init84();
            elseif (r==1) && (m==4)
                obj = obj.init1605();
            elseif (r==2) && (m==4)
                obj = obj.init1611();
            elseif (r==1) && (m==5)
                obj = obj.init3206();
            elseif (r==2) && (m==5)
                obj = obj.init3216();
            elseif (r==3) && (m==5)
                obj = obj.init3226();
            else
                obj = obj.initm_1m();
            end
            obj = obj.initPost();
        end
        
        function [point, d] = decode(obj, x)
            switch obj.flagBoundary
                case 1
                    v = repmat(x,obj.noOfNodePerStage,1);
                    e = sum((v-obj.cosetRep).^2,2);
                    [d, idx] = min(e);
                    point = obj.cosetRep(idx,:);
                case 0
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
                case -1
                    rx = round(x);
                    if mod(sum(rx),2) == 0
                        point = mod(rx,2);
                    else
                        [~, idx] = max(abs(x-rx));
                        rx = mod(rx,2);
                        rx(idx) = xor(rx(idx),1);
                        point = mod(rx,2);
                    end
                    d = sum((x-point).^2);
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%% PRIVATE METHODS %%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        
        function obj = initPre(obj, r, m)
            obj.N = 2^m;
            obj.G = getGeneratorMatrixRM(r,m);            
        end
        
        function obj = initPost(obj)
            obj.noOfClique = obj.noOfNodePerStage/obj.noOfNodePerClique;
            obj.edgeLabelLength = obj.N/obj.noOfStage;
            obj.nodeCost = zeros(obj.noOfNodePerStage,obj.noOfStage);
            obj.edgeLabel = zeros(obj.noOfNodePerStage,obj.edgeLabelLength,obj.noOfStage);            
        end
        
        function obj = init_1(obj)
            obj.flagBoundary = 1;
            obj.noOfNodePerStage = 1;
            obj.noOfStage = 1;
            obj.cosetRep = zeros(1,obj.N);

        end
        
        function obj = init_0(obj)
            obj.flagBoundary = 1;
            obj.noOfNodePerStage = 2;
            obj.noOfStage = 1;
            obj.cosetRep = [zeros(1,obj.N); ones(1,obj.N)];
         end
        
        function obj = initm_1m(obj)
            obj.flagBoundary = -1;
            obj.noOfStage = 1;            
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
            obj.noOfNodePerStage = 4;
            obj.noOfNodePerClique = 2;
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
            obj.noOfNodePerStage = 8;
            obj.noOfNodePerClique = 2;
        end
        
        function obj = init1611(obj)
            obj.cosetRep = [
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
            obj.baseRM = RM(0,2);
            obj.noOfNodePerStage = 8;
            obj.noOfNodePerClique = 4;
        end
        
        function obj = init3206(obj)
            obj.cosetRep = [
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
            obj.baseRM = RM(-1,3);
            obj.noOfNodePerStage = 16;
            obj.noOfNodePerClique = 2;
        end
        
        function obj = init3216(obj)
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
            obj.cosetRep = mod(A + cosetRM87RM84,2);
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
            obj.baseRM = RM(0,3);
            obj.noOfNodePerStage = 64;
            obj.noOfNodePerClique = 8;
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
            obj.noOfNodePerStage = 16;
            obj.noOfNodePerClique = 8;
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