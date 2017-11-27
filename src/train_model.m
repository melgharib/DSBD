function model = train_model()


	dataset = 'p16a';
	feature_name = 'fc6' %'lstm1-drop', 'fc6', 'fc7', 'fc8', 'pool5';
	model_name = 'dsbdn632'
	root = '/data/mamdouh/nist/scripts/';
	dirName = strcat(root, dataset, '/train/');
	
	%features_file = strcat(root, dataset, '/8overlapSegments/', dataset, '_unbal_features_testlist_', filename, '.txt ')
	%lbl_file = strcat(root, dataset, '/8overlapSegments/', dataset, '_unbal_testlist_', filename, '.txt ')
	
	%feature_files = dir( fullfile(dirName,'*_unbal_features_testlist_*') );
	disp(fullfile(dirName,strcat('*features*', model_name)));
	feature_files = dir(fullfile(dirName,strcat('*features*', model_name)));
	%p1_input_features.fixed   
	feature_files = {feature_files.name}';

	%lbl_files = dir( fullfile(dirName,'*_unbal_testlist_*') ); 
	lbl_files = dir(fullfile(dirName, strcat('*list*',model_name))); 
	
	lbl_files = {lbl_files.name}';

    %model = load('model1.mat', 'model');
    %model = model.model;
	disp(feature_files);
	disp(dataset);
	disp(feature_name);

    features_file = fullfile(dirName, feature_files{1});
	lbl_file = fullfile(dirName, lbl_files{1});
	
	mats = strcat(model_name, '/mats/', dataset, '/', feature_name, '/');%
	%fileID_testing = fopen('/export/ds/mamdouh/deepLearning/data/nist/scripts/trecVid2001/8overlapSegments/trecVid2001_unbal_features_testlist_05.txt', 'r');

    if exist(fullfile(mats, 'training_labels.mat'), 'file')
    	disp('loading all features at once!');
		training_features = load([mats 'training_features.mat']);
		training_features = training_features.training_features;
		size(training_features)
		training_labels = load([mats 'training_labels.mat']);
		training_labels = training_labels.training_labels;
    else
    	disp('reading features one by one!');
		mkdir(mats);
    	fileID_testing = fopen(features_file, 'r');
		files_testing = textscan(fileID_testing,'%s\n');
	    fclose(fileID_testing);
    	files_testing = files_testing{1};
	    if strcmp(feature_name, 'fc6')
	    	training_features = matrixFeatures_fc6(files_testing);
	    elseif strcmp(feature_name, 'fc7')
	    	training_features = matrixFeatures_fc7(files_testing);
	    elseif strcmp(feature_name, 'fc8')
	    	training_features = matrixFeatures_fc8(files_testing);
	    elseif strcmp(feature_name, 'pool5')
	    	training_features = matrixFeatures_pool5(files_testing);
	    elseif strcmp(feature_name, 'lstm1-drop')
	    	training_features = matrixFeatures_lstmdrop(files_testing);
	    elseif strcmp(feature_name, 'lstm1')
	    	training_features = matrixFeatures_lstm(files_testing);
	    end
	    labels_file = fopen(lbl_file, 'r');
	    testing_labels = textscan(labels_file,'%s %d %d\n');
	    fclose(labels_file);
	    training_labels = testing_labels{3}; 	
	    save([mats 'training_labels.mat'], '-v7.3', 'training_labels');
		save([mats 'training_features.mat'], '-v7.3', 'training_features');

    end
    disp(feature_files);
	disp(dataset);
	disp(feature_name);
    %labels_file = fopen('/export/ds/mamdouh/deepLearning/data/nist/scripts/trecVid2001/8overlapSegments/trecVid2001_unbal_testlist_05.txt', 'r');
    model = train(double(training_labels), sparse(training_features), ['liblinear_options', 'col']); % '-v 10', '-e 0.001' 
	save([mats 'model.mat'], 'model');
	training_features = training_features-mean(training_features(:));
	training_features = training_features/std(training_features(:));
	disp('training an SVM model with normalized features!');
	model = train(double(training_labels), sparse(training_features), ['liblinear_options', 'col']); % '-v 10', '-e 0.001' 
	save([mats 'model_normalized.mat'], 'model');
	%save([mats 'training_features_normalized.mat'], '-v7.3', 'training_features');
	disp(feature_files);
	disp(dataset);
	disp(feature_name);

end

function [features] = matrixFeatures(files, model_name)
	%new_root = '/export/ds/mamdouh/deepLearning/data/nist/'
	%old_root = '/data/mamdouh/nist/'
	total = size(files, 1);
	features = zeros(total, 2048);
	for i=1:total
		if mod(i, 1000) == 0
			fprintf('iteration: %d/%d\n', i, total);
		end
        elm = files{i};
        %elm = strrep(elm, old_root, new_root);
        elm = strcat(elm, '.fc6');
		disp(elm)
        
		[dim6, fc6] = read_binary_blob_preserve_shape(elm);
		%dim6
		features(i, :) = fc6(1,:,1,1);
	end

end
