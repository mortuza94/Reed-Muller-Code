classdef RM
    properties (Access = private)
        flagBoundary = 0;
        noOfStage = 4; % default is 4; for RM(-1,m) and RM(0,m) noOfStage = 1
        baseRM; % in the squaring construction S/U/T base RM corr. T
        cosetRep; % labelleing of the edges with the coset rep for the partition S/T
        nodeCost; % store partial path cost
        edgeLabel; % stores optimal path labelling
        G; % Generator matrix for RM(r,m)
        N; % dimension of vector 2^m
        noOfNodePerStage = 1; % number of node in each stage
        noOfNodePerClique = 1; % number of clique
        noOfClique; % noOfNodePerStage/noOfNodePerClique
        nodeEdgeOrder; % specify how the nodes in a clique are connected
        edgeLabelLength; % for non-boundary RM(r,m) it should be N/4
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
        
        function [point, d] = decode(obj, r)
            switch obj.flagBoundary
                case 1 % obj.cosetRep contains the list of codewords
                    c = r - 2*floor(r/2); % r = 2Z + c
                    M = repmat(c,obj.noOfNodePerStage,1);
                    E = sum((M - obj.cosetRep).^2,2);
                    [~, idx] = min(E);
                    point = obj.cosetRep(idx,:);
                case 0
                    L = obj.edgeLabelLength;
                    P = zeros(obj.noOfNodePerStage, obj.edgeLabelLength);
                    E = zeros(obj.noOfNodePerStage,1);
                    for i=1:obj.noOfStage
                        segr = repmat(r(1+(i-1)*L:i*L),obj.noOfNodePerStage,1)+obj.cosetRep;
                        M = segr - 2*floor(segr/2);
                        for j=1:obj.noOfNodePerStage
                            [y, d] = decode(obj.baseRM, M(j,:));
                            E(j) = d;
                            P(j,:) = y;
                        end
                        obj.nodeCost(:,i) = E;
                        obj.edgeLabel(:,:,i) = mod(P + obj.cosetRep,2);
                    end
                    nodeStage1 = obj.nodeCost(:,1);
                    pathLabel1 = obj.edgeLabel(:,:,1);
                    [nodeStage2, pathLabel2] = InteriorNode(obj, nodeStage1, pathLabel1, 2);
                    [nodeStage3, pathLabel3] = InteriorNode(obj, nodeStage2, pathLabel2, 3);
                    [point, ~] = FindMin(obj, nodeStage3, pathLabel3, 4);
                case -1
                    rr = round(r);
                    if mod(sum(rr),2) == 0
                        point = mod(rr,2);
                    else
                        [~, idx] = max(abs(r-rr));
                        rr = mod(rr,2);
                        rr(idx) = xor(rr(idx),1);
                        point = mod(rr,2);
                    end
            end
            d = sum((r-point).^2);
        end
        
        function y = encode(obj,v)
            y = mod(v*obj.G,2);
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