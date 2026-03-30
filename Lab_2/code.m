clc;
clear;
close all;

%% 1. Завантаження тестових зображень
I1 = imread('cameraman.tif');
I2 = imread('coins.png');

%% 2. Відображення оригіналів
figure('Name','Original Images');
subplot(1,2,1), imshow(I1), title('Original 1');
subplot(1,2,2), imshow(I2), title('Original 2');

%% 3. Додавання шуму
% Гаусівський шум
I1_gauss = imnoise(I1, 'gaussian', 0, 0.01);
I2_gauss = imnoise(I2, 'gaussian', 0, 0.01);

% Імпульсний шум (salt & pepper)
I1_sp = imnoise(I1, 'salt & pepper', 0.05);
I2_sp = imnoise(I2, 'salt & pepper', 0.1);

%% 4. Відображення шумів
figure('Name','Noisy Images');
subplot(2,2,1), imshow(I1_gauss), title('Gaussian Noise 1');
subplot(2,2,2), imshow(I2_gauss), title('Gaussian Noise 2');
subplot(2,2,3), imshow(I1_sp), title('Salt & Pepper 1');
subplot(2,2,4), imshow(I2_sp), title('Salt & Pepper 2');

%% 5. Лінійна фільтрація
% Низькочастотний (усереднення)
h_low = fspecial('average', [3 3]);

% Високочастотний (контур)
h_high = fspecial('laplacian', 0.2);

I1_low = imfilter(I1, h_low);
I1_high = imfilter(I1, h_high);

%% 6. Відображення після фільтрації
figure('Name','Filtered Original');
subplot(1,3,1), imshow(I1), title('Original');
subplot(1,3,2), imshow(I1_low), title('Low-pass');
subplot(1,3,3), imshow(I1_high), title('High-pass');

%% 7. Фільтрація шумних зображень
I_gauss_low = imfilter(I1_gauss, h_low);
I_sp_low = imfilter(I1_sp, h_low);

figure('Name','Filtered Noisy');
subplot(1,2,1), imshow(I_gauss_low), title('Gaussian + Low-pass');
subplot(1,2,2), imshow(I_sp_low), title('SaltPepper + Low-pass');

%% 8. Вінерівський фільтр
I_wiener = wiener2(I1_gauss, [5 5]);

figure;
imshow(I_wiener), title('Wiener Filter');

%% 9. Медіанний фільтр
I_median = medfilt2(I1_sp, [3 3]);

figure;
imshow(I_median), title('Median Filter');
