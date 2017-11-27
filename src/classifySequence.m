

function classifySequence()

    classifySequence1('tv2001', 'p12w1n1c0', 'p12b', 'prob', '', '');
    
end


function [predicted_labels, acc, decision_values] = classifySequence1(dataset, model_name, set_name, feature_name, normalized, model2)

	%dataset = 'tv2001';
	c_type = 'segments0';
	
	root = '../data/';
	dirName = strcat(root, dataset, '/io/', c_type, '/');

	feature_files = dir( fullfile(dirName,'*_unbal_features_testlist_*') );
    lbl_files = dir( fullfile(dirName,'*_unbal_testlist_*') );

	disp(dataset);
	disp(model_name);
	disp(feature_name);


	feature_files = {feature_files.name}';
	lbl_files = {lbl_files.name}';

	%keyboard;
	for i=1:numel(feature_files)
		features_file = fullfile(dirName, feature_files{i});
		lbl_file = fullfile(dirName, lbl_files{i});
		filename = strsplit(features_file, '_');
		%filename = strread(features_file,'%s','delimiter','_')
		filename = filename(end);
		filename = filename{1}(1:end-4);
		filename = sprintf('%02d', i-1);
		disp('filename');
		disp(filename);
		%disp(lbl_file);

		mats = strcat(dataset, '/', model_name, '/', set_name, '/', feature_name, '/mats', c_type, '/', filename, '/');
		if ~exist(mats, 'dir')
			mkdir(mats);
		end
		
	    labels_file = fopen(lbl_file, 'r');
	    testing_labels = textscan(labels_file,'%s %d %d\n');
	    disp(testing_labels);
	    files_paths = testing_labels{1};
	    fclose(labels_file);
	    starting_frame = testing_labels{2};
	    testing_labels = testing_labels{3};
	    datasets = [];
	    videos_name = [];

	    test_lbl = strcat(mats, 'testing_labels.mat');
	    test_feat= strcat(mats, 'testing_features.mat');

	    if exist(test_lbl, 'file')
	    	fprintf('loading saved!\n');
	    	testing_labels = load(test_lbl);
	    	testing_labels = testing_labels.testing_labels;

	    	testing_features = load(test_feat);
	    	testing_features = testing_features.testing_features;
	    else
	    	fprintf('reading from the disk!\n');
		    fileID_testing = fopen(features_file, 'r');
			files_testing = textscan(fileID_testing,'%s\n');
		    fclose(fileID_testing);
		    files_testing = files_testing{1};
		    if strcmp(feature_name, 'fc6')
		    	testing_features = matrixFeatures_fc61(files_testing, model_name);
		    elseif strcmp(feature_name, 'prob')
		    	testing_features = matrixFeatures_fc81(files_testing, model_name);
		    elseif strcmp(feature_name, 'pool5')
		    	testing_features = matrixFeatures_pool51(files_testing, model_name);
		    elseif strcmp(feature_name, 'fc7')
		    	testing_features = matrixFeatures_fc71(files_testing, model_name);
		    elseif strcmp(feature_name, 'fc8')
		    	testing_features = matrixFeatures_fc81(files_testing, model_name);
		    elseif strcmp(feature_name, 'lstm1-drop')
		    	testing_features = matrixFeatures_lstmdrop1(files_testing, model_name);
		    elseif strcmp(feature_name, 'lstm1')
		    	testing_features = matrixFeatures_lstm1(files_testing, model_name);
		    end

		   	%save([mats 'datasets.mat'], '-v7.3', 'datasets');
		    %save([mats 'videos_name.mat'], '-v7.3', 'videos_name');

		   	save([mats 'testing_labels.mat'], '-v7.3', 'testing_labels');
		    save([mats 'testing_features.mat'], '-v7.3', 'testing_features');	
		    save([mats 'starting_frame.mat'], '-v7.3', 'starting_frame');	

	    end
	    if strcmp(feature_name, 'prob') && isempty(model2)
	    	evaluate_prop(mats, testing_features, testing_labels, starting_frame, files_paths);
	    	continue;
	    end
	   	%fprintf('%d\n', size(testing_labels, 1));
    	%[testing_labels, testing_features] = matrixFeatures(files_testing, testing_labels);
		%fprintf('%d %d\n', size(testing_labels, 1), size(testing_features, 1));
		model_file = strcat(model_name, '/mats/', set_name, '/', feature_name, '/model.mat');
		evaluate_sequence(mats, model_file, testing_features, testing_labels, starting_frame);

		mats = strcat(dataset, '/', model_name, '/', set_name, '/', feature_name, '/mats_normalized/', filename, '/');
		if ~exist(mats, 'dir')
			mkdir(mats);
		end
		model_file = strcat(model_name, '/mats/', set_name, '/', feature_name, '/model_normalized.mat');
		evaluate_sequence(mats, model_file, testing_features, testing_labels, starting_frame);
    end

end
function evaluate_sequence(mats, model_file, testing_features, testing_labels, starting_frame)
	predicted_file = strcat(mats, 'predicted_labels.mat');
	if ~exist(predicted_file, 'file') && exist(model_file, 'file')
		model = load(model_file, 'model');
		model = model.model;
    	
    	[predicted_labels, acc, decision_values] = predict(double(testing_labels), sparse(testing_features), model, ['liblinear_options', 'col']);
    	save([mats 'predicted_labels.mat'], 'predicted_labels');
    	save([mats 'decision_values.mat'], 'decision_values');
    	%save([mats 'starting_frame.mat'], '-v7.3', 'starting_frame');	
		%save([mats 'testing_labels.mat'], '-v7.3', 'testing_labels');

    end
    save([mats 'starting_frame.mat'], '-v7.3', 'starting_frame');	
	save([mats 'testing_labels.mat'], '-v7.3', 'testing_labels');

end

function evaluate_prop(mats, testing_features, testing_labels, starting_frame, files_paths)
	predicted_file = strcat(mats, 'predicted_labels.mat');
	
	%[predicted_labels, acc, decision_values] = predict(double(testing_labels), sparse(testing_features), model, ['liblinear_options', 'col']);
	decision_values = testing_features;
	[M, predicted_labels] = max(decision_values, [], 2);
	predicted_labels = predicted_labels - 1;
	%disp(testing_labels);
	%disp( predicted_labels);
	%disp(size(predicted_labels));
	%disp(size(testing_labels));
	%disp(size(decision_values));
	matches = sum((testing_labels) == predicted_labels);
	total = size(testing_labels,1);
	accuracy = matches/(total*1.0);
	fprintf('%0.4f %d/%d\n', accuracy, matches, total);
	save([mats 'predicted_labels.mat'], 'predicted_labels');
	save([mats 'decision_values.mat'], 'decision_values');
    save([mats 'starting_frame.mat'], '-v7.3', 'starting_frame');	
	save([mats 'testing_labels.mat'], '-v7.3', 'testing_labels');

	save([mats 'files_paths.mat'], '-v7.3', 'files_paths');

end

function [features] = normalize_features()
	features = features-mean(features(:));
	features = features/std(features(:));
end

function [lbls, features] = matrixFeatures(files, testing_labels)
	
	total = size(files, 1);
	features = zeros(total, 2048);
	lbls = zeros(total, 1);
	top = 1;
	for i=1:total
		if mod(i, 1000) == 0
			fprintf('iteration: %d/%d\n', i, total);
		end
        elm = files{i};
        %disp(elm)
		[dimp, prob] = read_binary_blob_preserve_shape([elm '.prob']);
		[v, idx] = max(prob);
		%disp(idx);
		if idx == 1
			continue;
		end
		[dim6, fc6] = read_binary_blob_preserve_shape([elm '.fc6']);
		%dim6
		features(top, :) = fc6(1,:,1,1);
		lbls(top) = testing_labels(i);
		top = top+1;
	end
	top = top - 1;
	features = features(1:top, :);
	lbls = lbls(1:top);
end
