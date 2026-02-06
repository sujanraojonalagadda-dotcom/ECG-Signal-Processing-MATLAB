clc;
clear;
close all;

%% Step 1: Parameters
fs = 360;                % Sampling frequency (Hz)
t = 0:1/fs:10;           % Time vector (10 seconds)

%% Step 2: Generate ECG-like Signal
ecg_clean = sin(2*pi*1.3*t) + 0.5*sin(2*pi*2.6*t);

%% Step 3: Add Noise
noise = 0.3*randn(size(t));
ecg_noisy = ecg_clean + noise;

%% Step 4: Noise Removal (Butterworth Filter)
fc = 40;                           
[b,a] = butter(4, fc/(fs/2));     
ecg_filtered = filtfilt(b,a,ecg_noisy);

%% Step 5: R-Peak Detection
[peaks, locs] = findpeaks(ecg_filtered,...
    'MinPeakHeight',0.5,...
    'MinPeakDistance',0.5*fs);

%% Step 6: Heart Rate Calculation
RR_intervals = diff(locs)/fs;     
heart_rate = 60./RR_intervals;    
avg_HR = mean(heart_rate);

%% Step 7: Abnormality Detection
if avg_HR < 60
    condition = 'BRADYCARDIA (Low Heart Rate)';
    color = 'b';
elseif avg_HR > 100
    condition = 'TACHYCARDIA (High Heart Rate)';
    color = 'r';
else
    condition = 'NORMAL HEART RATE';
    color = 'g';
end

%% Step 8: Plot Results
figure;

subplot(3,1,1);
plot(t, ecg_noisy);
title('Noisy ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, ecg_filtered);
hold on;
plot(locs/fs, peaks, 'ro');
title('Filtered ECG with Detected R-Peaks');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(heart_rate, color, 'LineWidth', 2);
title(['Heart Rate Analysis | Avg = ', num2str(avg_HR,'%.2f'), ...
       ' BPM | ', condition]);
xlabel('Beat Number');
ylabel('BPM');
grid on;