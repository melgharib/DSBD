%
%  Licensed under the Creative Commons Attribution-NonCommercial 3.0 
%  License (the "License"). You may obtain a copy of the License at 
%  https://creativecommons.org/licenses/by-nc/3.0/.
%  Unless required by applicable law or agreed to in writing, software 
%  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
%  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
%  License for the specific language governing permissions and limitations 
%  under the License.
%
function read_binary_blob()
    read_binary_blob1('tv2007', 'p5', 'model');
    read_binary_blob1('tv2007', 'p6', 'model');

    read_binary_blob1('tv2001', 'p5', 'model');
    read_binary_blob1('tv2001', 'p6', 'model');

end
function [p, r, f] = read_binary_blob1(dataset, model_name, set_name)
    fprintf('hello!\n');
    %dataset = 'tv2007';
    %model_name = 'p6'
    %set_name = 'model'

    root = '/export/ds/mamdouh/deepLearning/data/nist/scripts/';
    dirName = strcat(root, dataset, '/io/test/');

    feature_files = dir(fullfile(dirName,'*_unbal_features_testlist_*') );

    feature_files = {feature_files.name}';

    lbl_files = dir(fullfile(dirName,'*_unbal_testlist_*') ); 
    lbl_files = {lbl_files.name}';
    mats_dir = strcat('/', set_name, '/mats/')

    disp(numel(feature_files));
    for i=1:numel(feature_files)

        features_file = fullfile(dirName, feature_files{i});
        lbl_file = fullfile(dirName, lbl_files{i});
        filename = strsplit(features_file, '_');
        filename = filename(end);
        filename = filename{1}(1:end-4);
        disp(filename);
        disp(lbl_file);
        %if strcmp(filename,'10')~=1
        %    continue;
        %end
        mats = strcat(dataset, '/', model_name, '/', mats_dir, filename, '/');
        
        if ~exist(mats, 'dir')
            mkdir(mats);
        end

        labels_file = fopen(lbl_file, 'r');
        testing_labels = textscan(labels_file,'%s %d %d\n');
        fclose(labels_file);
        starting_frame = testing_labels{2};
        testing_labels = testing_labels{3};
        test_lbl = strcat(mats, 'testing_labels.mat');
        if exist(test_lbl, 'file')
            fprintf('loading saved!\n');
        else
            fprintf('reading from the disk!\n');
            fileID_testing = fopen(features_file, 'r');
            files_testing = textscan(fileID_testing,'%s\n');
            fclose(fileID_testing);
            files_testing = files_testing{1};
            predicted_labels = matrixFeatures_porb(files_testing, model_name);
            save([mats 'testing_labels.mat'], 'testing_labels');
            save([mats 'predicted_labels.mat'], 'predicted_labels');    
            save([mats 'starting_frame.mat'], 'starting_frame');    
        end
    end

end

