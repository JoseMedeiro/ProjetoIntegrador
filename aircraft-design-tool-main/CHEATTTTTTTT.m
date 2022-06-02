clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 36;

file_write = fopen('eff_lines.txt','w');
folder = "graphs";
files_names = [ "eff_20.jpg";...
                "eff_30.jpg";...
                "eff_40.jpg";...
                "eff_50.jpg";...
                "eff_60.jpg";...
                "eff_70.jpg";...
                "eff_75.jpg";...
                "eff_80_a.jpg";...
                "eff_80_b.jpg";...
                "eff_85_a.jpg";...
                "eff_85_b.jpg";...
                "eff_90_a.jpg";...
                "eff_90_b.jpg"];
            
efficiencies = [0.2;...
                0.3;...
                0.4;...
                0.5;...
                0.6;...
                0.7;...
                0.75;...
                0.8;...
                0.8;...
                0.85;...
                0.85;...
                0.9;...
                0.9];

for a=1:length(files_names)
    
    close all;  % Close all figures (except those of imtool.)
    imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
    %===============================================================================
    % Get the full filename, with path prepended.
    fullFileName = fullfile(folder, files_names(a));
    if ~exist(fullFileName, 'file')
      % Didn't find it there.  Check the search path for it.
      fullFileName = files_names(a); % No path this time.
      if ~exist(fullFileName, 'file')
        % Still didn't find it.  Alert user.
        errorMessage = sprintf('Error: %s does not exist.', fullFileName);
        uiwait(warndlg(errorMessage));
        return;
      end
    end
    rgbImage = imread(fullFileName);
    % Get the dimensions of the image.  numberOfColorBands should be = 3.
    [rows, columns, numberOfColorBands] = size(rgbImage);
    % Display the original color image.
    subplot(2, 2, 1);
    imshow(rgbImage);
    axis on;
    title('Original Color Image', 'FontSize', fontSize);
    % Enlarge figure to full screen.
    set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
    % Extract the individual red, green, and blue color channels.
    % redChannel = rgbImage(:, :, 1);
    greenChannel = rgbImage(:, :, 2);
    % blueChannel = rgbImage(:, :, 3);
    % Get the binaryImage
    binaryImage = greenChannel < 200;
    % Display the original color image.
    subplot(2, 2, 2);
    imshow(binaryImage);
    axis on;
    title('Binary Image', 'FontSize', fontSize);
    % Find the baseline
    verticalProfile  = sum(binaryImage, 2);
    lastLine = size(greenChannel,1);
    % Scan across columns finding where the top of the hump is
    for col = 1 : columns
      yy = lastLine - find(binaryImage(:, col), 1, 'first');
      if isempty(yy)
        y(col) = NaN;
      else
        y(col) = yy;
      end
    end
    subplot(2, 2, 3);
    plot(1 : columns, y, 'b-', 'LineWidth', 3);
    grid on;
    title('Y vs. X', 'FontSize', fontSize);
    ylabel('Y', 'FontSize', fontSize);
    xlabel('X', 'FontSize', fontSize);

    for c=1:columns
        if(~isnan(y(c)))
            fprintf(file_write,"%f %f %.2f \n",c/52*0.2,y(c)/90*0.1,efficiencies(a));
        end
    end

end

fclose all;