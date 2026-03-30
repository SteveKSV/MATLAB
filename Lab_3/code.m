%% 1. Завантаження зображення
I = imread('cameraman.tif');

%% 2. Відображення оригіналу
figure('Name','Original Image');
imshow(I);
title('Original Image');

%% 3. Перекручення (розмиття рухом)
LEN = 15;      % довжина розмиття
THETA = 30;    % кут розмиття

PSF = fspecial('motion', LEN, THETA);
I_blur = imfilter(I, PSF, 'conv', 'circular');

%% 4. Відображення перекрученого зображення
figure('Name','Blurred Image');
imshow(I_blur);
title(['Blurred Image (LEN=', num2str(LEN), ', THETA=', num2str(THETA), ')']);

%% 5. Відновлення зображення (без шуму)
I_restored = deconvwnr(I_blur, PSF);

%% 6. Відображення відновленого зображення
figure('Name','Restoration without Noise');
subplot(1,3,1), imshow(I), title('Original');
subplot(1,3,2), imshow(I_blur), title('Blurred');
subplot(1,3,3), imshow(I_restored), title('Restored');

%% 7. Додавання шуму
I_noise = imnoise(I, 'gaussian', 0, 0.001);

figure('Name','Noisy Image');
imshow(I_noise);
title('Gaussian Noise');

%% Повторення перекручення для шумного зображення
I_blur_noise = imfilter(I_noise, PSF, 'conv', 'circular');

%% Відновлення шумного зображення
I_restored_noise = deconvwnr(I_blur_noise, PSF);

%% Відображення результатів з шумом
figure('Name','Restoration with Noise');
subplot(1,3,1), imshow(I_noise), title('Noisy');
subplot(1,3,2), imshow(I_blur_noise), title('Blur + Noise');
subplot(1,3,3), imshow(I_restored_noise), title('Restored');

%% Додатково (краще відновлення з Wiener параметром)
noise_var = 0.001;
I_restored_better = deconvwnr(I_blur_noise, PSF, noise_var);

figure('Name','Improved Restoration');
subplot(1,2,1), imshow(I_restored_noise), title('Basic Wiener');
subplot(1,2,2), imshow(I_restored_better), title('Improved Wiener');