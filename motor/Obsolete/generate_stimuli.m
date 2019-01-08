function [onsets, events] = generate_stimuli(n_bitmaps,scan_period, isi_min, isi_max, max_dur)
%GENERATE_STIMULI write stimuli (onsets and bitmaps) in the correct scheme 
% folder
%(condition, scan_period, isi_min, isi_max, max_dur)
% INPUTS:
%   condition : str
%     one of 'practice', 'IEMU', 'fMRI' (case is important)
%   scan_period : int
%     should be identical to the value of "scan_period" in the Presentation
%     file
%   isi_min : int
%     mininum inter-stimulus distance, between onset times, in s
%   isi_max : int
%     maximum inter-stimulus distance, between onset times, in s
%   max_dur : int
%     maximum duration of the whole task, in s
%
% EXAMPLES:
%   generate_stimuli('practice', 1000, 4, 6, 300)
%
%   generate_stimuli('fMRI', 850, 6, 15, 480)
%
%   generate_stimuli('IEMU', 1000, 4, 6, 480)
%
% gio@gpiantoni.com  2018/09/26

% n_bitmaps = 4;
% convert from seconds to scans
isi_min = round(isi_min / scan_period * 1000);
isi_max = round(isi_max / scan_period * 1000);
max_dur = round(max_dur / scan_period * 1000);

% PATHS 
dir_output = fullfile(sensorimotorRootPath , 'motor','UMCU-Stimuli');
 
file_onsets = fullfile(dir_output, 'picture_onset_sequence.txt');
file_bitmaps = fullfile(dir_output, 'bitmap_filename_sequence.txt');
%file_codes = fullfile(dir_output, 'picture_port_code_sequence.txt');

% NUMBER OF EVENTS
n_events = floor(max_dur / ((isi_max + isi_min) / 2));

% ONSETS
isi = [1; randi(isi_max - isi_min + 1, n_events - 1, 1) + isi_min - 1];
onsets = cumsum(isi);

% EVENTS
events = randi(n_bitmaps, n_events, 1);
