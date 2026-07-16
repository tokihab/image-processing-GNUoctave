function gui_unified()
    % Unified Image Processing GUI
    % Combines the best features of gui.m and guii.m:
    % - Complete filter coverage from gui.m
    % - Modern dark theme and resizable UI from guii.m
    % - Dynamic parameter panels from gui.m
    % - External function calls from guii.m
    % - Three-state image management
    
    % Main variables
    originalImg = [];
    currentImg = [];
    processedImg = [];
    currentFilter = '';

    % Modern Color Palette (Dark Theme)
    bgColor = [0.15 0.15 0.15];
    panelColor = [0.2 0.2 0.2];
    textColor = [0.9 0.9 0.9];
    btnBlue = [0.1 0.45 0.7];
    btnGreen = [0.2 0.6 0.3];
    btnRed = [0.7 0.2 0.2];

    % Create main figure
    fig = figure('Name', 'Vision Studio - Unified Image Processing', ...
        'NumberTitle', 'off', 'MenuBar', 'none', 'Resize', 'on', ...
        'Position', [100 100 1200 700], 'Color', bgColor);

    % Status bar
    statusBar = uicontrol(fig, 'Style', 'text', ...
        'Units','normalized', 'Position', [0.0 0.0 1 0.04], ...
        'String', ' Ready', 'HorizontalAlignment', 'left', ...
        'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', textColor, 'FontSize', 10);

    % Image panels (Left Side)
    originalImgPanel = uipanel(fig, 'Title', 'Original Image', ...
        'Units','normalized', 'Position', [0.02 0.52 0.46 0.44], ...
        'BackgroundColor', panelColor, 'ForegroundColor', textColor, 'FontSize', 11);

    axOriginal = axes('Parent', originalImgPanel, 'Units','normalized', 'Position', [0.05 0.05 0.9 0.9]);
    title(axOriginal, 'Original Image', 'Color', textColor);
    set(axOriginal, 'XColor', 'none', 'YColor', 'none');

    processedImgPanel = uipanel(fig, 'Title', 'Processed Image', ...
        'Units','normalized', 'Position', [0.50 0.52 0.46 0.44], ...
        'BackgroundColor', panelColor, 'ForegroundColor', textColor, 'FontSize', 11);

    axProcessed = axes('Parent', processedImgPanel, 'Units','normalized', 'Position', [0.05 0.05 0.9 0.9]);
    title(axProcessed, 'Processed Image', 'Color', textColor);
    set(axProcessed, 'XColor', 'none', 'YColor', 'none');

    % Control Panel (Right Side)
    controlPanel = uipanel(fig, 'Title', 'Controls', ...
        'Units','normalized', 'Position', [0.02 0.06 0.46 0.44], ...
        'BackgroundColor', panelColor, 'ForegroundColor', textColor, 'FontSize', 11);

    % Load button
    uicontrol(controlPanel, 'Style', 'pushbutton', 'String', 'Load Image', ...
        'Units','normalized', 'Position', [0.1 0.88 0.8 0.08], ...
        'Callback', @loadImage, 'BackgroundColor', btnBlue, 'ForegroundColor', 'white', 'FontSize', 10);

    % Filter dropdown
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

    filterDropdown = uicontrol(controlPanel, 'Style', 'popupmenu', ...
        'String', filterList, 'Units','normalized', 'Position', [0.1 0.78 0.8 0.06], ...
        'Callback', @filterSelected, 'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');

    % Parameter panel (initially hidden)
    paramPanel = uipanel(controlPanel, 'Title', 'Parameters', ...
        'Units','normalized', 'Position', [0.05 0.15 0.9 0.58], ...
        'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor, 'Visible', 'off');

    % Parameter controls (created dynamically based on filter)
    paramControls = struct();

    % Action buttons
    uicontrol(controlPanel, 'Style', 'pushbutton', 'String', 'Apply Filter', ...
        'Units','normalized', 'Position', [0.1 0.08 0.38 0.06], ...
        'Callback', @applyFilter, 'BackgroundColor', btnGreen, 'ForegroundColor', 'white', 'FontSize', 10, 'Enable', 'off');

    uicontrol(controlPanel, 'Style', 'pushbutton', 'String', 'Reset Image', ...
        'Units','normalized', 'Position', [0.52 0.08 0.38 0.06], ...
        'Callback', @resetImage, 'BackgroundColor', [0.4 0.4 0.4], 'ForegroundColor', 'white', 'Enable', 'off');

    uicontrol(controlPanel, 'Style', 'pushbutton', 'String', 'Save Image', ...
        'Units','normalized', 'Position', [0.1 0.01 0.8 0.06], ...
        'Callback', @saveImage, 'BackgroundColor', btnRed, 'ForegroundColor', 'white', 'Enable', 'off');

    % Callback functions
    function loadImage(~, ~)
        [filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif', 'Image Files'}, 'Select an Image');
        if filename ~= 0
            % Load the image
            originalImg = imread(fullfile(pathname, filename));
            currentImg = originalImg;
            processedImg = originalImg;
            
            % Display original image
            axes(axOriginal);
            imshow(originalImg);
            title('Original Image', 'Color', textColor);
            
            % Display processed image (initially same as original)
            axes(axProcessed);
            imshow(originalImg);
            title('Processed Image (None Applied)', 'Color', textColor);
            
            % Enable buttons
            set(findobj(controlPanel, 'String', 'Apply Filter'), 'Enable', 'on');
            set(findobj(controlPanel, 'String', 'Reset Image'), 'Enable', 'on');
            set(findobj(controlPanel, 'String', 'Save Image'), 'Enable', 'on');
            
            updateStatus('Image loaded successfully.');
        end
    end

    function filterSelected(src, ~)
        % Get selected filter
        idx = src.Value;
        if idx == 1
            paramPanel.Visible = 'off';
            currentFilter = '';
            return;
        end
        
        currentFilter = filterList{idx};
        
        % Clear previous parameter controls
        children = get(paramPanel, 'Children');
        if ~isempty(children)
            delete(children);
        end
        
        paramControls = struct(); % Clear previous controls
        
        % Create parameter controls based on selected filter
        switch currentFilter
            case 'Adjust Brightness'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Brightness Delta:', ...
                    'Units','normalized', 'Position', [0.1 0.7 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.delta = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '50', 'Units','normalized', 'Position', [0.5 0.7 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Butterworth Filter'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Cutoff Frequency (D0):', ...
                    'Units','normalized', 'Position', [0.1 0.7 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.D0 = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '30', 'Units','normalized', 'Position', [0.5 0.7 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Order (n):', ...
                    'Units','normalized', 'Position', [0.1 0.5 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.n = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '2', 'Units','normalized', 'Position', [0.5 0.5 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Filter Type:', ...
                    'Units','normalized', 'Position', [0.1 0.3 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.index = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Low Pass', 'High Pass'}, 'Units','normalized', 'Position', [0.5 0.3 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Correlation'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Kernel Type:', ...
                    'Units','normalized', 'Position', [0.1 0.6 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.kernelType = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Average', 'Sobel-X', 'Sobel-Y', 'Laplacian'}, ...
                    'Units','normalized', 'Position', [0.5 0.6 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Exponential Noise'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Parameter a:', ...
                    'Units','normalized', 'Position', [0.1 0.7 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.a = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '0.1', 'Units','normalized', 'Position', [0.5 0.7 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Parameter b:', ...
                    'Units','normalized', 'Position', [0.1 0.5 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.b = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '1', 'Units','normalized', 'Position', [0.5 0.5 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Gaussian Filter'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Cutoff Frequency (D0):', ...
                    'Units','normalized', 'Position', [0.1 0.7 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.D0 = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '30', 'Units','normalized', 'Position', [0.5 0.7 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Filter Type:', ...
                    'Units','normalized', 'Position', [0.1 0.5 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.index = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Low Pass', 'High Pass'}, 'Units','normalized', 'Position', [0.5 0.5 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Gamma Noise'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Parameter a:', ...
                    'Units','normalized', 'Position', [0.1 0.7 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.a = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '2', 'Units','normalized', 'Position', [0.5 0.7 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Parameter b:', ...
                    'Units','normalized', 'Position', [0.1 0.5 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.b = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '2', 'Units','normalized', 'Position', [0.5 0.5 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Gray to Binary'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Threshold Method:', ...
                    'Units','normalized', 'Position', [0.1 0.6 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.index = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Fixed (128)', 'Mean', 'Median'}, 'Units','normalized', 'Position', [0.5 0.6 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Gaussian Noise'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Variance:', ...
                    'Units','normalized', 'Position', [0.1 0.7 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.v = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '20', 'Units','normalized', 'Position', [0.5 0.7 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Mean:', ...
                    'Units','normalized', 'Position', [0.1 0.5 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.m = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '0', 'Units','normalized', 'Position', [0.5 0.5 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Ideal Low/High Pass'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Cutoff Frequency (D0):', ...
                    'Units','normalized', 'Position', [0.1 0.7 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.D0 = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '30', 'Units','normalized', 'Position', [0.5 0.7 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Filter Type:', ...
                    'Units','normalized', 'Position', [0.1 0.5 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.index = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Low Pass', 'High Pass'}, 'Units','normalized', 'Position', [0.5 0.5 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Line Detection'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Direction:', ...
                    'Units','normalized', 'Position', [0.1 0.6 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.direction = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Horizontal (H)', 'Vertical (V)', 'Diagonal Left (DL)', 'Diagonal Right (DR)'}, ...
                    'Units','normalized', 'Position', [0.5 0.6 0.4 0.15], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Line Sharpening'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Direction:', ...
                    'Units','normalized', 'Position', [0.1 0.6 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.direction = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Horizontal (H)', 'Vertical (V)', 'Diagonal Left (DL)', 'Diagonal Right (DR)'}, ...
                    'Units','normalized', 'Position', [0.5 0.6 0.4 0.15], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Rayleigh Noise'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Parameter a:', ...
                    'Units','normalized', 'Position', [0.1 0.7 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.a = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '30', 'Units','normalized', 'Position', [0.5 0.7 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Parameter b:', ...
                    'Units','normalized', 'Position', [0.1 0.5 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.b = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '2', 'Units','normalized', 'Position', [0.5 0.5 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'RGB to Binary'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Conversion Method:', ...
                    'Units','normalized', 'Position', [0.1 0.6 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.index = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Average', 'Red Channel', 'Green Channel', 'Blue Channel', 'Weighted'}, ...
                    'Units','normalized', 'Position', [0.5 0.6 0.4 0.15], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'RGB to Gray'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Conversion Method:', ...
                    'Units','normalized', 'Position', [0.1 0.6 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.index = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Average', 'Red Channel', 'Green Channel', 'Blue Channel', 'Weighted'}, ...
                    'Units','normalized', 'Position', [0.5 0.6 0.4 0.15], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Salt & Pepper Noise'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Salt Probability:', ...
                    'Units','normalized', 'Position', [0.1 0.7 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.ps = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '0.01', 'Units','normalized', 'Position', [0.5 0.7 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Pepper Probability:', ...
                    'Units','normalized', 'Position', [0.1 0.5 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.pp = uicontrol('Parent', paramPanel, 'Style', 'edit', ...
                    'String', '0.01', 'Units','normalized', 'Position', [0.5 0.5 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
                
            case 'Sobel Mask'
                uicontrol('Parent', paramPanel, 'Style', 'text', 'String', 'Direction:', ...
                    'Units','normalized', 'Position', [0.1 0.6 0.4 0.1], ...
                    'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);
                paramControls.direction = uicontrol('Parent', paramPanel, 'Style', 'popupmenu', ...
                    'String', {'Horizontal', 'Vertical'}, 'Units','normalized', 'Position', [0.5 0.6 0.4 0.1], ...
                    'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
        end
        
        paramPanel.Visible = 'on';
    end

    function applyFilter(~, ~)
        if isempty(currentImg) || strcmp(currentFilter, '') || strcmp(currentFilter, 'Select a filter...')
            updateStatus('Error: No image loaded or filter selected.');
            return;
        end
        
        updateStatus(['Processing ' currentFilter '...']);
        drawnow;
        
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
                        errordlg('Input is not RGB image', 'Error');
                        return;
                    end
                    
                case 'RGB to Gray'
                    if size(currentImg, 3) == 3
                        processedImg = RGB2GRY(currentImg, get(paramControls.index, 'Value'));
                    else
                        errordlg('Input is not RGB image', 'Error');
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
            axes(axProcessed);
            imshow(processedImg);
            title(['Processed with ' currentFilter], 'Color', textColor);
            
            % Update current image to processed image
            currentImg = processedImg;
            
            updateStatus(['Applied: ' currentFilter]);
            
        catch e
            updateStatus(['Error: ' e.message]);
        end
    end

    function saveImage(~, ~)
        if isempty(processedImg)
            updateStatus('Error: No processed image to save.');
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
                updateStatus(['Saved: ' filename]);
            catch e
                updateStatus(['Error saving: ' e.message]);
            end
        end
    end

    function resetImage(~, ~)
        if isempty(originalImg)
            updateStatus('Error: No original image to reset to.');
            return;
        end
        
        % Reset to original image
        currentImg = originalImg;
        processedImg = originalImg;
        
        % Display original in processed view
        axes(axProcessed);
        imshow(originalImg);
        title('Reset to Original', 'Color', textColor);
        
        updateStatus('Image reset to original.');
    end

    function updateStatus(message)
        set(statusBar, 'String', [' ' message]);
        drawnow;
    end
end
