function gui()
    ensureImagePackage();

    projectRoot = fileparts(mfilename('fullpath'));
    addpath(genpath(fileparts(projectRoot)));

    bgColor = [0.15 0.15 0.15];
    panelColor = [0.22 0.22 0.22];
    textColor = [0.92 0.92 0.92];
    accentBlue = [0.12 0.45 0.72];
    accentGreen = [0.2 0.62 0.32];
    accentRed = [0.72 0.25 0.25];

    state.original = [];
    state.current = [];
    state.processed = [];
    state.currentFilter = 'Select a filter...';
    state.paramControls = struct();

    fig = figure('Name', 'Image Processing Tool', 'NumberTitle', 'off', ...
        'MenuBar', 'none', 'ToolBar', 'none', 'Resize', 'on', ...
        'Color', bgColor, 'Position', [100 100 1200 700], ...
        'CloseRequestFcn', @closeApp);

    uicontrol(fig, 'Style', 'text', 'Units', 'normalized', ...
        'Position', [0.02 0.95 0.35 0.035], 'String', 'Unified Image Processing Studio', ...
        'BackgroundColor', bgColor, 'ForegroundColor', textColor, ...
        'HorizontalAlignment', 'left', 'FontSize', 13, 'FontWeight', 'bold');

    statusBar = uicontrol(fig, 'Style', 'text', 'Units', 'normalized', ...
        'Position', [0.0 0.0 1 0.04], 'String', ' Ready', ...
        'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', textColor, ...
        'HorizontalAlignment', 'left', 'FontSize', 10);

    controlPanel = uipanel(fig, 'Title', 'Controls', 'Units', 'normalized', ...
        'Position', [0.69 0.06 0.29 0.88], 'BackgroundColor', panelColor, ...
        'ForegroundColor', textColor, 'FontSize', 11);

    workspacePanel = uipanel(fig, 'Title', 'Workspace', 'Units', 'normalized', ...
        'Position', [0.02 0.06 0.65 0.88], 'BackgroundColor', panelColor, ...
        'ForegroundColor', textColor, 'FontSize', 11);

    axOriginal = axes('Parent', workspacePanel, 'Units', 'normalized', 'Position', [0.05 0.52 0.9 0.43]);
    title(axOriginal, 'Original Image', 'Color', textColor);
    set(axOriginal, 'XColor', 'none', 'YColor', 'none');

    axProcessed = axes('Parent', workspacePanel, 'Units', 'normalized', 'Position', [0.05 0.05 0.9 0.43]);
    title(axProcessed, 'Processed Image', 'Color', textColor);
    set(axProcessed, 'XColor', 'none', 'YColor', 'none');

    uicontrol(controlPanel, 'Style', 'pushbutton', 'String', 'Load New Image', ...
        'Units', 'normalized', 'Position', [0.1 0.9 0.8 0.06], 'Callback', @loadImage, ...
        'BackgroundColor', accentBlue, 'ForegroundColor', 'white', 'FontSize', 10);

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

    filterDropdown = uicontrol(controlPanel, 'Style', 'popupmenu', 'String', filterList, ...
        'Units', 'normalized', 'Position', [0.1 0.82 0.8 0.05], ...
        'Callback', @filterSelected, 'BackgroundColor', [0.3 0.3 0.3], ...
        'ForegroundColor', 'white');

    paramPanel = uipanel(controlPanel, 'Title', 'Parameters', 'Units', 'normalized', ...
        'Position', [0.05 0.36 0.9 0.42], 'Visible', 'off', ...
        'BackgroundColor', panelColor, 'ForegroundColor', textColor);

    applyBtn = uicontrol(controlPanel, 'Style', 'pushbutton', 'String', 'Apply', ...
        'Units', 'normalized', 'Position', [0.1 0.25 0.8 0.08], ...
        'Callback', @applyFilter, 'Enable', 'off', 'BackgroundColor', accentGreen, ...
        'ForegroundColor', 'white', 'FontSize', 11, 'FontWeight', 'bold');

    uicontrol(controlPanel, 'Style', 'pushbutton', 'String', 'Reset Image', ...
        'Units', 'normalized', 'Position', [0.1 0.15 0.37 0.06], 'Callback', @resetImage, ...
        'BackgroundColor', [0.4 0.4 0.4], 'ForegroundColor', 'white');

    uicontrol(controlPanel, 'Style', 'pushbutton', 'String', 'Save', ...
        'Units', 'normalized', 'Position', [0.53 0.15 0.37 0.06], 'Callback', @saveImage, ...
        'BackgroundColor', accentRed, 'ForegroundColor', 'white');

    function loadImage(~, ~)
        [file, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff', 'Image Files'}, ...
            'Select Image');
        if isequal(file, 0)
            return;
        end

        imageData = imread(fullfile(path, file));
        state.original = imageData;
        state.current = imageData;
        state.processed = imageData;
        state.currentFilter = 'Select a filter...';

        set(filterDropdown, 'Value', 1);
        set(paramPanel, 'Visible', 'off');
        clearParameters();
        set(applyBtn, 'Enable', 'off');

        showImage(axOriginal, imageData, 'Original Image');
        showImage(axProcessed, imageData, 'Processed Image');
        updateStatus('Image loaded successfully.');
    end

    function filterSelected(src, ~)
        clearParameters();

        idx = get(src, 'Value');
        if idx == 1 || isempty(state.original)
            state.currentFilter = 'Select a filter...';
            set(paramPanel, 'Visible', 'off');
            set(applyBtn, 'Enable', 'off');
            return;
        end

        state.currentFilter = filterList{idx};
        buildParameters(state.currentFilter);
        set(paramPanel, 'Visible', 'on');
        set(applyBtn, 'Enable', 'on');
    end

    function buildParameters(filterName)
        switch filterName
            case 'Adjust Brightness'
                state.paramControls.delta = labeledEdit('Brightness Delta:', '50', 0.72);
            case 'Butterworth Filter'
                state.paramControls.D0 = labeledEdit('Cutoff Frequency (D0):', '30', 0.72);
                state.paramControls.n = labeledEdit('Order (n):', '2', 0.58);
                state.paramControls.index = labeledPopup('Filter Type:', {'Low Pass', 'High Pass'}, 0.44);
            case 'Correlation'
                state.paramControls.kernelType = labeledPopup('Kernel Type:', {'Average', 'Sobel-X', 'Sobel-Y', 'Laplacian'}, 0.58);
            case 'Exponential Noise'
                state.paramControls.a = labeledEdit('Parameter a:', '0.1', 0.72);
                state.paramControls.b = labeledEdit('Parameter b:', '1', 0.58);
            case 'Gaussian Filter'
                state.paramControls.D0 = labeledEdit('Cutoff Frequency (D0):', '30', 0.72);
                state.paramControls.index = labeledPopup('Filter Type:', {'Low Pass', 'High Pass'}, 0.58);
            case 'Gamma Noise'
                state.paramControls.a = labeledEdit('Parameter a:', '2', 0.72);
                state.paramControls.b = labeledEdit('Parameter b:', '2', 0.58);
            case 'Gray to Binary'
                state.paramControls.index = labeledPopup('Threshold Method:', {'Fixed (128)', 'Mean', 'Median'}, 0.58);
            case 'Gaussian Noise'
                state.paramControls.v = labeledEdit('Variance:', '20', 0.72);
                state.paramControls.m = labeledEdit('Mean:', '0', 0.58);
            case 'Ideal Low/High Pass'
                state.paramControls.D0 = labeledEdit('Cutoff Frequency (D0):', '30', 0.72);
                state.paramControls.index = labeledPopup('Filter Type:', {'Low Pass', 'High Pass'}, 0.58);
            case 'Line Detection'
                state.paramControls.direction = labeledPopup('Direction:', {'Horizontal (H)', 'Vertical (V)', 'Diagonal Left (DL)', 'Diagonal Right (DR)'}, 0.58);
            case 'Line Sharpening'
                state.paramControls.direction = labeledPopup('Direction:', {'Horizontal (H)', 'Vertical (V)', 'Diagonal Left (DL)', 'Diagonal Right (DR)'}, 0.58);
            case 'Rayleigh Noise'
                state.paramControls.a = labeledEdit('Parameter a:', '30', 0.72);
                state.paramControls.b = labeledEdit('Parameter b:', '2', 0.58);
            case 'RGB to Binary'
                state.paramControls.index = labeledPopup('Conversion Method:', {'Average', 'Red Channel', 'Green Channel', 'Blue Channel', 'Weighted'}, 0.58);
            case 'RGB to Gray'
                state.paramControls.index = labeledPopup('Conversion Method:', {'Average', 'Red Channel', 'Green Channel', 'Blue Channel', 'Weighted'}, 0.58);
            case 'Salt & Pepper Noise'
                state.paramControls.ps = labeledEdit('Salt Probability:', '0.01', 0.72);
                state.paramControls.pp = labeledEdit('Pepper Probability:', '0.01', 0.58);
            case 'Sobel Mask'
                state.paramControls.direction = labeledPopup('Direction:', {'Horizontal', 'Vertical'}, 0.58);
        end
    end

    function control = labeledEdit(labelText, defaultValue, yPos)
        uicontrol(paramPanel, 'Style', 'text', 'String', labelText, ...
            'Units', 'normalized', 'Position', [0.06 yPos 0.48 0.08], ...
            'HorizontalAlignment', 'left', 'BackgroundColor', panelColor, ...
            'ForegroundColor', textColor);
        control = uicontrol(paramPanel, 'Style', 'edit', 'String', defaultValue, ...
            'Units', 'normalized', 'Position', [0.58 yPos 0.34 0.09], ...
            'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
    end

    function control = labeledPopup(labelText, options, yPos)
        uicontrol(paramPanel, 'Style', 'text', 'String', labelText, ...
            'Units', 'normalized', 'Position', [0.06 yPos 0.48 0.08], ...
            'HorizontalAlignment', 'left', 'BackgroundColor', panelColor, ...
            'ForegroundColor', textColor);
        control = uicontrol(paramPanel, 'Style', 'popupmenu', 'String', options, ...
            'Units', 'normalized', 'Position', [0.58 yPos 0.34 0.09], ...
            'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');
    end

    function applyFilter(~, ~)
        if isempty(state.current) || strcmp(state.currentFilter, 'Select a filter...')
            updateStatus('Load an image and select a filter first.');
            return;
        end

        updateStatus('Processing...');
        drawnow;

        try
            inputImage = state.current;
            selected = state.currentFilter;

            switch selected
                case 'Adjust Brightness'
                    delta = str2double(get(state.paramControls.delta, 'String'));
                    processed = adjustBrightness(inputImage, delta);
                case 'Average Filter'
                    processed = applyPerChannel(inputImage, @AVGfltr);
                case 'Butterworth Filter'
                    D0 = str2double(get(state.paramControls.D0, 'String'));
                    n = str2double(get(state.paramControls.n, 'String'));
                    index = get(state.paramControls.index, 'Value') - 1;
                    processed = applyPerChannel(inputImage, @(img) BWF(img, D0, n, index));
                case 'Contrast Stretch'
                    processed = applyOnGrayOrGrayLike(inputImage, @contrastStretch);
                case 'Correlation'
                    kernelType = get(state.paramControls.kernelType, 'Value');
                    kernels = {ones(3, 3) / 9, [-1 0 1; -2 0 2; -1 0 1], [-1 -2 -1; 0 0 0; 1 2 1], [-1 -1 -1; -1 8 -1; -1 -1 -1]};
                    processed = correlation(inputImage, kernels{kernelType});
                case 'Exponential Noise'
                    a = str2double(get(state.paramControls.a, 'String'));
                    b = str2double(get(state.paramControls.b, 'String'));
                    processed = expNoise(inputImage, a, b);
                case 'Fourier Transform'
                    processed = fourierTransform(inputImage);
                case 'Gaussian Filter'
                    D0 = str2double(get(state.paramControls.D0, 'String'));
                    index = get(state.paramControls.index, 'Value') - 1;
                    processed = applyPerChannel(inputImage, @(img) GF(img, D0, index));
                case 'Gamma Noise'
                    a = str2double(get(state.paramControls.a, 'String'));
                    b = str2double(get(state.paramControls.b, 'String'));
                    processed = gmaNoise(inputImage, a, b);
                case 'Gray to Binary'
                    processed = GRY2BIN(toGray(inputImage), get(state.paramControls.index, 'Value'));
                case 'Gaussian Noise'
                    v = str2double(get(state.paramControls.v, 'String'));
                    m = str2double(get(state.paramControls.m, 'String'));
                    processed = gussNoise(inputImage, v, m);
                case 'Histogram'
                    if ndims(inputImage) == 3 && size(inputImage, 3) == 3
                        histogramSource = RGB2GRY(inputImage, 1);
                    else
                        histogramSource = inputImage;
                    end
                    figure('Name', 'Histogram', 'NumberTitle', 'off');
                    HIST(histogramSource);
                    title('Histogram');
                    processed = inputImage;
                case 'Histogram Equalization'
                    processed = applyOnGrayOrGrayLike(inputImage, @histEqualize);
                case 'Ideal Low/High Pass'
                    D0 = str2double(get(state.paramControls.D0, 'String'));
                    index = get(state.paramControls.index, 'Value') - 1;
                    processed = applyPerChannel(inputImage, @(img) ILHpass(img, D0, index));
                case 'Inverse Fourier'
                    processed = inverseFourier(inputImage);
                case 'Line Detection'
                    directions = {'H', 'V', 'DL', 'DR'};
                    direction = directions{get(state.paramControls.direction, 'Value')};
                    processed = lineDetect(inputImage, direction);
                case 'Line Sharpening'
                    directions = {'H', 'V', 'DL', 'DR'};
                    direction = directions{get(state.paramControls.direction, 'Value')};
                    processed = lineSharpening(inputImage, direction);
                case 'Log Transform'
                    processed = applyOnGrayOrGrayLike(inputImage, @logTrans);
                case 'Max Filter'
                    processed = maxFltr(inputImage);
                case 'Mean Filter'
                    processed = meanFltr(inputImage);
                case 'Median Filter'
                    processed = medianFltr(inputImage);
                case 'Midpoint Filter'
                    processed = midpointFltr(inputImage);
                case 'Min Filter'
                    processed = minFltr(inputImage);
                case 'Negative'
                    processed = negative(inputImage);
                case 'Point Sharpening'
                    processed = pointSharpening(inputImage);
                case 'Point Detection'
                    processed = PtsDetect(inputImage);
                case 'RGB to Binary'
                    processed = RGB2BIN(inputImage, get(state.paramControls.index, 'Value'));
                case 'RGB to Gray'
                    processed = RGB2GRY(inputImage, get(state.paramControls.index, 'Value'));
                case 'Rayleigh Noise'
                    a = str2double(get(state.paramControls.a, 'String'));
                    b = str2double(get(state.paramControls.b, 'String'));
                    processed = rlNoise(inputImage, a, b);
                case 'Roberts Mask'
                    processed = robertsMsk(inputImage);
                case 'Salt & Pepper Noise'
                    ps = str2double(get(state.paramControls.ps, 'String'));
                    pp = str2double(get(state.paramControls.pp, 'String'));
                    processed = sltNpepr(inputImage, ps, pp);
                case 'Sobel Mask'
                    directions = {'horizontal', 'vertical'};
                    processed = sobelMsk(inputImage, directions{get(state.paramControls.direction, 'Value')});
                case 'Weighted Filter'
                    processed = weightFltr(inputImage);
                otherwise
                    updateStatus('Unsupported filter selected.');
                    return;
            end

            state.processed = processed;
            state.current = processed;

            showImage(axProcessed, processed, ['Processed: ' selected]);
            updateStatus(['Applied: ' selected]);
        catch err
            updateStatus(['Error: ' err.message]);
            errordlg(err.message, 'Processing Error');
        end
    end

    function output = applyPerChannel(imageData, fn)
        if ndims(imageData) == 2 || size(imageData, 3) == 1
            output = fn(imageData);
            return;
        end

        output = zeros(size(imageData), 'like', imageData);
        for channelIndex = 1:size(imageData, 3)
            output(:, :, channelIndex) = fn(imageData(:, :, channelIndex));
        end
    end

    function output = applyOnGrayOrGrayLike(imageData, fn)
        if ndims(imageData) == 3 && size(imageData, 3) == 3
            output = fn(RGB2GRY(imageData, 1));
        else
            output = fn(imageData);
        end
    end

    function grayImage = toGray(imageData)
        if ndims(imageData) == 3 && size(imageData, 3) == 3
            grayImage = RGB2GRY(imageData, 1);
        else
            grayImage = imageData;
        end
    end

    function saveImage(~, ~)
        if isempty(state.processed)
            updateStatus('Nothing to save.');
            return;
        end

        [file, path] = uiputfile({'*.jpg'; '*.png'; '*.bmp'; '*.tif'}, 'Save As');
        if isequal(file, 0)
            return;
        end

        imwrite(state.processed, fullfile(path, file));
        updateStatus(['Saved: ' file]);
    end

    function resetImage(~, ~)
        if isempty(state.original)
            return;
        end

        state.current = state.original;
        state.processed = state.original;
        showImage(axProcessed, state.original, 'Processed Image');
        updateStatus('Image reset to original.');
    end

    function clearParameters()
        state.paramControls = struct();
        children = get(paramPanel, 'Children');
        if ~isempty(children)
            delete(children);
        end
    end

    function showImage(axHandle, imageData, titleText)
        axes(axHandle);
        cla(axHandle);
        imshow(imageData);
        axis image off;
        title(titleText, 'Color', textColor);
        drawnow;
    end

    function updateStatus(message)
        set(statusBar, 'String', [' ' message]);
        drawnow;
    end

    function closeApp(~, ~)
        delete(fig);
    end

    function ensureImagePackage()
        if exist('OCTAVE_VERSION', 'builtin') ~= 0
            try
                pkg('load', 'image');
            catch
            end
        end
    end
end