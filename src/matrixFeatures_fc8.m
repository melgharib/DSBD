
function [features] = matrixFeatures_fc8(files)
	
	total = size(files, 1);
	features = zeros(total, 3);
	for i=1:total
		if mod(i, 1000) == 0
			fprintf('iteration: %d/%d\n', i, total);
		end
        elm = files{i};
        
        elm = strcat(elm, '.fc8');
        %disp(elm)
		[dim6, fc6] = read_binary_blob_preserve_shape(elm);
		%dim6
		features(i, :) = fc6(1,:,1,1);
	end

end




