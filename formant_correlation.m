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

        participant_mean_length = round(mean(cellfun('length', praat_formants.data(iSubject,:))));


        for iFormant = 1:praat_data
            
            col = stimuli_rep(:, iFormant);

            % Correct nan's using spline interpolation
            col(isnan(col)) = interp1(find(~isnan(col)), col(~isnan(col)), find(isnan(col)),'spline');
            formants_interpl = [formants_interpl, col];


            % Resample data using the mean participant length of reps
            resampled_formant_col = resample3(formants_interpl, participant_mean_length); 
            resampled_rep(:, iFormant) = resampled_formant_col'; 
           
        end

        data_interpl{iSubject, iDataset} = formants_interpl;
        formants_interpl = [];

        data_resampled{iSubject, iDataset} = resampled_rep;

    end
    save('data_interpl');
    save('data_resampled');

end % end of loop


%% Cross-correlation analysis / Eigen value decomposition / SVD

% output eigenvalues and eigen vector
% [V, D] = eig(formants_interpl, 'matrix')

clc; clear;
filename = 'data_resampled';
load(filename); 


%% Data Visualization 

participant = 1; 
rep = 1; 
formant = 2; 
time_col = 1;

x_time = praat_formants.data{participant, rep}(:, time_col);
original_fo = praat_formants.data{participant, rep}(:, formant); 
interpl_fo = data_interpl{participant, rep}(:, formant);

plot(x_time, original_fo, '-', ...
    x_time, interpl_fo, '.')
legend('Original Signal', 'Interpl (spline')



