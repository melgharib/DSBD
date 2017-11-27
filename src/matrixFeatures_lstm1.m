
function [features] = matrixFeatures_lstm1(files, model_name)
	
	total = size(files, 1);
	features = zeros(total, 4096);
	for i=1:total
		if mod(i, 1000) == 0
			fprintf('iteration: %d/%d\n', i, total);
		end
        elm = files{i};
        
        elm = strcat(elm, '_', model_name, '.lstm1');
        %disp(elm)
		[dim6, lstm1] = read_binary_blob_preserve_shape(elm);
		%dim6
		features(i, :) = reshape(lstm1, [1,4096]);
	end

end




