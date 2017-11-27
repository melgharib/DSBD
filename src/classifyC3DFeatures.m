

function [predicted_label, acc, decision_values] = classifyC3DFeatures()

	%training_features = load('training_features.mat');
	%training_features = training_features.training_features;
	%size(training_features)
	%training_labels = load('training_labels.mat');
	%training_labels = training_labels.training_labels;
	
	%[training_features, training_labels] = matrixFeatures1(training_features, training_labels);
	
	%testing_features = load('testing_features.mat');
	%testing_features = testing_features.testing_features;
	%
    %testing_labels = load('testing_labels.mat');
	%testing_labels = testing_labels.testing_labels;
	
	%[testing_features, testing_labels] = matrixFeatures1(testing_features, testing_labels);

	save('training_features1.mat', '-v7.3', 'training_features');
    save('training_labels1.mat', 'training_labels');
    save('testing_features1.mat', '-v7.3', 'testing_features');
    save('testing_labels1.mat', 'testing_labels');

    training_features = normr(training_features);
    testing_features = normr(testing_features);

	model = train(double(training_labels), sparse(training_features), ['liblinear_options', 'col']); % '-v 10', '-e 0.001' 
    [predicted_label, acc, decision_values] = predict(double(testing_labels), sparse(testing_features), model, ['liblinear_options', 'col']);
    save('model1.mat', 'model');
    save('predicted_label1.mat', 'predicted_label');
    save('acc1.mat', 'acc');
    save('decision_values1.mat', 'decision_values');

end

function [predicted_label, acc, decision_values] = classifyC3DFeatures3()

	training_features = load('training_features.mat');
	training_features = training_features.training_features;
	size(training_features)
	training_labels = load('training_labels.mat');
	training_labels = training_labels.training_labels;
	
	[training_features, training_labels] = matrixFeatures3(training_features, training_labels);
	
	testing_features = load('testing_features.mat');
	testing_features = testing_features.testing_features;
	
    testing_labels = load('testing_labels.mat');
	testing_labels = testing_labels.testing_labels;
	
	[testing_features, testing_labels] = matrixFeatures3(testing_features, testing_labels);

	save('training_features3.mat', '-v7.3', 'training_features');
    save('training_labels3.mat', 'training_labels');
    save('testing_features3.mat', '-v7.3', 'testing_features');
    save('testing_labels3.mat', 'testing_labels');
    training_features = normr(training_features);
    testing_features = normr(testing_features);
	model = train(double(training_labels), sparse(training_features), ['liblinear_options', 'col']); 
    [predicted_label, acc, decision_values] = predict(double(testing_labels), sparse(testing_features), model, ['liblinear_options', 'col']);
    save('model3.mat', 'model');
    save('predicted_label3.mat', 'predicted_label');
    save('acc3.mat', 'acc');
    save('decision_values3.mat', 'decision_values');

end










function [predicted_label, acc, decision_values] = classifyC3DFeatures2()

	training_features = load('training_features.mat');
	training_features = training_features.training_features;
	size(training_features)
	training_labels = load('training_labels.mat');
	training_labels = training_labels.training_labels;
	
	[training_features, training_labels] = matrixFeatures2(training_features, training_labels);
	
	testing_features = load('testing_features.mat');
	testing_features = testing_features.testing_features;
	
    testing_labels = load('testing_labels.mat');
	testing_labels = testing_labels.testing_labels;
	
	[testing_features, testing_labels] = matrixFeatures2(testing_features, testing_labels);

	save('training_features2.mat', '-v7.3', 'training_features');
    save('training_labels2.mat', 'training_labels');
    save('testing_features2.mat', '-v7.3', 'testing_features');
    save('testing_labels2.mat', 'testing_labels');
	model = train(double(training_labels), sparse(training_features), ['liblinear_options', 'col']); 
    [predicted_label, acc, decision_values] = predict(double(testing_labels), sparse(testing_features), model, ['liblinear_options', 'col']);
    save('model2.mat', 'model');
    save('predicted_label2.mat', 'predicted_label');
    save('acc2.mat', 'acc');
    save('decision_values2.mat', 'decision_values');

end


function [predicted_label, acc, decision_values] = classifyC3DFeaturesOrig()

	global training_features training_labels testing_features testing_labels;
	if isempty(training_features)

		fileID_training = fopen('../../../data/nist/scripts/trecvid2005/8overlapSegments/trecVid2005_unbal_features_trainlist_00.txt','r');
		files_training = textscan(fileID_training,'%s\n');
	    fclose(fileID_training);
	    files_training = files_training{1};
	    training_features = matrixFeatures(files_training);
		
		labels_file = fopen('../../../data/nist/scripts/trecvid2005/8overlapSegments/trecVid2005_unbal_trainlist_00.txt','r');
	    training_labels = textscan(labels_file,'%s %d %d\n');
	    fclose(labels_file);
	    training_labels = training_labels{3};
	    
		fileID_testing = fopen('../../../data/nist/scripts/trecvid2005/8overlapSegments/trecVid2005_unbal_features_testlist_00.txt','r');
		files_testing = textscan(fileID_testing,'%s\n');
	    fclose(fileID_testing);
	    files_testing = files_testing{1};
	    testing_features = matrixFeatures(files_testing);

	    labels_file = fopen('../../../data/nist/scripts/trecvid2005/8overlapSegments/trecVid2005_unbal_testlist_00.txt','r');
	    testing_labels = textscan(labels_file,'%s %d %d\n');
	    fclose(labels_file);
	    testing_labels = testing_labels{3};
	end

    size(training_features)
    size(training_labels)
    size(testing_features)
    size(testing_labels)
	
	save('training_features.mat', 'training_features');
    save('training_labels.mat', 'training_labels');
    save('testing_features.mat', 'testing_features');
    save('testing_labels.mat', 'testing_labels');
	model = train(double(training_labels), sparse(training_features), ['liblinear_options', 'col']); 
    [predicted_label, acc, decision_values] = predict(double(testing_labels), sparse(testing_features), model, ['liblinear_options', 'col']);
    save('model.mat', 'model');
    save('predicted_label.mat', 'predicted_label');
    save('acc.mat', 'acc');
    save('decision_values.mat', 'decision_values');
end





function [features] = matrixFeatures(files)
	
	total = size(files, 1);
	features = zeros(total, 2048);
	for i=1:total
		if mod(i, 1000) == 0
			fprintf('iteration: %d/%d\n', i, total);
		end
        elm = files{i};
        %disp(elm)
		[dim6, fc6] = read_binary_blob_preserve_shape([elm '.fc6']);
		%dim6
		features(i, :) = fc6(1,:,1,1);
	end

end



function [features, labels] = matrixFeatures1(features1, labels1)
	
	total = ceil(size(features1, 1)/2.0);
	labels = zeros(total, 1);
	features = zeros(total, 2048);
	for i=1:2:size(features1, 1)
		if mod(i, 1000) == 0
			fprintf('iteration: %d/%d\n', i, total);
		end
		cidx = floor(i/2)+1;
		features(cidx, :) = features1(i, :);
		labels(cidx) = labels1(i);
	end

end


function [features, labels] = matrixFeatures2(features1, labels1)
	
	total = size(features1, 1)-1;
	labels = zeros(total, 1);
	features = zeros(total, 2048*2);
	for i=2:size(features1, 1)
		if mod(i, 1000) == 0
			fprintf('iteration: %d/%d\n', i, total);
		end
		features(i-1, :) = cat(2, features1(i-1,:), features1(i, :));
		labels(i-1) = max(labels1(i-1), labels1(i));
	end

end



function [features, labels] = matrixFeatures3(features1, labels1)
	
	total = size(features1, 1)-2;
	labels = zeros(total, 1);
	features = zeros(total, 2048*3);
	for i=3:size(features1, 1)
		if mod(i, 1000) == 0
			fprintf('iteration: %d/%d\n', i, total);
		end
		features(i-2, :) = cat(2, features1(i-2,:), features1(i-1,:), features1(i, :));
		labels(i-2) = max(labels1(i-2), max(labels1(i-1), labels1(i)));
	end

end


function n = normr(m)
	%NORMR Normalize rows of matrix.
	%
	%   NORMR(M)
	%     M - a matrix.
	%   Returns a matrix the same size with each
	%   row normalized to a vector length of 1.
	%
	%   See also NORMC, PNORMC.

	% Mark Beale, 1-31-92
	% Copyright (c) 1992-97 by The MathWorks, Inc.
	% $Revision: 1.3 $  $Date: 1997/05/14 22:10:50 $

	if nargin < 1,error('Not enough input arguments.'); end

	[mr,mc]=size(m);
	if (mc == 1)
	  n = m ./ abs(m);
	else
	    n=sqrt(ones./(sum((m.*m)')))'*ones(1,mc).*m;
	end
end