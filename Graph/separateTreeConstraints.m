
function [tree_edges,cnstr_edges]=separateTreeConstraints(tree,ed)

% Separate the tree a

tree = tree + tree';
% tree
[rows,cols] = find(tree);
%
treeIndices = ismember(ed(:,1:2)+1,[rows,cols],'rows');
tree_edges = full(ed(treeIndices, :));
if nargout > 1
    cnstr_edges=full(ed(~treeIndices,:));
end