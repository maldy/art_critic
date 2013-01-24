function compute_feature_vecs(feature, num_dataset)
    fprintf('Computing feature: %s\n', feature);
    
    cd('art_movements')
    dirinfo=dir();
    dirinfo(~[dirinfo.isdir])=[]; %remove any non-directories
    movements=dirinfo(3:size(dirinfo)); %remove the . and .. to avoid infinite looping
    
    num_movements = size(movements, 1);

    for i=1:num_movements,
        cd(movements(i).name) %inside the directory for one class
        files=dir('*.jpg');
        num_files=size(files, 1);
        filename = [feature, '_features.dat'];
        fid=fopen(filename,'w');
        for j=1:min(num_dataset,num_files(1)),
            fprintf('Processing image %d of Movement %s . . . \n',j,movements(i).name);

            img=imread(files(j).name);
            [r c d] = size(img);
            if d==1
                rgbImg = repmat(img,[1 1 3]);
                rgbImg = cat(3,img,img,img);
                img = rgbImg;   
            end
            switch feature
                case 'point'
                    cf = zeros(20,1);
                    R=img(:,:,1);
                    G=img(:,:,2);
                    B=img(:,:,3);
                    Y=uint8(0.299*double(R)+0.587*double(G)+0.114*double(B));
                    glcm=graycomatrix(Y);
                    
                    dark_pixel_count=0;
                    for m=1:r,
                        for n=1:c,
                            if(Y(m,n) < 64) %pixels with values in the range [0,64] are considered to be dark pixels
                                dark_pixel_count=dark_pixel_count+1;
                            end
                        end
                    end
                    cf(1)=dark_pixel_count/(r*c); 
                    
                    h=[-1 -2 -1;0 0 0;1 2 1];
                    gx=conv2(double(Y), h');
                    gy=conv2(double(Y), h);
                    g=hypot(gx, gy);
                    h=fspecial('sobel'); %Using a filter for better results :: Sobel
                    gx=imfilter(double(Y), h', 'replicate');
                    gy=imfilter(double(Y), h, 'replicate');
                    g_coefficient=0.0;
                    for m=1:r,
                        for n=1:c,
                            g_coefficient=g_coefficient+sqrt(gx(m,n)^2 + gy(m,n)^2);
                        end
                    end
                    cf(2)=g_coefficient; %store it in an array
                    
                    numpeaks = 0;
                    hist = imhist(Y);
                    threshold = median(hist);
                    hist_len = size(hist);
                    prev=0;
                    climbing = 0;
                    for m=1:hist_len(1),
                        if(prev < hist(m,1) && climbing==0 && hist(m,1) > threshold)
                            climbing = 1;
                            numpeaks = numpeaks + 1;
                        end
                        if(prev > hist(m,1) && climbing==1)
                            climbing = 0;
                        end
                        prev = hist(m,1);
                    end
                    cf(3) = numpeaks;
                    
                    [~, cf(4)] = max(hist);
                    
                    meangrey = mean(mean(Y));
                    r_slice = uint16(r/3);
                    c_slice = uint16(c/3);
                    deviation = 0.0;
                    for m=1:r_slice:r-r_slice+1,
                        for n=1:c_slice:c-c_slice+1,
                        bin_meangrey = mean(mean(Y(m:m+r_slice-1,n:n+c_slice-1)));
                        deviation = deviation + (bin_meangrey - meangrey);
                        end
                    end
                    cf(5) = deviation;
                    
                    cf(6) = skewness(double(Y(:)));
                    
                    gnh=canny(files(j).name,2,1,0.2);
                    [row,column]=size(gnh);
                    cf(7)=sum(sum(gnh))/(row*column);
                    
                    F=haralick(glcm);
                    cf(8:20) = F(:);

                case 'sparse_sift'
                    img = imresize(img, [128 128]);
                    [~, d] = vl_sift(single(rgb2gray(img)));
                    cf = d(:);
                    
                case 'small_dense_sift'
                    img = imresize(img, [32 32]);
                    [~, d] = vl_dsift(single(rgb2gray(img)));
                    cf = d(:);
                    
                case 'dense_sift'
                    img = imresize(img, [128 128]);
                    [~, d] = vl_dsift(single(rgb2gray(img)));
                    cf = d(:);
                    
                case 'hog_orig'
                    img = imresize(img, [128 NaN]);
                    h = features(double(img), 8);
                    cf = h(:);
                    
                case 'hog_resize'
                    img = imresize(img, [128 128]);
                    h = features(double(img), 8);
                    cf = h(:);
                    
                case 'gistGabor'
                    img = imresize(img, [min(r,c) min(r,c)]);
                    G = createGabor([8,8,4], min(r,c));
                    output = prefilt(double(img), 4);
                    cf = gistGabor(output, 4, G);
                        
                case 'color_hist'
                    img = rescale_max_size(img,400);
                    colorTransform = makecform('srgb2lab');
                    LAB_img = lab2double(applycform(img, colorTransform));
                    color_hist     = calc_color_hist_weighted( LAB_img, ones([size(LAB_img,1), size(LAB_img,2)]));
                    cf = color_hist(:);

                case 'simpsal_orig'
                    map = simpsal(img);
                    cf=map(:);
                    
                case 'simpsal_resize'
                    img = imresize(img, [max(r,c) max(r,c)]);
                    map = simpsal(img);
                    cf=map(:);
                    
                case 'line_length'
                    original_image_size = single(size(img));
                    [lines, conf, spdata] = calc_lines_img(img);
                    [~, length_hist] = calc_line_feats_img(lines, conf, zeros(original_image_size(1), original_image_size(2)), [], []);
                    cf = length_hist(:);
                    
                case 'line_angle'
                    original_image_size = single(size(img));
                    [lines, conf, spdata] = calc_lines_img(img);
                    [angle_hist, length_hist] = calc_line_feats_img(lines, conf, zeros(original_image_size(1), original_image_size(2)), [], []);
                    cf = angle_hist(:);
            end
            
            for k=1:size(cf,1),
                fprintf(fid, '%d ',cf(k));
            end
            fprintf(fid, '\n');
        end
        fclose(fid);
        cd('..')
    end
    fprintf('Processing done.\n');
    cd('..') %return to working directory
end