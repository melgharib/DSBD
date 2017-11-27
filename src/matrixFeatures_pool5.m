
function [features] = matrixFeatures_pool5(files)
	
	total = size(files, 1);
	features = zeros(total, 2048);
	for i=1:total
		if mod(i, 1000) == 0
			fprintf('iteration: %d/%d\n', i, total);
		end
        elm = files{i};
        
        elm = strcat(elm, '.pool5');
        %disp(elm)
		[dim5, pool5] = read_binary_blob_preserve_shape(elm);
		%dim6
		features(i, :) = reshape(pool5, [1,2048]);
	end

end


