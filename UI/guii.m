function guii()
    % Main variables
    img = [];
    processedImg = [];

    % Modern Color Palette (Dark Theme)
    bgColor = [0.15 0.15 0.15];
    panelColor = [0.2 0.2 0.2];
    textColor = [0.9 0.9 0.9];
    btnBlue = [0.1 0.45 0.7];
    btnGreen = [0.2 0.6 0.3];
    btnRed = [0.7 0.2 0.2];

    % Create main figure
    fig = figure('Name', 'Vision Studio - Image Processing', 'NumberTitle', 'off', ...
        'Position', [100 100 1200 700], 'Color', bgColor);

    % Status bar
    statusBar = uicontrol(fig, 'Style', 'text', ...
        'Units','normalized', 'Position', [0.0 0.0 1 0.04], ...
        'String', ' Ready', 'HorizontalAlignment', 'left', ...
        'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', textColor, 'FontSize', 10);

    % Image panels (Left Side)
    imgPanel = uipanel(fig, 'Title', 'Workspace', ...
        'Units','normalized', 'Position', [0.02 0.06 0.65 0.90], ...
        'BackgroundColor', panelColor, 'ForegroundColor', textColor, 'FontSize', 11);

    axOriginal = axes('Parent', imgPanel, 'Units','normalized', 'Position', [0.05 0.52 0.90 0.43]);
    title(axOriginal, 'Original Image', 'Color', textColor);
    set(axOriginal, 'XColor', 'none', 'YColor', 'none'); % Hide ugly axis lines

    axProcessed = axes('Parent', imgPanel, 'Units','normalized', 'Position', [0.05 0.05 0.90 0.43]);
    title(axProcessed, 'Processed Image', 'Color', textColor);
    set(axProcessed, 'XColor', 'none', 'YColor', 'none');

    % Control Panel (Right Side)
    controlPanel = uipanel(fig, 'Title', 'Controls', ...
        'Units','normalized', 'Position', [0.69 0.06 0.29 0.90], ...
        'BackgroundColor', panelColor, 'ForegroundColor', textColor, 'FontSize', 11);

    % Load button
    uicontrol(controlPanel, 'Style', 'pushbutton', 'String', 'Load New Image', ...
        'Units','normalized', 'Position', [0.1 0.88 0.8 0.06], ...
        'Callback', @loadImage, 'BackgroundColor', btnBlue, 'ForegroundColor', 'white', 'FontSize', 10);

    % Method dropdown
    methodLabels = {'Select Method...', ...
        'Lab 3: Rgb2Gray', 'Lab 3: Gray2Binary', 'Lab 3: RGB2Binary', ...
        'Lab 4: Brightness', 'Lab 4: Negative', 'Lab 4: Histogram', ...
        'Lab 5: Contrast Stretching', 'Lab 5: LOG', 'Lab 5: Gamma Correction', ...
        'Lab 5: Histogram Equalization', 'Lab 6: Mean Filter', ...
        'Lab 6: Weight Filter', 'Lab 6: Median Filter', ...
        'Lab 7: Salt & Pepper Noise', 'Lab 7: Gaussian Noise', ...
        'Lab 8: Ideal Low Pass', 'Lab 8: Ideal High Pass', ...
        'Custom: Low-Light Enhancement'};

    methodDropdown = uicontrol(controlPanel, 'Style', 'popupmenu', ...
        'String', methodLabels, 'Units','normalized', 'Position', [0.1 0.78 0.8 0.05], ...
        'Callback', @methodSelected, 'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');

    % Dynamic Parameter Container (Now lower to fill space)
    param1Label = uicontrol(controlPanel, 'Style', 'text', 'String', 'Parameter 1:', ...
        'Units','normalized', 'Position', [0.1 0.65 0.35 0.04], ...
        'HorizontalAlignment', 'left', 'Visible', 'off', 'BackgroundColor', panelColor, 'ForegroundColor', textColor);

    param1Edit = uicontrol(controlPanel, 'Style', 'edit', ...
        'Units','normalized', 'Position', [0.5 0.65 0.4 0.05], ...
        'Visible', 'off', 'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');

    % Custom Enhancement Panel
    customPanel = uipanel(controlPanel, 'Title', 'Low-Light Tool', ...
        'Units','normalized', 'Position', [0.1 0.5 0.8 0.22], ...
        'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor, 'Visible', 'off');

    uicontrol(customPanel, 'Style', 'text', 'String', 'Brightness:', ...
        'Units','normalized', 'Position', [0.1 0.6 0.8 0.2], ...
        'HorizontalAlignment', 'left', 'BackgroundColor', [0.25 0.25 0.25], 'ForegroundColor', textColor);

    brightnessSlider = uicontrol(customPanel, 'Style', 'slider', ...
        'Units','normalized', 'Position', [0.1 0.3 0.8 0.2], ...
        'Min', 0.1, 'Max', 2, 'Value', 1, 'Callback', @applyLowLightEnhancement);

    % Action buttons (Moved to bottom)
    uicontrol(controlPanel, 'Style', 'pushbutton', 'String', 'Apply', ...
        'Units','normalized', 'Position', [0.1 0.18 0.8 0.08], ...
        'Callback', @applyProcessing, 'BackgroundColor', btnGreen, 'ForegroundColor', 'white', 'FontSize', 12, 'FontWeight', 'bold');

    uicontrol(controlPanel, 'Style', 'pushbutton', 'String', 'Reset Image', ...
        'Units','normalized', 'Position', [0.1 0.1 0.38 0.06], ...
        'Callback', @resetImage, 'BackgroundColor', [0.4 0.4 0.4], 'ForegroundColor', 'white');

    uicontrol(controlPanel, 'Style', 'pushbutton', 'String', 'Save', ...
        'Units','normalized', 'Position', [0.52 0.1 0.38 0.06], ...
        'Callback', @saveImage, 'BackgroundColor', btnRed, 'ForegroundColor', 'white');

    % Callback functions
    function loadImage(~, ~)
        [file, path] = uigetfile({'*.jpg;*.png;*.bmp'}, 'Select Image');
        if isequal(file, 0)
            return;
        end
        img = imread(fullfile(path, file));
        processedImg = img;

        % Safe Octave drawing
        axes(axOriginal);
        imshow(img);
        axis image; % Locks aspect ratio

        axes(axProcessed);
        imshow(img);
        axis image; % Locks aspect ratio

        updateStatus('Image loaded successfully.');
    end

    function methodSelected(~, ~)
        % Reset all visibilities first to prevent UI freezing
        set([param1Label, param1Edit], 'Visible', 'off');
        set(customPanel, 'Visible', 'off');

        methodList = get(methodDropdown, 'String');
        selectedMethod = methodList{get(methodDropdown, 'Value')};

        switch selectedMethod
            case 'Lab 3: Gray2Binary'
                set(param1Label, 'String', 'Threshold (0-1):', 'Visible', 'on');
                set(param1Edit, 'String', '0.5', 'Visible', 'on');
            case 'Lab 4: Brightness'
                set(param1Label, 'String', 'Value:', 'Visible', 'on');
                set(param1Edit, 'String', '50', 'Visible', 'on');
            case 'Lab 6: Mean Filter'
                set(param1Label, 'String', 'Size (odd):', 'Visible', 'on');
                set(param1Edit, 'String', '3', 'Visible', 'on');
            case 'Lab 7: Salt & Pepper Noise'
                set(param1Label, 'String', 'Density:', 'Visible', 'on');
                set(param1Edit, 'String', '0.05', 'Visible', 'on');
            case 'Custom: Low-Light Enhancement'
                set(customPanel, 'Visible', 'on');
        end
    end

    function applyProcessing(~, ~)
        if isempty(img)
            updateStatus('Error: No image loaded.');
            return;
        end
        methodList = get(methodDropdown, 'String');
        selectedMethod = methodList{get(methodDropdown, 'Value')};

        try
            switch selectedMethod
                case 'Lab 4: Brightness'
                    value = str2double(get(param1Edit, 'String'));
                    processedImg = adjustBrightness(img, value);
                % --- ADD YOUR OTHER LAB CASES HERE JUST LIKE BEFORE ---
                case 'Lab 4: Negative'
                    processedImg = negative(img);
                otherwise
                    updateStatus('Method not implemented yet or select a valid method.');
                    return;
            end

            % Safe Octave drawing
            axes(axProcessed);
            imshow(processedImg);
            axis image;

            updateStatus(['Applied: ' selectedMethod]);
        catch ME
            updateStatus(['Error: ' ME.message]);
        end
    end

    function resetImage(~, ~)
        if ~isempty(img)
            processedImg = img;
            axes(axProcessed);
            imshow(processedImg);
            axis image;
            updateStatus('Image reset to original.');
        end
    end

    function saveImage(~, ~)
        if isempty(processedImg)
            return;
        end
        [file, path] = uiputfile({'*.jpg';'*.png';'*.bmp'}, 'Save As');
        if ~isequal(file, 0)
            imwrite(processedImg, fullfile(path, file));
            updateStatus(['Saved: ' file]);
        end
    end

    function applyLowLightEnhancement(~, ~)
        if isempty(img)
            return;
        end
        gamma = get(brightnessSlider, 'Value');
        processedImg = imadjust(img, [], [], gamma);

        axes(axProcessed);
        imshow(processedImg);
        axis image;

        updateStatus('Low-light enhancement applied.');
    end

    function updateStatus(message)
        set(statusBar, 'String', [' ' message]);
        drawnow;
    end
end
