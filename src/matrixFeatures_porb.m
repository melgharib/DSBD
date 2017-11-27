
function [features] = matrixFeatures_porb(files, model_name)
    
    total = size(files, 1);
    features = zeros(total, 1);
    for i=1:total
        if mod(i, 1000) == 0
            fprintf('iteration: %d/%d\n', i, total);
        end
        elm = files{i};
        %disp(elm)
        elm = strcat(elm, '_', model_name, '.prob');

        [dimp, prob] = read_binary_blob_preserve_shape(elm);
        %dim6
        [v, idx] = max(prob);
        %disp(prob);

        features(i, 1) = idx-1;
    end

end