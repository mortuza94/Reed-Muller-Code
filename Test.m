
% function Test
% [~, ~, C] = GenerateCodewordsRM(1,4);
% rm = RM(1,4);
% [NC,~] = size(C);
% for i=1:NC
%     x = C(i,:);
%     e = zeros(1,16);
%     e(randi(16, 1, 3)) = 1;
%     xe = x + e;
%     y = decode(rm,xe);
%     if (sum(x~=y)>0)
%         disp(x);
%     end
% end

% function Test
% [~, ~, C] = GenerateCodewordsRM(1,3);
% rm = RM(1,3);
% [NC,~] = size(C);
% for i=1:NC
%     x = C(i,:);
%     e = zeros(1,8);
%     e(randi(8, 1, 1)) = 1;
%     xe = x + e;    
%     y = decode(rm,xe);
%     if (sum(x~=y)>0)
%         disp(x);
%     end
% end

function Test % 2,4/1611
[~, ~, C] = GenerateCodewordsRM(2,4);
rm = RM(2,4);
k=11;
[NC,~] = size(C);
for i=1:NC
    x = C(i,:);
    e = zeros(1,16);
    e(randi(16, 1, 1)) = 1;
    xe = x + e;    
    y = decode(rm,xe);
    if (sum(x~=y)>0)
        disp(x);
    end
end