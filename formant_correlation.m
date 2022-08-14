% Kristin Teplansky - updated 08-13-22
% Exploratory speech subsystem coordination project

% Next steps:
% Data visualization
% Determine if upsampling value is accurate from resample3
% Understand singular value decomposition and apply
% Make code more efficient if project is interesting

%% Load data
clear; clc;
filename = 'praat_formants.mat';
load(filename);

%% Correct missing formant tracks using spline interpolation

[total_subjects, ~] = size(praat_formants.subject);
[~, total_datasets] = size(praat_formants.data);

formants_interpl = [];
data_interpl = {};

for iSubject = 1:total_subjects

    subject_rep = [];

    for iDataset = 1:total_datasets

        [~, praat_data] = size(praat_formants.data{iDataset});
        stimuli_rep = praat_formants.data{iSubject, iDataset};
        time = stimuli_rep(:,1);

        % Correct nan's using spline interpolation
        for iFormant = 1:praat_data
            col = stimuli_rep(:, iFormant);
            col(isnan(col)) = interp1(find(~isnan(col)), col(~isnan(col)), find(isnan(col)),'spline');
            formants_interpl = [formants_interpl, col];
        end

        data_interpl{iSubject, iDataset} = formants_interpl;
        formants_interpl = [];

    end
    save('data_interpl');

end % end of loop

%% Resample Data to Fixed Length

clc; clear
filename = 'data_interpl';
load(filename);

[total_subjects, stimuli_reps] = size(data_interpl);

number_cols = 4;

for iParticipant = 1:total_subjects

    participant_mean_length = round(mean(cellfun('length', data_interpl(iParticipant,:))));
    resampled_rep = zeros(participant_mean_length, number_cols);

    for iRep = 1:4

        formant_data = data_interpl{1, iRep};
        
        % Resample data using the mean participant length of reps
        for iFormant = 1:4
            formant_col = formant_data(:, iFormant);
            resampled_formant_col = resample3(formant_col, participant_mean_length); % resample3 by Dr. Alan Wisler
            resampled_rep(:, iFormant) = resampled_formant_col';
        end

        data_resampled{iParticipant, iRep} = resampled_rep;

    end
    save('data_resampled'); 

end % end of loop

%% Cross-correlation analysis / Eigen value decomposition / SVD

% output eigenvalues and eigen vector
% [V, D] = eig(formants_interpl, 'matrix')

clc; clear;
filename = 'data_resampled';
load(filename); 







%% Data Visualization 





