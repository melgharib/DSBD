
function [features] = matrixFeatures_fc81(files, model_name)
	
	total = size(files, 1);

	features = [];
	flg = 0;
	for i=1:total
		if mod(i, 1000) == 0
			fprintf('iteration: %d/%d\n', i, total);
		end
        elm = files{i};
        
        elm = strcat(elm, '_', model_name, '.fc8');
        %elm = strcat(elm, '.fc8');
        %disp(elm)
		[dim6, fc8] = read_binary_blob_preserve_shape(elm);
		%dim6
		%disp(fc8)

		if flg == 0
			no_features = size(fc8, 2);
			features = zeros(total, no_features);
			flg = 1;
		end
		%features = [features; fc8(1, :,1, 1)];
		features(i, :) = fc8(1,:,1,1);
		%disp(size(features));
		%disp(features(i, :));
	end

end




