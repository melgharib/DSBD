function [features] = matrix_fc6(files, model1, model2)
	%new_root = '/export/ds/mamdouh/deepLearning/data/nist/'
	%old_root = '/data/mamdouh/nist/'
	feature_name = '.fc6'
	total = size(files, 1);
	features = zeros(total, 4096);
	for i=1:total
		if mod(i, 1000) == 0
			fprintf('iteration: %d/%d\n', i, total);
		end
        elm = files{i};
        %elm = strrep(elm, old_root, new_root);
        %disp(elm)
        elm1 = strcat(elm, '_', model1, feature_name);
        elm2 = strcat(elm, '_', model2, feature_name);
        
		[d1, f1] = read_binary_blob_preserve_shape(elm1);
		[d2, f2] = read_binary_blob_preserve_shape(elm2);
		%disp(size(f1));
		features(i, :) = cat(2, f1(1,:), f2(1,:));
		%disp((features(i, :)));
		
	end

end
