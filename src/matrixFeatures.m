
function [features] = matrixFeatures(files)
	
	total = size(files, 1);
	features = zeros(total, 2048);
	for i=1:total
        elm = files{i};
		[dim6, fc6] = read_binary_blob_preserve_shape([elm '.fc6']);
		features(i) = fc6(1,:,1,1)
	end

end