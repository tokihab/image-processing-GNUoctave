function gui
    % Create main figure
    mainFig = figure('Name', 'Image Processing Tool', 'Position', [100 100 1000 600], ...
        'NumberTitle', 'off', 'MenuBar', 'none', 'Resize', 'on');
    
    % Initialize variables
    originalImg = [];
    processedImg = [];
    currentImg = [];
    
    % Create UI components
    uicontrol('Style', 'text', 'Position', [20 560 150 20], 'String', 'Image Processing Tool', ...
        'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');
    
    % Create panels
    controlPanel = uipanel('Title', 'Controls', 'Position', [0.01 0.1 0.25 0.8]);
    originalImgPanel = uipanel('Title', 'Original Image', 'Position', [0.27 0.1 0.35 0.8]);
    processedImgPanel = uipanel('Title', 'Processed Image', 'Position', [0.63 0.1 0.35 0.8]);
    
    % Create axes for displaying images
    originalAxes = axes('Parent', originalImgPanel, 'Position', [0.05 0.05 0.9 0.9]);
    processedAxes = axes('Parent', processedImgPanel, 'Position', [0.05 0.05 0.9 0.9]);
    
    % Create control UI elements
    loadBtn = uicontrol('Parent', controlPanel, 'Style', 'pushbutton', 'String', 'Load Image', ...
        'Position', [20 350 120 30], 'Callback', @loadImage);
    
    filterText = uicontrol('Parent', controlPanel, 'Style', 'text', 'String', 'Select Filter:', ...
        'Position', [20 310 120 20], 'HorizontalAlignment', 'left');
    
    % Create dropdown for filter selection
    filterList = {'Select a filter...', ...
        'Adjust Brightness', 'Average Filter', 'Butterworth Filter', ...
        'Contrast Stretch', 'Correlation', 'Exponential Noise', ...
        'Fourier Transform', 'Gaussian Filter', 'Gamma Noise', ...
        'Gray to Binary', 'Gaussian Noise', 'Histogram', ...
        'Histogram Equalization', 'Ideal Low/High Pass', 'Inverse Fourier', ...
        'Line Detection', 'Line Sharpening', 'Log Transform', ...
        'Max Filter', 'Mean Filter', 'Median Filter', ...
        'Midpoint Filter', 'Min Filter', 'Negative', ...
        'Point Sharpening', 'Point Detection', 'RGB to Binary', ...
        'RGB to Gray', 'Rayleigh Noise', 'Roberts Mask', ...
        'Salt & Pepper Noise', 'Sobel Mask', 'Weighted Filter'};
    
    filterDropdown = uicontrol('Parent', controlPanel, 'Style', 'popupmenu', ...
        'String', filterList, 'Position', [20 280 200 30], ...
        'Callback', @filterSelected);
    
    % Parameter panel (initially hidden)
    paramPanel = uipanel('Parent', controlPanel, 'Title', 'Parameters', ...
        'Position', [0.05 0.05 0.9 0.55], 'Visible', 'off');
    
    % Apply button
    applyBtn = uicontrol('Parent', controlPanel, 'Style', 'pushbutton', ...
        'String', 'Apply Filter', 'Position', [20 80 120 30], ...
        'Callback', @applyFilter, 'Enable', 'off');
    
    % Save button
    saveBtn = uicontrol('Parent', controlPanel, 'Style', 'pushbutton', ...
        'String', 'Save Image', 'Position', [20 40 120 30], ...
        'Callback', @saveImage, 'Enable', 'off');
    
    % Reset button
    resetBtn = uicontrol('Parent', controlPanel, 'Style', 'pushbutton', ...
        'String', 'Reset Image', 'Position', [20 10 120 30], ...
        'Callback', @resetImage, 'Enable', 'off');
    
    % Parameter controls (created dynamically based on filter)
    paramControls = struct();
    currentFilter = '';
    
    % Callback functions
    function loadImage(~, ~)
        [filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif', 'Image Files'}, 'Select an Image');
        if filename ~= 0
            % Load the image
            originalImg = imread(fullfile(pathname, filename));
            currentImg = originalImg;
            
            % Display original image
            axes(originalAxes);
            imshow(originalImg);
            title('Original Image');
            
            % Display processed image (initially same as original)
            axes(processedAxes);
            imshow(originalImg);
            title('Processed Image (None Applied)');
            
            % Enable buttons
            applyBtn.Enable = 'on';
            resetBtn.Enable = 'on';
            saveBtn.Enable = 'on';
        end
    end
    
    function filterSelected(src, ~)
        % Get selected filter
        idx = src.Value;
        if idx == 1
            paramPanel.Visible = 'off';
            return;
        end
        
        currentFilter = filterList{idx};
        
        % Clear previous parameter controls
        children = get(paramPanel, 'Children');
        if ~isempty(children)
            delete(children);
        end
        
        % Create parameter controls based on selected filter
        switch currentFilter
            case 'Adjust Brightness'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Brightness Delta:', ...
                    'Position', [10 130 100 20], 'HorizontalAlignment', 'left');
                paramControls.delta = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '50', 'Position', [120 130 50 20]);
                
            case 'Butterworth Filter'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Cutoff Frequency (D0):', ...
                    'Position', [10 130 120 20], 'HorizontalAlignment', 'left');
                paramControls.D0 = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '30', 'Position', [140 130 50 20]);
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Order (n):', ...
                    'Position', [10 100 120 20], 'HorizontalAlignment', 'left');
                paramControls.n = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '2', 'Position', [140 100 50 20]);
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Filter Type:', ...
                    'Position', [10 70 120 20], 'HorizontalAlignment', 'left');
                paramControls.index = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Low Pass', 'High Pass'}, 'Position', [140 70 100 20]);
                
            case 'Correlation'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Kernel Type:', ...
                    'Position', [10 130 100 20], 'HorizontalAlignment', 'left');
                paramControls.kernelType = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Average', 'Sobel-X', 'Sobel-Y', 'Laplacian'}, ...
                    'Position', [120 130 100 20]);
                
            case 'Exponential Noise'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Parameter a:', ...
                    'Position', [10 130 100 20], 'HorizontalAlignment', 'left');
                paramControls.a = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '0.1', 'Position', [120 130 50 20]);
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Parameter b:', ...
                    'Position', [10 100 100 20], 'HorizontalAlignment', 'left');
                paramControls.b = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '1', 'Position', [120 100 50 20]);
                
            case 'Gaussian Filter'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Cutoff Frequency (D0):', ...
                    'Position', [10 130 120 20], 'HorizontalAlignment', 'left');
                paramControls.D0 = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '30', 'Position', [140 130 50 20]);
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Filter Type:', ...
                    'Position', [10 100 120 20], 'HorizontalAlignment', 'left');
                paramControls.index = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Low Pass', 'High Pass'}, 'Position', [140 100 100 20]);
                
            case 'Gamma Noise'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Parameter a:', ...
                    'Position', [10 130 100 20], 'HorizontalAlignment', 'left');
                paramControls.a = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '2', 'Position', [120 130 50 20]);
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Parameter b:', ...
                    'Position', [10 100 100 20], 'HorizontalAlignment', 'left');
                paramControls.b = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '2', 'Position', [120 100 50 20]);
                
            case 'Gray to Binary'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Threshold Method:', ...
                    'Position', [10 130 120 20], 'HorizontalAlignment', 'left');
                paramControls.index = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Fixed (128)', 'Mean', 'Median'}, 'Position', [140 130 100 20]);
                
            case 'Gaussian Noise'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Variance:', ...
                    'Position', [10 130 100 20], 'HorizontalAlignment', 'left');
                paramControls.v = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '20', 'Position', [120 130 50 20]);
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Mean:', ...
                    'Position', [10 100 100 20], 'HorizontalAlignment', 'left');
                paramControls.m = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '0', 'Position', [120 100 50 20]);
                
            case 'Ideal Low/High Pass'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Cutoff Frequency (D0):', ...
                    'Position', [10 130 120 20], 'HorizontalAlignment', 'left');
                paramControls.D0 = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '30', 'Position', [140 130 50 20]);
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Filter Type:', ...
                    'Position', [10 100 120 20], 'HorizontalAlignment', 'left');
                paramControls.index = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Low Pass', 'High Pass'}, 'Position', [140 100 100 20]);
                
            case 'Line Detection'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Direction:', ...
                    'Position', [10 130 100 20], 'HorizontalAlignment', 'left');
                paramControls.direction = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Horizontal (H)', 'Vertical (V)', 'Diagonal Left (DL)', 'Diagonal Right (DR)'}, ...
                    'Position', [120 130 150 20]);
                
            case 'Line Sharpening'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Direction:', ...
                    'Position', [10 130 100 20], 'HorizontalAlignment', 'left');
                paramControls.direction = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Horizontal (H)', 'Vertical (V)', 'Diagonal Left (DL)', 'Diagonal Right (DR)'}, ...
                    'Position', [120 130 150 20]);
                
            case 'Rayleigh Noise'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Parameter a:', ...
                    'Position', [10 130 100 20], 'HorizontalAlignment', 'left');
                paramControls.a = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '30', 'Position', [120 130 50 20]);
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Parameter b:', ...
                    'Position', [10 100 100 20], 'HorizontalAlignment', 'left');
                paramControls.b = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '2', 'Position', [120 100 50 20]);
                
            case 'RGB to Binary'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Conversion Method:', ...
                    'Position', [10 130 120 20], 'HorizontalAlignment', 'left');
                paramControls.index = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Average', 'Red Channel', 'Green Channel', 'Blue Channel', 'Weighted'}, ...
                    'Position', [140 130 100 20]);
                
            case 'RGB to Gray'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Conversion Method:', ...
                    'Position', [10 130 120 20], 'HorizontalAlignment', 'left');
                paramControls.index = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Average', 'Red Channel', 'Green Channel', 'Blue Channel', 'Weighted'}, ...
                    'Position', [140 130 100 20]);
                
            case 'Salt & Pepper Noise'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Salt Probability:', ...
                    'Position', [10 130 100 20], 'HorizontalAlignment', 'left');
                paramControls.ps = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '0.01', 'Position', [120 130 50 20]);
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Pepper Probability:', ...
                    'Position', [10 100 100 20], 'HorizontalAlignment', 'left');
                paramControls.pp = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '0.01', 'Position', [120 100 50 20]);
                
            case 'Sobel Mask'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Direction:', ...
                    'Position', [10 130 100 20], 'HorizontalAlignment', 'left');
                paramControls.direction = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Horizontal', 'Vertical'}, 'Position', [120 130 100 20]);
        end
        
        paramPanel.Visible = 'on';
    end
    
    function applyFilter(~, ~)
        if isempty(currentImg) || strcmp(currentFilter, '') || strcmp(currentFilter, 'Select a filter...')
            return;
        end
        
        % Process image based on selected filter
        try
            switch currentFilter
                case 'Adjust Brightness'
                    delta = str2double(get(paramControls.delta, 'String'));
                    processedImg = adjustBrightness(currentImg, delta);
                    
                case 'Average Filter'
                    % Check if grayscale is needed
                    if size(currentImg, 3) == 3
                        gray = RGB2GRY(currentImg, 1);
                        processedImg = AVGfltr(gray);
                    else
                        processedImg = AVGfltr(currentImg);
                    end
                    
                case 'Butterworth Filter'
                    D0 = str2double(get(paramControls.D0, 'String'));
                    n = str2double(get(paramControls.n, 'String'));
                    index = get(paramControls.index, 'Value') - 1; % 0 for low pass, 1 for high pass
                    
                    % Convert to gray if needed
                    if size(currentImg, 3) == 3
                        gray = RGB2GRY(currentImg, 1);
                        processedImg = BWF(gray, D0, n, index);
                    else
                        processedImg = BWF(currentImg, D0, n, index);
                    end
                    
                case 'Contrast Stretch'
                    % Convert to gray if needed
                    if size(currentImg, 3) == 3
                        gray = RGB2GRY(currentImg, 1);
                        processedImg = contrastStretch(gray);
                    else
                        processedImg = contrastStretch(currentImg);
                    end
                    
                case 'Correlation'
                    kernelType = get(paramControls.kernelType, 'Value');
                    
                    % Define different kernels
                    switch kernelType
                        case 1 % Average
                            kernel = ones(3,3)/9;
                        case 2 % Sobel-X
                            kernel = [-1 0 1; -2 0 2; -1 0 1];
                        case 3 % Sobel-Y
                            kernel = [-1 -2 -1; 0 0 0; 1 2 1];
                        case 4 % Laplacian
                            kernel = [-1 -1 -1; -1 8 -1; -1 -1 -1];
                    end
                    
                    processedImg = correlation(currentImg, kernel);
                    
                case 'Exponential Noise'
                    a = str2double(get(paramControls.a, 'String'));
                    b = str2double(get(paramControls.b, 'String'));
                    processedImg = expNoise(currentImg, a, b);
                    
                case 'Fourier Transform'
                    processedImg = fourierTransform(currentImg);
                    
                case 'Gaussian Filter'
                    D0 = str2double(get(paramControls.D0, 'String'));
                    index = get(paramControls.index, 'Value') - 1; % 0 for low pass, 1 for high pass
                    
                    % Convert to gray if needed
                    if size(currentImg, 3) == 3
                        gray = RGB2GRY(currentImg, 1);
                        processedImg = GF(gray, D0, index);
                    else
                        processedImg = GF(currentImg, D0, index);
                    end
                    
                case 'Gamma Noise'
                    a = str2double(get(paramControls.a, 'String'));
                    b = str2double(get(paramControls.b, 'String'));
                    processedImg = gmaNoise(currentImg, a, b);
                    
                case 'Gray to Binary'
                    % Check if grayscale is needed
                    if size(currentImg, 3) == 3
                        gray = RGB2GRY(currentImg, 1);
                        processedImg = GRY2BIN(gray, get(paramControls.index, 'Value'));
                    else
                        processedImg = GRY2BIN(currentImg, get(paramControls.index, 'Value'));
                    end
                    
                case 'Gaussian Noise'
                    v = str2double(get(paramControls.v, 'String'));
                    m = str2double(get(paramControls.m, 'String'));
                    processedImg = gussNoise(currentImg, v, m);
                    
                case 'Histogram'
                    % Check if grayscale is needed
                    if size(currentImg, 3) == 3
                        gray = RGB2GRY(currentImg, 1);
                        figure;
                        HIST(gray);
                        title('Histogram');
                        % Just show original image in processed view
                        processedImg = currentImg;
                    else
                        figure;
                        HIST(currentImg);
                        title('Histogram');
                        processedImg = currentImg;
                    end
                    
                case 'Histogram Equalization'
                    % Check if grayscale is needed
                    if size(currentImg, 3) == 3
                        gray = RGB2GRY(currentImg, 1);
                        processedImg = histEqualize(gray);
                    else
                        processedImg = histEqualize(currentImg);
                    end
                    
                case 'Ideal Low/High Pass'
                    D0 = str2double(get(paramControls.D0, 'String'));
                    index = get(paramControls.index, 'Value') - 1; % 0 for low pass, 1 for high pass
                    
                    % Convert to gray if needed
                    if size(currentImg, 3) == 3
                        gray = RGB2GRY(currentImg, 1);
                        processedImg = ILHpass(gray, D0, index);
                    else
                        processedImg = ILHpass(currentImg, D0, index);
                    end
                    
                case 'Inverse Fourier'
                    % Check if we have a frequency domain image
                    processedImg = inverseFourier(currentImg);
                    
                case 'Line Detection'
                    dirVal = get(paramControls.direction, 'Value');
                    directions = {'H', 'V', 'DL', 'DR'};
                    direction = directions{dirVal};
                    processedImg = lineDetect(currentImg, direction);
                    
                case 'Line Sharpening'
                    dirVal = get(paramControls.direction, 'Value');
                    directions = {'H', 'V', 'DL', 'DR'};
                    direction = directions{dirVal};
                    processedImg = lineSharpening(currentImg, direction);
                    
                case 'Log Transform'
                    % Check if grayscale is needed
                    if size(currentImg, 3) == 3
                        gray = RGB2GRY(currentImg, 1);
                        processedImg = logTrans(gray);
                    else
                        processedImg = logTrans(currentImg);
                    end
                    
                case 'Max Filter'
                    processedImg = maxFltr(currentImg);
                    
                case 'Mean Filter'
                    processedImg = meanFltr(currentImg);
                    
                case 'Median Filter'
                    processedImg = medianFltr(currentImg);
                    
                case 'Midpoint Filter'
                    processedImg = midpointFltr(currentImg);
                    
                case 'Min Filter'
                    processedImg = minFltr(currentImg);
                    
                case 'Negative'
                    processedImg = negative(currentImg);
                    
                case 'Point Sharpening'
                    processedImg = pointSharpening(currentImg);
                    
                case 'Point Detection'
                    processedImg = PtsDetect(currentImg);
                    
                case 'RGB to Binary'
                    if size(currentImg, 3) == 3
                        processedImg = RGB2BIN(currentImg, get(paramControls.index, 'Value'));
                    else
                        warndlg('Input is not RGB image', 'Warning');
                        return;
                    end
                    
                case 'RGB to Gray'
                    if size(currentImg, 3) == 3
                        processedImg = RGB2GRY(currentImg, get(paramControls.index, 'Value'));
                    else
                        warndlg('Input is not RGB image', 'Warning');
                        return;
                    end
                    
                case 'Rayleigh Noise'
                    a = str2double(get(paramControls.a, 'String'));
                    b = str2double(get(paramControls.b, 'String'));
                    processedImg = rlNoise(currentImg, a, b);
                    
                case 'Roberts Mask'
                    processedImg = robertsMsk(currentImg);
                    
                case 'Salt & Pepper Noise'
                    ps = str2double(get(paramControls.ps, 'String'));
                    pp = str2double(get(paramControls.pp, 'String'));
                    processedImg = sltNpepr(currentImg, ps, pp);
                    
                case 'Sobel Mask'
                    dirVal = get(paramControls.direction, 'Value');
                    directions = {'horizontal', 'vertical'};
                    direction = directions{dirVal};
                    processedImg = sobelMsk(currentImg, direction);
                    
                case 'Weighted Filter'
                    processedImg = weightFltr(currentImg);
            end
            
            % Display processed image
            axes(processedAxes);
            imshow(processedImg);
            title(['Processed with ' currentFilter]);
            
            % Update current image to processed image
            currentImg = processedImg;
            
        catch e
            errordlg(['Error applying filter: ' e.message], 'Error');
        end
    end
    
    function saveImage(~, ~)
        if isempty(processedImg)
            return;
        end
        
        [filename, pathname] = uiputfile({'*.jpg', 'JPEG Image (*.jpg)'; ...
            '*.png', 'PNG Image (*.png)'; ...
            '*.bmp', 'BMP Image (*.bmp)'; ...
            '*.tif', 'TIFF Image (*.tif)'}, ...
            'Save Processed Image As');
        
        if filename ~= 0
            try
                imwrite(processedImg, fullfile(pathname, filename));
                msgbox('Image saved successfully!', 'Success');
            catch e
                errordlg(['Error saving image: ' e.message], 'Error');
            end
        end
    end
    
    function resetImage(~, ~)
        if isempty(originalImg)
            return;
        end
        
        % Reset to original image
        currentImg = originalImg;
        
        % Display original in processed view
        axes(processedAxes);
        imshow(originalImg);
        title('Reset to Original');
    end
end

% Import all the filter functions
function adjusted = adjustBrightness(img, delta)
    [H, W, L] = size(img);
    adjusted = zeros(H, W, L, 'uint8');
    
    for c = 1:L
        for i = 1:H
            for j = 1:W
                new_val = double(img(i,j,c)) + delta;
                % Clamp to [0, 255]
                adjusted(i,j,c) = uint8(max(0, min(255, new_val)));
            end
        end
    end
end

function filteredImage = AVGfltr(grayImage)
    [rows, cols] = size(grayImage);
    filteredImage = zeros(rows, cols, 'uint8');
    
    % Manually pad the image (replicate borders)
    paddedImage = padarray(grayImage, [1 1], 'replicate');
    
    % Apply 3x3 kernel
    kernel = ones(3,3)/9;
    for i = 1:rows
        for j = 1:cols
            patch = double(paddedImage(i:i+2, j:j+2));
            filteredImage(i,j) = sum(patch(:) .* kernel(:));
        end
    end
end

function filtered = BWF(I, D0, n, index)
    [H, W, L] = size(I);
    filter = zeros(H, W, L);
    
    % Create Butterworth filter
    for j = 1:H
        for k = 1:W
            D = sqrt((j - H/2)^2 + (k - W/2)^2); % Distance from center
            butterworth = 1 / (1 + (D / D0)^(2 * n)); % Butterworth LPF formula
            filter(j, k, :) = butterworth;
        end
    end
end