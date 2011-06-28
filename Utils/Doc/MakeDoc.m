function MakeDoc
% Generates the documentation for this toolbox.
%
% Generates the html documentation for this toolbox.
% We assume m2html is available in the path.
% (Execute addpath <path to m2html>)
%
% The documentation can be browsed with a web browser opening
%     Doc/index.html
%
% This function only works in Linux.

if isunix || ismac
  if exist('m2html','file')==2
    % Remove the previous documentation if any
    eval('!rm -rf Doc');
    % generate the new documentation
    m2html('mfiles','.','htmldir','Doc','recursive','on','global','on','template','frame','index','menu','graph','on','todo','on');
    %
    eval('!sed -e ''s/\.\.\///g'' -i Doc/*.html');
  else
    error('m2html is not in the path');
  end
else
  error('Documentation can only be generated in Unix/Mac environments');
end