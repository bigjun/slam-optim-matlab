
function [Graph,System]=separateTreeConstraintsFromMatrix(subgraph,Graph,System)

[rows,cols] = find(subgraph);
n=size(Graph.F,1);
ind=1;
System.A1=[];
System.A2=[];
while ind<n
    RowCol=Graph.F(ind).RowCol;
    %factorR=Graph.F(ind);
    rowA=Graph.F(ind).ndxA;
    if ismember(RowCol,[rows,cols],'rows')
        %Graph.F.inTheSubgraph='subgraph';
        System.A1=[System.A1;System.A(rowA,:)];
    else 
         %Graph.F.inTheSubgraph='cnstr';
        System.A2=[System.A2;System.A(rowA,:)];
    end
    ind=ind+1;
end

    