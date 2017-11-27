function visualize_filters()

	input_file = '/data/mamdouh/nist/c3dmodel/p12w1n1c0/io/test/test167_balanced_features.dsbdn6';
	input_file = '/data/mamdouh/nist/scripts/filters_visualization/io/visualize_features.txt';
	input_file = '/data/mamdouh/nist/scripts/filters_visualization/io/synthetic_ucf_features.dsbdn6';

	fileID_segments = fopen(input_file, 'r');
	files_segments = textscan(fileID_segments,'%s\n'); 
	files_segments = files_segments{1};
	lbl_file = '/data/mamdouh/nist/c3dmodel/p12w1n1c0/io/test/test167_balanced_list.txt';
	lbl_file = '/data/mamdouh/nist/scripts/filters_visualization/io/visualize_list.txt';
	lbl_file = '/data/mamdouh/nist/scripts/filters_visualization/io/synthetic_ucf_list.txt';
	
    labels_file = fopen(lbl_file, 'r');
    testing_labels = textscan(labels_file,'%s %d %d\n');
	testing_labels = testing_labels{3};

	total = size(files_segments, 1);
	disp(size(files_segments));
	filters = {'conv1', 'conv2', 'conv3', 'conv4', 'conv5', 'pool1', 'pool2', 'pool5'};
	visualization_output = '/data/mamdouh/nist/scripts/filters_visualization';
	disp(total);
	for i=1:total

		cfname = files_segments{i};
		disp(cfname);
		cf_parts = strsplit(cfname, '/');
		%dataset = cf_parts{6};
		%c_type = cf_parts{8};
		%video_name = cf_parts{9};
		%segment_index = cf_parts{10};
		%file_base = cf_parts{11};
		if numel(cf_parts) == 10
			dataset = cf_parts{4};
			c_type = cf_parts{7};
			video_name = cf_parts{8};
			segment_index = cf_parts{9};
			file_base = cf_parts{10};
		elseif numel(cf_parts) == 9
			dataset = cf_parts{4};
			c_type = cf_parts{6};
			video_name = cf_parts{7};
			segment_index = cf_parts{8};
			file_base = cf_parts{9};
		end
		cls = testing_labels(i);

		disp(dataset);
		disp(c_type);
		disp(video_name);
		disp(segment_index);
		disp(file_base);
		disp(cls);
		%if cls~=1
		%	continue;
		%end
		for j=1:8
			filter_name = filters{j};
			cfiltername = strcat(cfname, '.', filter_name);
			[dims, curr_filter] = read_binary_blob_preserve_shape(cfiltername);
			%visualize_direction_x(curr_filter, visualization_output, dataset, c_type, cls, video_name, segment_index, filter_name, file_base, 0);
			visualize_direction_x(curr_filter, visualization_output, dataset, c_type, cls, video_name, segment_index, filter_name, file_base, 1);
			%visualize_direction_x(curr_filter, visualization_output, dataset, c_type, cls, video_name, segment_index, filter_name, file_base, 2);
		end
		%return;

	end
end


function visualize_direction_x(curr_filter, visualization_output, dataset, c_type, cls, video_name, segment_index, filter_name, file_base, direction)
	if direction == 0
		curr_filter = permute(curr_filter, [1, 2, 3, 4, 5]);
	elseif direction == 1
		curr_filter = permute(curr_filter, [1, 2, 4, 3, 5]);
	elseif direction == 2
		curr_filter = permute(curr_filter, [1, 2, 5, 3, 4]);
	end
	temporal_dim = size(curr_filter, 3);
	filter_dims = size(curr_filter, 5);
	accumalate = [];
	accumalate_avg = [];
	for t=1:temporal_dim
		
		[layer_image, avg_image] = get_layer_image(curr_filter, t);
		output_folder = sprintf('%s/%s/%s/%d/%s/%s/%s/%03d/', visualization_output, dataset, c_type, cls, video_name, segment_index, filter_name, direction);
		output_path = sprintf('%s%s-%03d.jpg', output_folder, file_base, t);
		if ~exist(output_folder, 'dir')
			mkdir(output_folder)
		end
		imwrite(layer_image, output_path);
		if t == 1
			accumalate = layer_image;
			accumalate_avg = avg_image;
		else
			accumalate = accumalate + layer_image;
			accumalate_avg = accumalate_avg + avg_image;
		end
	end
	accumalate = accumalate./temporal_dim;
	accumalate_avg = accumalate_avg./temporal_dim;
	if direction == 1 && strcmp(filter_name, 'conv5')
		disp(size(accumalate_avg));

		output_folder = sprintf('%s/%s/conv5/%s/', visualization_output, dataset, video_name);
		output_path = sprintf('%s%s_%d.jpg', output_folder, file_base, cls);

		if ~exist(output_folder, 'dir')
			mkdir(output_folder)
		end
		%size(accumalate);
		%accumalate = padarray(accumalate, [2, 0, 0])
		no_filters = size(curr_filter, 2);
		filter_hight = size(curr_filter, 4);
		filter_width = size(curr_filter, 5);
		disp(no_filters);
		disp(filter_width);
		disp(filter_hight);

		accumalate_rgb = zeros(size(accumalate, 1), size(accumalate, 2), 3);
		accumalate_rgb = imresize(accumalate, 4);
		accumalate_rgb = repmat(accumalate_rgb, [1 1 3]);
		accumalate_rgb = padarray(accumalate_rgb, [1 1, 0], 'post');
		ii = 1:filter_hight*4:size(accumalate_rgb,1);
		jj = 1:filter_width*4:size(accumalate_rgb,2);
		accumalate_rgb(:,jj,2)=1;
		accumalate_rgb(ii,:,2)=1;

		%for ii=1:size(accumalate, 1)
		%	%disp(ii);
		%	for jj=1:size(accumalate, 2)
		%		if accumalate(ii, jj) < 0
		%			%disp(accumalate(ii, jj));
		%			%fprintf('%d %d\n', ii, jj);
		%			accumalate_rgb(ii,jj,:)=[0 1 0];
		%		else
		%			%accumalate_rgb(ii, jj, :)=repmat(accumalate(ii, jj),[1 1 3]);
		%			accumalate_rgb(ii, jj, :)=accumalate(ii, jj);
		%		end
		%	end
		%end

		imwrite(accumalate_rgb, output_path);


		output_folder = sprintf('%s/%s/filters/%s/', visualization_output, dataset, video_name);
		output_path = sprintf('%s%s_%d.jpg', output_folder, file_base, cls);

		if ~exist(output_folder, 'dir')
			mkdir(output_folder)
		end
		%accumalate_avg = sum(accumalate_avg, 1)./size(accumalate_avg, 1);
		%w_avg = uint32(ceil(sqrt(size(accumalate_avg, 2 ))));
		%accumalate_avg = reshape(accumalate_avg, w_avg, []);
		imwrite(accumalate_avg, output_path);
	end
end

function [layer_image, avg_image] = get_layer_image(curr_filter, t)
	%curr_filter = imresize(curr_filter, 4);
	%curr_filter = padarray(curr_filter, [0 0 0 1 1], -1, 'post');
	no_filters = size(curr_filter, 2);
	filter_hight = size(curr_filter, 4);
	filter_width = size(curr_filter, 5);

	filter_side_w = uint32(ceil(sqrt(no_filters)));
	filter_side_h = filter_side_w;
	filter_side_w_avg = no_filters;
	filter_side_h_avg = 1;
	layer_image = zeros(filter_side_h*filter_hight, filter_side_w*filter_width);
	avg_image = zeros(filter_side_h_avg*filter_hight, filter_side_w_avg);
	%disp(filter_width);
	%disp(filter_side_w_avg);
	for k=1:no_filters
		ii = idivide(k-1, filter_side_w, 'floor');
		%fprintf('%d %d %d\n', ii, k-1, filter_side_w);
		jj = mod((k-1), filter_side_w);
		%if jj == filter_side_w - 1
		%	break;
		%end
		feature_map = reshape(curr_filter(1, k, t, :, :), filter_hight, filter_width);
		
		%feature_map = norm(feature_map)
		%disp(ii*filter_hight+1);
		%disp((ii+1)*filter_hight);
		%disp(jj*filter_width+1);
		%disp((jj+1)*filter_width);
		%disp(size(feature_map));
		%disp(size(layer_image));
		%fprintf('%d %d %d %d - %d %d %d %d - %d\n', ii*filter_hight+1, (ii+1)*filter_hight, jj*filter_width+1, (jj+1)*filter_width, ii, jj, filter_side_w, filter_side_h, k)
		layer_image(ii*filter_hight+1:(ii+1)*filter_hight, jj*filter_width+1:(jj+1)*filter_width) = feature_map;
		%ii=0;
		%jj=k;
		%tmp = sum(feature_map, 2)./filter_width;
		%avg_image(1:filter_hight, jj) = tmp;
		%disp(filter_dims);
		%output_folder = sprintf('%s/%s/%s/%d/%s/%s/%s/%d/', visualization_output, dataset, c_type, cls, video_name, segment_index, filter_name, k);
		%output_path = sprintf('%s%s-%d.jpg', output_folder, file_base, t);
		%if ~exist(output_folder, 'dir')
		%	mkdir(output_folder)
		%end
		%n = size(unique(reshape(feature_map,size(feature_map,1)*size(feature_map,2),size(feature_map,3))),1);
		%rgb = feature_map;
		%%rgb = ind2rgb(gray2ind(feature_map,255),jet(n));
		%imwrite(rgb, output_path);
	end


end