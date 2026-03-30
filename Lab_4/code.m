%% 1. Завантаження зображень
I1 = imread('cameraman.tif');
I2 = imread('coins.png');

figure('Name','Original Images');
subplot(1,2,1), imshow(I1), title('Image 1');
subplot(1,2,2), imshow(I2), title('Image 2');

%% 2. FFT (спектр)
F1 = fft2(double(I1));
F2 = fft2(double(I2));

% логарифмічний масштаб
S1 = log(1 + abs(F1));
S2 = log(1 + abs(F2));

figure('Name','Spectrum (without shift)');
subplot(1,2,1), imshow(mat2gray(S1)), title('Spectrum 1');
subplot(1,2,2), imshow(mat2gray(S2)), title('Spectrum 2');

%% 3. Центрування спектра
F1_shift = fftshift(F1);
F2_shift = fftshift(F2);

S1_shift = log(1 + abs(F1_shift));
S2_shift = log(1 + abs(F2_shift));

figure('Name','Centered Spectrum');
subplot(1,2,1), imshow(mat2gray(S1_shift)), title('Centered 1');
subplot(1,2,2), imshow(mat2gray(S2_shift)), title('Centered 2');

%% 4. Відновлення зображення
I1_rec1 = real(ifft2(F1)); % без shift
I1_rec2 = real(ifft2(ifftshift(F1_shift))); % з shift

figure('Name','Reconstruction');
subplot(1,3,1), imshow(I1,[]), title('Original');
subplot(1,3,2), imshow(I1_rec1,[]), title('Reconstructed (no shift)');
subplot(1,3,3), imshow(I1_rec2,[]), title('Reconstructed (with shift)');

%% 5. Gaussian фільтр
h1 = fspecial('gaussian', [20 20], 2);

figure;
imshow(mat2gray(h1)), title('Gaussian Filter (sigma=2)');

%% 6. Частотна характеристика
H1 = fftshift(fft2(h1, size(I1,1), size(I1,2)));
figure;
imshow(mat2gray(log(1 + abs(H1)))), title('Frequency Response (sigma=2)');

%% 7. Зміна sigma
h2 = fspecial('gaussian', [20 20], 5);

figure;
imshow(mat2gray(h2)), title('Gaussian Filter (sigma=5)');

H2 = fftshift(fft2(h2, size(I1,1), size(I1,2)));
figure;
imshow(mat2gray(log(1 + abs(H2)))), title('Frequency Response (sigma=5)');

%% 8. Фільтрація у частотній області
F = fft2(double(I1));
H = fft2(h1, size(I1,1), size(I1,2));

G = F .* H;
I_freq = real(ifft2(G));

figure;
subplot(1,2,1), imshow(I1,[]), title('Original');
subplot(1,2,2), imshow(I_freq,[]), title('Filtered (Frequency)');

%% 9. Фільтрація у просторовій області
I_spatial = imfilter(I1, h1);

figure;
subplot(1,2,1), imshow(I_freq,[]), title('Frequency');
subplot(1,2,2), imshow(I_spatial,[]), title('Spatial');