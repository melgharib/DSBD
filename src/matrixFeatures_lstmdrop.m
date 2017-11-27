
function [features] = matrixFeatures_fc6(files)
	
	total = size(files, 1);
	features = zeros(total, 4096);
	for i=1:total
		if mod(i, 1000) == 0
			fprintf('iteration: %d/%d\n', i, total);
		end
        elm = files{i};
        
        elm = strcat(elm, '.lstm1-drop');
        %disp(elm)
		[dim6, lstm1drop] = read_binary_blob_preserve_shape(elm);
		%dim6
		%disp(lstm1drop)
		features(i, :) = reshape(lstm1drop, [1,4096]);
	end

end




