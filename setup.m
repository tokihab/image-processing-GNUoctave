project_root = pwd;
addpath(genpath(project_root));
disp('Paths loaded! You can now run gui or guii.');
if exist('OCTAVE_VERSION', 'builtin') ~= 0
	try
		pkg('load', 'image');
	catch
	end
end
